import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'feedback_form_page.dart';
import 'help_page.dart';
import 'faq_page.dart';
import 'about_us_page.dart';
import 'uploaded_documents_preview_page.dart';
import 'package:http_parser/http_parser.dart';
import 'services/session_service.dart';
import 'services/http_logger.dart';

void main() {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  
  runApp(const SampleApp());
}

class SampleApp extends StatefulWidget {
  const SampleApp({super.key});

  @override
  State<SampleApp> createState() => _SampleAppState();
}

class _SampleAppState extends State<SampleApp> {
  int _selectedIndex = 0;

   List<Widget> get _pages => [
    MediaUploadPage(),        // index 0
    FeedbackFormPage(),       // index 1
    HelpPage(),               // index 2
    FAQPage(),                // index 3  
    AboutUsPage(              // index 4
      onNavigate: (int index) {
        setState(() {
          _selectedIndex = index;
        });
      },
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: Colors.white,
        ),
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 70,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
                child: Row(
                  children: [
                    Image.asset(
                      'assets/nanoprint-logo.png',
                      width: 70,
                      height: 70,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBB41D),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "NanoPrint",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                              fontFamily: 'SpaceGrotesk',
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE7E7E7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Powered by SafePrint",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              fontFamily: 'SpaceGrotesk',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              ),
            ),
          ],
        ),
        endDrawer: Builder(
          builder: (drawerContext) => Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color(0xFFFBB41D),
                  ),
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontFamily: 'SpaceGrotesk',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text(
                    'Help',
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                    Navigator.of(drawerContext).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.question_answer),
                  title: const Text(
                    'FAQs',
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 3;
                    });
                    Navigator.of(drawerContext).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text(
                    'About Us',
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 4;
                    });
                    Navigator.of(drawerContext).pop();
                  },
                ),
              ],
            ),
          ),
        ),

        body: _pages[_selectedIndex],
        bottomNavigationBar: (_selectedIndex == 0 || _selectedIndex == 1)
          ? BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.cloud_upload),
                  label: 'File Upload',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.feedback),
                  label: 'Feedback Form',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.blue,
              onTap: _onItemTapped,
              selectedLabelStyle: const TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
      ),
    );
  }
}

class MediaUploadPage extends StatefulWidget {
  const MediaUploadPage({super.key});
  
  @override
  State<MediaUploadPage> createState() => _MediaUploadPageState();
}

class _MediaUploadPageState extends State<MediaUploadPage> {
  List<PlatformFile> _selectedFiles = [];
  List<Map<String, dynamic>> _uploadedFileInfos = [];
  bool _isUploading = false;
  bool _isInitializing = true;
  
  @override
  void initState() {
    super.initState();
    _initializeSession();
    
    // Check if we should clear files based on the shared preferences flag
    _checkClearFilesFlag();
  }
  
  Future<void> _checkClearFilesFlag() async {
    final shouldClear = await SessionService.instance.shouldClearFiles();
    if (shouldClear && mounted) {
      setState(() {
        _selectedFiles.clear();
        _uploadedFileInfos.clear();
      });
      print('DEBUG: Cleared files based on session flag');
    }
  }
  
