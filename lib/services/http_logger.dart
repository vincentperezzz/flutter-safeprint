import 'dart:convert';
import 'package:http/http.dart' as http;

/// A utility class to log HTTP requests and responses
class HttpLogger {
  static bool _enabled = true;

  /// Enable or disable HTTP logging
  static void setEnabled(bool enabled) {
    _enabled = enabled;
  }

  /// Log an HTTP request
  static void logRequest(String method, Uri url, {Map<String, String>? headers, dynamic body}) {
    if (!_enabled) return;
    
    print('┌────────────────────────────────────────────────────────────────────────────────────');
    print('│ 🚀 REQUEST: $method ${url.toString()}');
    print('├────────────────────────────────────────────────────────────────────────────────────');
    
    if (headers != null && headers.isNotEmpty) {
      print('│ HEADERS:');
      headers.forEach((key, value) {
        // Hide sensitive information in headers (like auth tokens)
        if (key.toLowerCase().contains('auth') || 
            key.toLowerCase().contains('token') || 
            key.toLowerCase().contains('csrf')) {
          print('│   $key: ${_maskSensitiveData(value)}');
        } else {
          print('│   $key: $value');
        }
      });
    }
    
    if (body != null) {
      print('│ BODY:');
      try {
        // If body is a MultipartRequest, log all fields and files
        if (body is http.MultipartRequest) {
          if (body.fields.isNotEmpty) {
            print('│   FIELDS:');
            body.fields.forEach((key, value) {
              print('│     $key: $value');
            });
          }
          if (body.files.isNotEmpty) {
            print('│   FILES:');
            for (final file in body.files) {
              print('│     ${file.field}: ${file.filename} (${file.length} bytes)');
            }
          }
        } else if (body is String) {
          if (_isJsonString(body)) {
            // Pretty print JSON
            final dynamic parsedJson = jsonDecode(body);
            final String prettyJson = const JsonEncoder.withIndent('  ').convert(parsedJson);
            final List<String> lines = prettyJson.split('\n');
            for (final line in lines) {
              print('│   $line');
            }
          } else {
            print('│   $body');
          }
        } else if (body is Map) {
          body.forEach((key, value) {
            print('│   $key: $value');
          });
        } else {
          print('│   $body');
        }
      } catch (e) {
        print('│   Failed to parse body: $e');
        print('│   Raw body: $body');
      }
    }
    
    print('└────────────────────────────────────────────────────────────────────────────────────');
  }

  /// Log an HTTP response
  static void logResponse(http.Response response, {Duration? duration}) {
    if (!_enabled) return;
    
    final statusColor = _getStatusColor(response.statusCode);
    final durationStr = duration != null ? ' (${duration.inMilliseconds}ms)' : '';
    
    print('┌────────────────────────────────────────────────────────────────────────────────────');
    print('│ 📥 RESPONSE: ${response.statusCode} $statusColor${response.reasonPhrase ?? ""}$durationStr');
    print('├────────────────────────────────────────────────────────────────────────────────────');
    
    if (response.headers.isNotEmpty) {
      print('│ HEADERS:');
      response.headers.forEach((key, value) {
        print('│   $key: $value');
      });
    }
    
    if (response.body.isNotEmpty) {
      print('│ BODY:');
      try {
        if (_isJsonString(response.body)) {
          // Pretty print JSON
          final dynamic parsedJson = jsonDecode(response.body);
          final String prettyJson = const JsonEncoder.withIndent('  ').convert(parsedJson);
          final List<String> lines = prettyJson.split('\n');
          for (final line in lines) {
            print('│   $line');
          }
        } else {
          // For non-JSON responses, limit the output length
          final String truncatedBody = response.body.length > 1000 
              ? '${response.body.substring(0, 1000)}... (${response.body.length} chars total)'
              : response.body;
          print('│   $truncatedBody');
        }
      } catch (e) {
        print('│   Failed to parse response body: $e');
        print('│   Raw body: ${response.body.substring(0, min(1000, response.body.length))}');
      }
    }
    
    print('└────────────────────────────────────────────────────────────────────────────────────');
  }
  
