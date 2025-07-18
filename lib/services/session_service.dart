import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' show parse;
import 'http_logger.dart';

class SessionService {
  static const String _csrfTokenKey = 'csrf_token';
  static const String _sessionKeyKey = 'session_key';
  static const String _sessionIdCookieKey = 'sessionid';
  static const String _csrfCookieKey = 'csrftoken';
  static const String _clearFilesKey = 'clear_files';
  
  static SessionService? _instance;
  
  String? _csrfToken;
  String? _sessionKey;
  Map<String, String> _cookies = {};
  
  // Singleton instance
  static SessionService get instance {
    _instance ??= SessionService._();
    return _instance!;
  }
  
  SessionService._();
  
  // Getters
  String? get csrfToken => _csrfToken;
  String? get sessionKey => _sessionKey;
  Map<String, String> get cookies => _cookies;
  
  // Generate a UUID string for consistent session keys
  String _generateUUID() {
    // This creates a timestamp-based pseudo-UUID
    final now = DateTime.now();
    final part1 = now.microsecondsSinceEpoch.toRadixString(16).padLeft(12, '0');
    final part2 = (now.millisecond * 1000 + now.microsecond).toRadixString(16).padLeft(5, '0');
    
    // Combine parts to form a UUID-like structure
    final hexString = '$part1$part2'.padRight(32, '0');
    
    return '${hexString.substring(0, 8)}-${hexString.substring(8, 12)}-${hexString.substring(12, 16)}-${hexString.substring(16, 20)}-${hexString.substring(20, 32)}';
  }

  // Load from storage on app start
  Future<void> loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _csrfToken = prefs.getString(_csrfTokenKey);
    _sessionKey = prefs.getString(_sessionKeyKey);
    
    // If we don't have a session key, generate one and store it
    // This ensures the same session key is used across app sessions
    if (_sessionKey == null || _sessionKey!.isEmpty) {
      // Generate and save a persistent session key that will be used for file paths
      await setSessionKey(_generateUUID());
      print('DEBUG: Generated new session key: $_sessionKey');
    } else {
      print('DEBUG: Using existing session key: $_sessionKey');
    }
    