  Future<void> _initializeSession() async {
    setState(() {
      _isInitializing = true;
    });
    
    try {
      // Load session data from storage and initialize CSRF if needed
      // This will fetch the CSRF token from the homepage if not found in storage
      await SessionService.instance.loadFromStorage();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to initialize session: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isInitializing = false;
      });
    }
  }

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: true,
      );

      if (result != null) {
        setState(() {
          _selectedFiles.addAll(result.files);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${result.files.length} file(s) selected'),
            backgroundColor: Colors.green,
          ),
        );
        // Automatically upload files after selection
        await _autoUploadFiles(result.files);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking files: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _autoUploadFiles(List<PlatformFile> files) async {
    // Check if we have a CSRF token, if not, fetch it
    if (SessionService.instance.csrfToken == null) {
      await SessionService.instance.fetchCsrfTokenFromHomePage();
    }
    
    for (final file in files) {
      final uri = Uri.parse('http://192.168.1.205:8080/api/upload-file/');
      final request = http.MultipartRequest('POST', uri);
      
      // Add CSRF token header
      if (SessionService.instance.csrfToken != null) {
        request.headers['X-CSRFToken'] = SessionService.instance.csrfToken!;
        // Add csrfmiddlewaretoken field for Django form compatibility
        request.fields['csrfmiddlewaretoken'] = SessionService.instance.csrfToken!;
      }
      
      // Add session key as a field and header
      if (SessionService.instance.sessionKey != null) {
        request.fields['session_key'] = SessionService.instance.sessionKey!;
        request.headers['Session-Key'] = SessionService.instance.sessionKey!;
      }

      // Add sessionid cookie to match browser behavior
      if (SessionService.instance.cookies['sessionid'] != null) {
        request.headers['Cookie'] = 'sessionid=${SessionService.instance.cookies['sessionid']}';
      }
      
      // Log the file info being sent
      print('DEBUG: Sending file: ${file.name}, size: ${file.size}');
            
      if (file.bytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            file.bytes!,
            filename: file.name,
            contentType: MediaType('application', 'pdf'),
          ),
        );
      } else if (file.path != null) {
        request.files.add(
          await http.MultipartFile.fromPath('file', file.path!),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File data unavailable for ${file.name}'),
            backgroundColor: Colors.red,
          ),
        );
        continue;
      }
      
      try {
        final response = await request.send();
        final responseData = await response.stream.bytesToString();

        // Log the response
        HttpLogger.logResponse(
          http.Response(
            responseData,
            response.statusCode,
            headers: response.headers,
            request: request,
          ),
          duration: null,
        );

        // Update sessionid cookie from response headers if present
        if (response.headers.containsKey('set-cookie')) {
          final rawCookies = response.headers['set-cookie'];
          if (rawCookies != null) {
            final cookiesList = rawCookies.split(',');
            for (var cookieString in cookiesList) {
              final cookies = cookieString.split(';');
              for (var cookie in cookies) {
                if (cookie.trim().isNotEmpty) {
                  final keyValue = cookie.trim().split('=');
                  if (keyValue.length == 2) {
                    final key = keyValue[0].trim();
                    final value = keyValue[1].trim();
                    if (key.toLowerCase() == 'sessionid') {
                      SessionService.instance.cookies['sessionid'] = value;
                    }
                  }
                }
              }
            }
          }
        }

        final parsedResponse = jsonDecode(responseData);
        // Save file_path, original_name, file_size for display and deletion
        if (parsedResponse['file_path'] != null && parsedResponse['original_name'] != null && parsedResponse['file_size'] != null) {
          setState(() {
            _uploadedFileInfos.add({
              'file_path': parsedResponse['file_path'],
              'original_name': parsedResponse['original_name'],
              'file_size': parsedResponse['file_size'],
            });
          });
        }

        // Check if we received an updated session key
        if (parsedResponse['session_key'] != null) {
          await SessionService.instance.setSessionKey(parsedResponse['session_key']);
        }

        if (response.statusCode != 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to upload ${file.name}: ${response.statusCode}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading ${file.name}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _removeFile(int index) async {
    final fileInfo = _uploadedFileInfos[index];
    
    try {
      // Make API call to delete the file
      final uri = Uri.parse('http://192.168.1.205:8080/api/delete-file/');
      
      // Prepare headers with CSRF token
      final headers = {
        'Content-Type': 'application/json',
      };
      
      if (SessionService.instance.csrfToken != null) {
        headers['X-CSRFToken'] = SessionService.instance.csrfToken!;
      }
      
      // Prepare body with session key
      final body = {
        'file_path': fileInfo['file_path'],
      };
      if (SessionService.instance.sessionKey != null) {
        body['session_key'] = SessionService.instance.sessionKey!;
      }
      
      // Always remove the file from UI for better UX
      setState(() {
        if (index < _selectedFiles.length) {
          _selectedFiles.removeAt(index);
        }
        _uploadedFileInfos.removeAt(index);
      });
      
      // Create logging client and send request
      final client = LoggingHttpClient(http.Client());
      final response = await client.post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );
      
      if (response.statusCode == 200) {
        // Parse response to check for updated session key
        try {
          final responseData = jsonDecode(response.body);
          if (responseData['session_key'] != null) {
            await SessionService.instance.setSessionKey(responseData['session_key']);
          }
        } catch (e) {
          print('Error parsing delete response: $e');
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File ${fileInfo['original_name']} deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Even if API call fails, we keep the file removed from UI
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Server notification: ${response.statusCode}'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      // Continue with UI already updated, just show the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error while processing: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _uploadFiles() async {
    if (_selectedFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select files to upload'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    // Finalize uploads before navigating
    try {
      final finalizeUri = Uri.parse('http://192.168.1.205:8080/api/flutter-finalize-uploads/');
      
      // Prepare headers with CSRF token
      final headers = {
        'Content-Type': 'application/json',
      };
      
      if (SessionService.instance.csrfToken != null) {
        headers['X-CSRFToken'] = SessionService.instance.csrfToken!;
      }
      
      // Prepare body with session key and file information
      final body = <String, dynamic>{
        'files': _uploadedFileInfos.map((file) => {
          'file_path': file['file_path'],
          'original_name': file['original_name'],
          'file_size': file['file_size'],
        }).toList(),
      };
      
      if (SessionService.instance.sessionKey != null) {
        // Include both session keys - the one Django expects for upload paths and our internal one
        body['session_key'] = SessionService.instance.sessionKey!;
        body['upload_session_key'] = SessionService.instance.sessionKey!;
        
        print('DEBUG: Using consistent session key for uploads: ${SessionService.instance.sessionKey}');
      }
      
      print('DEBUG: Sending finalize request with body: ${jsonEncode(body)}');
      
      // Create logging client and send request
      final client = LoggingHttpClient(http.Client());
      final response = await client.post(
        finalizeUri,
        headers: headers,
        body: jsonEncode(body),
      );
      
      if (response.statusCode == 200) {
        // Parse processed documents from the response
        final List<Map<String, dynamic>> processedDocs = [];
        Map<String, dynamic> responseData = {};
        
        try {
          responseData = jsonDecode(response.body);
          print('DEBUG: Finalize response: ${response.body}');
          
          // Check for success flag in the response
          final bool isSuccess = responseData['success'] == true;
          
          if (isSuccess) {
            // Log session key from response but don't update our stable one
            if (responseData['session_key'] != null) {
              print('DEBUG: Server returned session_key: ${responseData['session_key']}');
              // Instead of updating, we validate the existing session key is being used
              if (responseData['session_key'] != SessionService.instance.sessionKey) {
                print('DEBUG: Warning - Server returned different session key than our stored one');
              } else {
                print('DEBUG: Session key consistent with server');
              }
            }
            
            // Extract customer ID if available
            String? customerId = responseData['customer_id']?.toString();
            print('DEBUG: Customer ID: $customerId');
            
            if (responseData['documents'] != null && responseData['documents'] is List) {
              for (final doc in responseData['documents']) {
                processedDocs.add(Map<String, dynamic>.from(doc));
              }
              print('DEBUG: Processed docs count: ${processedDocs.length}');
              print('DEBUG: First document data: ${processedDocs.isNotEmpty ? processedDocs.first : "No documents"}');
            } else {
              print('DEBUG: No documents found in response or wrong structure');
            }
          } else {
            // Handle error case for unsupported files
            String errorMessage = responseData['error'] ?? 'Unknown error processing files';
            print('DEBUG: Error from API: $errorMessage');
            
            // Check for paper size errors
            if (responseData['paper_size_errors'] != null && responseData['paper_size_errors'] is List) {
              List<dynamic> paperSizeErrors = responseData['paper_size_errors'];
              for (var error in paperSizeErrors) {
                print('DEBUG: File ${error['file']} error: ${error['reason']}');
              }
              
              // Show specific message for paper size errors
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Unsupported paper size detected: $errorMessage'),
                  backgroundColor: Colors.orange,
                  duration: const Duration(seconds: 5),
                ),
              );
              
              setState(() {
                _selectedFiles.clear();
                _isUploading = false;
              });
              
              // Return to main page without navigating to preview
              return;
            }
          }
        } catch (e) {
          print('Error parsing finalize response: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error processing response: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
        
        // Get customer ID from response
        String? customerId = responseData['customer_id']?.toString();
        
        setState(() {
          _selectedFiles.clear();
          _uploadedFileInfos.clear();
          _isUploading = false;
        });
        
        // Handle navigation based on available documents
        if (processedDocs.isEmpty) {
          // Show a user-friendly message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your files were uploaded but no documents were processed. Please try again with different files.'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 5),
            ),
          );
          
          // Navigate anyway to show the empty state
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => UploadedDocumentsPreviewPage(
                uploadedFiles: processedDocs,
                customerId: customerId,
              ),
            ),
          ).then((result) {
            // Check if we need to clear the previous files when returning
            if (result != null && result is Map && result['clearPreviousFiles'] == true) {
              setState(() {
                _selectedFiles.clear();
                _uploadedFileInfos.clear();
              });
            }
          });
        } else {
          // We have documents - ensure required fields
          for (var doc in processedDocs) {
            // Set defaults for any missing fields
            doc['filename'] ??= 'Unnamed Document';
            doc['file_size'] ??= 0;
            // Other fields will use default values from the DocumentPreviewItem
          }
          
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => UploadedDocumentsPreviewPage(
                uploadedFiles: processedDocs,
                customerId: customerId,
              ),
            ),
          ).then((result) {
            // Check if we need to clear the previous files when returning
            if (result != null && result is Map && result['clearPreviousFiles'] == true) {
              setState(() {
                _selectedFiles.clear();
                _uploadedFileInfos.clear();
              });
            }
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to finalize uploads: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isUploading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Finalize failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isUploading = false;
      });
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB"];
    int i = (bytes.bitLength - 1) ~/ 10;
    return "${(bytes / (1 << (i * 10))).toStringAsFixed(1)} ${suffixes[i]}";
  }
  
  // Build implementation
  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFFFBB41D)),
            SizedBox(height: 16),
            Text(
              "Initializing session...",
              style: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }
    
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black, width: 1),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF18191F).withAlpha((0.08 * 255).toInt()),
                  blurRadius: 0,
                  spreadRadius: 0,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "File Upload",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      fontFamily: 'SpaceGrotesk',
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Add your documents here",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      fontFamily: 'SpaceGrotesk',
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Dotted border box with drag and drop
                  DottedBorderBox(onTap: _pickFiles),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: const [
                      Expanded(child: Divider(color: Color(0xFFEEEEEE), thickness: 1)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "OR",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'SpaceGrotesk',
                            fontWeight: FontWeight.w500,
                          )
                        ),
                      ),
                      Expanded(child: Divider(color: Color(0xFFEEEEEE), thickness: 1)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF18191F).withAlpha((0.08 * 255).toInt()),
                                blurRadius: 0,
                                spreadRadius: 0,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                  "Upload from Files",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'SpaceGrotesk',
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Container(
                                width: 110,
                                height: 36,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFB800),
                                  border: Border.all(color: Colors.black, width: 1),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 0,
                                      spreadRadius: 0,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: TextButton(
                                  onPressed: _pickFiles,
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.black,
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'SpaceGrotesk',
                                    ),
                                  ),
                                  child: const Text(
                                    "Browse Files",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'SpaceGrotesk',
                                      fontSize: 13.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Show selected files
                  if (_uploadedFileInfos.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text(
                      "Uploaded Files:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'SpaceGrotesk',
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _uploadedFileInfos.length,
                      itemBuilder: (context, index) {
                        final fileInfo = _uploadedFileInfos[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: Stack(
                                  alignment: Alignment.bottomLeft,
                                  children: [
                                    Icon(Icons.insert_drive_file_outlined, color: Colors.grey[300], size: 40),
                                    Positioned(
                                      left: 0,
                                      bottom: 10,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Text(
                                          'PDF',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      fileInfo['original_name'] ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontFamily: 'Inter',
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _formatFileSize(fileInfo['file_size'] ?? 0),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontFamily: 'SpaceGrotesk',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                              InkWell(
                                onTap: () => _removeFile(index),
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.red, width: 2),
                                  ),
                                  child: const Icon(Icons.close, color: Colors.red, size: 18),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    
                    // Upload button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 0,
                              spreadRadius: 0,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _isUploading ? null : _uploadFiles,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            disabledBackgroundColor: Colors.white,
                            disabledForegroundColor: Colors.black,
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            side: const BorderSide(color: Colors.black, width: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              fontFamily: 'SpaceGrotesk',
                            ),
                          ),
                          child: _isUploading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Color(0xFFFBB41D),
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Text("Proceed"),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      )
    );
    }
}

class DottedBorderBox extends StatelessWidget {
  final VoidCallback? onTap;
  
  const DottedBorderBox({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        color: Colors.black,
        strokeWidth: 1.5,
        dashPattern: const [6, 3],
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        child: Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.cloud_upload, size: 40, color: Colors.blue),
              SizedBox(height: 8),
              Text(
                "Drag your file(s)",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                "Upload in PDF files",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