  /// Mask sensitive data for logging
  static String _maskSensitiveData(String value) {
    if (value.length <= 8) {
      return '********';
    }
    
    // Show first 4 and last 4 characters
    return '${value.substring(0, 4)}****${value.substring(value.length - 4)}';
  }
  
  /// Check if a string is valid JSON
  static bool _isJsonString(String str) {
    try {
      jsonDecode(str);
      return true;
    } catch (_) {
      return false;
    }
  }
  
  /// Get status color emoji based on HTTP status code
  static String _getStatusColor(int statusCode) {
    if (statusCode >= 200 && statusCode < 300) {
      return '✅ '; // Success
    } else if (statusCode >= 300 && statusCode < 400) {
      return '🔄 '; // Redirection
    } else if (statusCode >= 400 && statusCode < 500) {
      return '⚠️ '; // Client Error
    } else if (statusCode >= 500) {
      return '🔥 '; // Server Error
    }
    return '❓ '; // Unknown
  }
  
  /// Helper function to get minimum of two integers
  static int min(int a, int b) => a < b ? a : b;
}

/// Extension on HttpClient to make logging easier
extension HttpClientLoggingExtension on http.Client {
  Future<http.Response> loggedPost(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    HttpLogger.logRequest('POST', url, headers: headers, body: body);
    final stopwatch = Stopwatch()..start();
    final response = await post(url, headers: headers, body: body, encoding: encoding);
    stopwatch.stop();
    HttpLogger.logResponse(response, duration: stopwatch.elapsed);
    return response;
  }
  
  Future<http.Response> loggedGet(Uri url, {Map<String, String>? headers}) async {
    HttpLogger.logRequest('GET', url, headers: headers);
    final stopwatch = Stopwatch()..start();
    final response = await get(url, headers: headers);
    stopwatch.stop();
    HttpLogger.logResponse(response, duration: stopwatch.elapsed);
    return response;
  }
  
  Future<http.Response> loggedPut(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    HttpLogger.logRequest('PUT', url, headers: headers, body: body);
    final stopwatch = Stopwatch()..start();
    final response = await put(url, headers: headers, body: body, encoding: encoding);
    stopwatch.stop();
    HttpLogger.logResponse(response, duration: stopwatch.elapsed);
    return response;
  }
  
  Future<http.Response> loggedDelete(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    HttpLogger.logRequest('DELETE', url, headers: headers, body: body);
    final stopwatch = Stopwatch()..start();
    final response = await delete(url, headers: headers, body: body, encoding: encoding);
    stopwatch.stop();
    HttpLogger.logResponse(response, duration: stopwatch.elapsed);
    return response;
  }
}

/// Create a logging client that wraps a regular http.Client
class LoggingHttpClient extends http.BaseClient {
  final http.Client _inner;
  
  LoggingHttpClient(this._inner);
  
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Log the request
    final requestBody = request is http.Request ? request.body : null;
    HttpLogger.logRequest(request.method, request.url, headers: request.headers, body: requestBody);
    
    // Send the request and time it
    final stopwatch = Stopwatch()..start();
    final response = await _inner.send(request);
    stopwatch.stop();
    
    // Create a copy of the response so we can read the body
    final responseBytes = await response.stream.toBytes();
    final responseString = utf8.decode(responseBytes, allowMalformed: true);
    
    // Log the response
    HttpLogger.logResponse(
      http.Response(
        responseString, 
        response.statusCode,
        headers: response.headers,
        request: request,
        reasonPhrase: response.reasonPhrase,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
      ),
      duration: stopwatch.elapsed,
    );
    
    // Return a new response with the same content
    return http.StreamedResponse(
      Stream.value(responseBytes),
      response.statusCode,
      headers: response.headers,
      contentLength: responseBytes.length,
      isRedirect: response.isRedirect,
      persistentConnection: response.persistentConnection,
      reasonPhrase: response.reasonPhrase,
    );
  }
}