    // If we don't have a CSRF token, try to get one from the server
    if (_csrfToken == null || _csrfToken!.isEmpty) {
      await fetchCsrfTokenFromHomePage();
    }
  }
  
  // Fetch CSRF token from Django homepage (or any page)
  // Public method so it can be called from outside when needed
  Future<void> fetchCsrfTokenFromHomePage() async {
    // Create a logging client
    final client = LoggingHttpClient(http.Client());
    
    try {
      // Make a GET request to the homepage or any Django page
      final uri = Uri.parse('http://192.168.1.205:8080/');
      
      final response = await client.get(uri);
      
      // Response is already logged by LoggingHttpClient
      
      // Extract CSRF token from cookies
      _extractCookiesFromResponse(response);
      
      // Extract CSRF token from HTML content if available
      if (response.statusCode == 200) {
        _extractCsrfTokenFromHtml(response.body);
      }
      
    } catch (e) {
      print('Error fetching CSRF token: $e');
    } finally {
      // Don't forget to close the client
      client.close();
    }
  }
  
  // Extract cookies from HTTP response
  void _extractCookiesFromResponse(http.Response response) {
    String? rawCookies = response.headers['set-cookie'];
    if (rawCookies != null) {
      List<String> cookiesList = rawCookies.split(',');
      
      for (var cookieString in cookiesList) {
        List<String> cookies = cookieString.split(';');
        for (var cookie in cookies) {
          if (cookie.trim().isNotEmpty) {
            List<String> keyValue = cookie.trim().split('=');
            if (keyValue.length == 2) {
              String key = keyValue[0].trim();
              String value = keyValue[1].trim();
              
              _cookies[key] = value;
              
              // Extract CSRF token from cookies
              if (key.toLowerCase() == _csrfCookieKey.toLowerCase()) {
                setCsrfToken(value);
              }
              
              // Extract session ID if needed
              if (key.toLowerCase() == _sessionIdCookieKey.toLowerCase()) {
                // You can save the sessionid cookie if needed
                // This could be useful for certain Django setups
              }
            }
          }
        }
      }
    }
  }
  
  // Extract CSRF token from HTML content
  void _extractCsrfTokenFromHtml(String htmlBody) {
    try {
      final document = parse(htmlBody);
      
      // Look for the CSRF token in a meta tag
      final metaTag = document.querySelector('meta[name="csrf-token"]');
      if (metaTag != null) {
        final token = metaTag.attributes['content'];
        if (token != null && token.isNotEmpty) {
          setCsrfToken(token);
          return;
        }
      }
      
      // Look for the CSRF token in a hidden input field (Django's typical approach)
      final inputTag = document.querySelector('input[name="csrfmiddlewaretoken"]');
      if (inputTag != null) {
        final token = inputTag.attributes['value'];
        if (token != null && token.isNotEmpty) {
          setCsrfToken(token);
          return;
        }
      }
    } catch (e) {
      print('Error extracting CSRF token from HTML: $e');
    }
  }
  
  // Update CSRF token
  Future<void> setCsrfToken(String? token) async {
    if (token == null || token.isEmpty) return;
    
    _csrfToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_csrfTokenKey, token);
  }
  
  // Update session key
  Future<void> setSessionKey(String? key) async {
    if (key == null || key.isEmpty) return;
    
    // Check if we already have a session key - prefer keeping the existing one
    // unless forced to update with forceUpdate parameter
    if (_sessionKey == null || _sessionKey!.isEmpty) {
      _sessionKey = key;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_sessionKeyKey, key);
      print('DEBUG: Session key set: $_sessionKey');
    } else {
      // If server returns a new session key, log it but don't replace our stable key
      // This ensures file paths remain consistent
      print('DEBUG: Server provided new session key ($key) but keeping existing key ($_sessionKey) for consistency');
    }
  }
  
  // Use this method when you explicitly need to update the session key
  Future<void> forceUpdateSessionKey(String? key) async {
    if (key == null || key.isEmpty) return;
    
    _sessionKey = key;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKeyKey, key);
    print('DEBUG: Session key forcefully updated to: $_sessionKey');
  }
  
  // Clear session data
  Future<void> clearSession() async {
    _csrfToken = null;
    _sessionKey = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_csrfTokenKey);
    await prefs.remove(_sessionKeyKey);
  }
  
  // Add CSRF token and session key to headers
  Map<String, String> getAuthHeaders({Map<String, String>? baseHeaders}) {
    final headers = baseHeaders ?? <String, String>{};
    
    if (_csrfToken != null) {
      headers['X-CSRFToken'] = _csrfToken!;
    }
    
    // Add cookies as a Cookie header if needed
    if (_cookies.isNotEmpty) {
      final cookieString = _cookies.entries
          .map((e) => '${e.key}=${e.value}')
          .join('; ');
      headers['Cookie'] = cookieString;
    }
    
    return headers;
  }
  
  // Add session key to a request body
  Map<String, dynamic> addSessionToBody(Map<String, dynamic> body) {
    if (_sessionKey != null) {
      body['session_key'] = _sessionKey!;
      body['upload_session_key'] = _sessionKey!; // Add the key Django expects
    }
    return body;
  }
  
  // Create an authenticated request with all headers and cookies
  http.Request createAuthenticatedRequest(String method, Uri url, {Map<String, dynamic>? body}) {
    final request = http.Request(method, url);
    
    // Add headers including CSRF token and cookies
    request.headers.addAll(getAuthHeaders());
    
    // Add body with session key if provided
    if (body != null) {
      final finalBody = addSessionToBody(body);
      request.body = jsonEncode(finalBody);
      request.headers['Content-Type'] = 'application/json';
      
      // Log the request
      HttpLogger.logRequest(method, url, headers: request.headers, body: finalBody);
    } else {
      // Log the request without body
      HttpLogger.logRequest(method, url, headers: request.headers);
    }
    
    return request;
  }
  
  // Set a flag to clear files on next app start
  Future<void> setClearFilesFlag(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_clearFilesKey, value);
    print('DEBUG: Set clear files flag to $value');
  }
  
  // Check if files should be cleared
  Future<bool> shouldClearFiles() async {
    final prefs = await SharedPreferences.getInstance();
    final shouldClear = prefs.getBool(_clearFilesKey) ?? false;
    
    // Reset the flag once read
    if (shouldClear) {
      await prefs.setBool(_clearFilesKey, false);
    }
    
    return shouldClear;
  }
}
