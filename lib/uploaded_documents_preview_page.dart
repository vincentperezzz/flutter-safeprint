import 'package:flutter/material.dart';
import 'payment_page.dart';
import 'appbar_drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'services/session_service.dart';
import 'services/http_logger.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class UploadedDocumentsPreviewPage extends StatefulWidget {
  final List<Map<String, dynamic>> uploadedFiles;
  final String? customerId;

  const UploadedDocumentsPreviewPage({
    super.key,
    required this.uploadedFiles,
    this.customerId,
  });

  @override
  State<UploadedDocumentsPreviewPage> createState() => _UploadedDocumentsPreviewPageState();
}

class _UploadedDocumentsPreviewPageState extends State<UploadedDocumentsPreviewPage> {
  bool _isLoading = false;
  // Map to store references to document state controllers
  final Map<String, _DocumentPreviewItemState> _documentStates = {};
  
  @override
  void initState() {
    super.initState();
    // Debug the files being passed to this page
    print('DEBUG: UploadedDocumentsPreviewPage received ${widget.uploadedFiles.length} files');
    print('DEBUG: Customer ID: ${widget.customerId ?? "No customer ID"}');
    for (var i = 0; i < widget.uploadedFiles.length; i++) {
      print('DEBUG: File $i: ${widget.uploadedFiles[i]}');
    }
    
    // Force a redraw after a short delay to ensure UI updates
    if (widget.uploadedFiles.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) setState(() {});
      });
    }
  }

  // Method to register document state controllers
  void _registerDocumentState(String fileName, _DocumentPreviewItemState state) {
    _documentStates[fileName] = state;
  }

  // Method to get document state by fileName
  _DocumentPreviewItemState? _getDocumentState(String fileName) {
    return _documentStates[fileName];
  }

  String _formatFileSize(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB"];
    int i = (bytes.bitLength - 1) ~/ 10;
    return "${(bytes / (1 << (i * 10))).toStringAsFixed(1)} ${suffixes[i]}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildNanoPrintAppBar(() {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }),
      endDrawer: buildNanoPrintDrawer(context, (int index) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }),
      body: Center(
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
                      "Uploaded Documents Preview",
                      style: TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    // Customer ID display has been hidden as requested
                    
                    const SizedBox(height: 20),

                    // Show message if no documents
                    if (widget.uploadedFiles.isEmpty) 
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                size: 60,
                                color: Color(0xFFFBB41D),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "No documents available for preview",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'SpaceGrotesk',
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Your files were uploaded but the server didn't return any processed documents. This could be due to processing issues or unsupported file formats.",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'SpaceGrotesk',
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "Please try again with different PDF files.",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'SpaceGrotesk',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 30),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop({'clearPreviousFiles': true}); // Go back to upload page and clear files
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFBB41D),
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(color: Colors.black, width: 1),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.arrow_back, size: 18),
                                    SizedBox(width: 8),
                                    Text(
                                      "Return",
                                      style: TextStyle(
                                        fontFamily: 'SpaceGrotesk',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                    // Documents list
                    ...widget.uploadedFiles.asMap().entries.map((entry) {
                      final i = entry.key;
                      final doc = entry.value;
                      // Generate a unique key for each document - fallback to index if filename is missing
                      final keyValue = doc['filename'] != null ? 'doc-${doc['filename']}' : 'doc-$i';
                      
                      // Debug log for document metadata
                      print('DEBUG: Rendering document $i with metadata: ${doc}');
                      
                      return DocumentPreviewItem(
                        key: ValueKey(keyValue),
                        fileName: doc['filename'] ?? 'Document ${i + 1}',
                        fileSize: _formatFileSize(doc['file_size'] ?? 0),
                        numPages: doc['num_pages']?.toString() ?? '-',
                        orientation: doc['orientation']?.toString() ?? '-',
                        paperSize: doc['paper_size']?.toString() ?? '-',
                        paperQuality: doc['paper_quality']?.toString() ?? '-',
                        colorMode: doc['color_mode']?.toString() ?? '-',
                        storedName: doc['stored_name']?.toString() ?? '-',
                        docId: doc['doc_id']?.toString() ?? '-',
                        originalName: doc['original_name']?.toString() ?? '-',
                        filePath: doc['file_path']?.toString() ?? '-',
                        onRemove: () async {
                          // Get document information
                          final String filename = doc['filename'] ?? '';
                          
                          try {
                            // Debug the document data to see what's available
                            print('DEBUG: Document to delete: $doc');
                            
                            // Get the file_path directly from the document data
                            // This is returned by the flutter-finalize-uploads API
                            String filePath = '';
                            
                            if (doc.containsKey('file_path') && doc['file_path'] != null && doc['file_path'].toString().isNotEmpty) {
                              filePath = doc['file_path'].toString();
                              print('DEBUG: Using file_path from API: $filePath');
                            } else {
                              print('DEBUG: No file_path found in document data');
                            }
                            
                            print('DEBUG: File path for deletion: $filePath');
                            
                            // Validate file path
                            if (filePath.isEmpty) {
                              throw Exception('Cannot delete file: Unable to determine file path');
                            }
                            
                            // Make API call to delete the file
                            final uri = Uri.parse('http://192.168.1.205:8080/api/delete-file/');
                            
                            // Prepare headers with CSRF token
                            final headers = {
                              'Content-Type': 'application/json',
                            };
                            
                            if (SessionService.instance.csrfToken != null) {
                              headers['X-CSRFToken'] = SessionService.instance.csrfToken!;
                            }
                            
                            // Prepare body with file_path as requested by API
                            final body = <String, dynamic>{
                              'file_path': filePath,
                            };
                            
                            // Add debug log for the body
                            print('DEBUG: Delete request body: ${jsonEncode(body)}');
                            
                            // Add doc_id to the request for server-side reference
                            if (doc.containsKey('doc_id') && doc['doc_id'] != null) {
                              body['doc_id'] = doc['doc_id'].toString();
                            }
                            
                            // Add session key if available
                            if (SessionService.instance.sessionKey != null) {
                              body['session_key'] = SessionService.instance.sessionKey!;
                            }
                            
                            // Create logging client and send request
                            final client = LoggingHttpClient(http.Client());
                            final response = await client.post(
                              uri,
                              headers: headers,
                              body: jsonEncode(body),
                            );
                            client.close();
                            
                            // Regardless of response, remove from UI for better UX
                            setState(() {
                              // Remove from document states map
                              _documentStates.remove(filename);
                              // Remove from uploadedFiles list
                              widget.uploadedFiles.removeAt(i);
                            });
                            
                            if (response.statusCode == 200) {
                              // Parse response for updated session key
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
                                  content: Text('File deleted successfully'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else if (response.statusCode == 404) {
                              // File not found, but we already removed it from UI
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('File not found on server, removed from view'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            } else {
                              // Other error, but we keep UI updated
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Server notification: ${response.statusCode}'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            }
                            
                            if (widget.uploadedFiles.isEmpty) {
                              // Navigate back to main page with a flag to clear previous files
                              Navigator.of(context).pop({'clearPreviousFiles': true});
                            }
                          } catch (e) {
                            // Error handling for any exceptions
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error deleting file: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            
                            // Even if there's an error, we should still update the UI
                            setState(() {
                              // Remove from document states map
                              _documentStates.remove(filename);
                              // Remove from uploadedFiles list
                              widget.uploadedFiles.removeAt(i);
                            });
                          }
                        },
                      );
                    }),
                    const SizedBox(height: 10),

                    // Proceed button
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
                          onPressed: (_isLoading || widget.uploadedFiles.isEmpty)
                              ? null
                              : () async {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  
                                  // Get all document settings from the document preview items
                                  try {
                                    final List<Map<String, dynamic>> updatedSettings = [];
                                    
                                    // Find all DocumentPreviewItem widgets and get their settings
                                    for (final doc in widget.uploadedFiles) {
                                      final fileName = doc['filename'] ?? '';
                                      final docId = doc['doc_id']?.toString() ?? '';
                                      final filePath = doc['file_path']?.toString() ?? '';
                                      // Find the key for this document
                                      final docState = _getDocumentState(fileName);
                                      if (docState != null) {
                                        final Map<String, dynamic> payload = {};
                                        
                                        // Use doc_id if available, otherwise fallback to filename for compatibility
                                        if (docId.isNotEmpty) {
                                          payload['doc_id'] = docId;
                                          print('DEBUG: Using doc_id: $docId for document: $fileName');
                                        } else {
                                          payload['filename'] = fileName;
                                          print('DEBUG: No doc_id found, using filename: $fileName');
                                        }
                                        
                                        // Add file_path to the payload if available
                                        if (filePath.isNotEmpty) {
                                          payload['file_path'] = filePath;
                                          print('DEBUG: Adding file_path: $filePath to update payload');
                                        }
                                        
                                        // Add all the other settings
                                        payload['copies'] = docState.copies;
                                        payload['pages_selection'] = docState.pagesSelection;
                                        payload['orientation'] = docState.orientation;
                                        payload['grayscale'] = docState.grayscale;
                                        payload['paper_size'] = docState.getSimplifiedPaperSize();
                                        payload['paper_quality'] = docState.paperQuality.startsWith('70') ? '70' : '80';
                                        updatedSettings.add(payload);
                                      }
                                    }
                                    
                                    // Send all settings to the API
                                    final url = Uri.parse('http://192.168.1.205:8080/api/update-document-settings/');
                                    
                                    // Prepare headers with CSRF token
                                    final headers = {
                                      'Content-Type': 'application/json',
                                    };
                                    
                                    if (SessionService.instance.csrfToken != null) {
                                      headers['X-CSRFToken'] = SessionService.instance.csrfToken!;
                                    }
                                    
                                    // Prepare body with the new format
                                    final Map<String, dynamic> body = {
                                      'updates': updatedSettings,
                                    };
                                    
                                    if (SessionService.instance.sessionKey != null) {
                                      body['session_key'] = SessionService.instance.sessionKey!;
                                      body['upload_session_key'] = SessionService.instance.sessionKey!;
                                      
                                      print('DEBUG: Using consistent session key for update-document-settings: ${SessionService.instance.sessionKey}');
                                    }
                                    
                                    // Debug log for the new request format
                                    print('DEBUG: Sending update settings request with new format');
                                    print('DEBUG: Request body: ${jsonEncode(body)}');
                                    
                                    // Create logging client and send request
                                    final client = LoggingHttpClient(http.Client());
                                    final response = await client.post(
                                      url,
                                      headers: headers,
                                      body: jsonEncode(body),
                                    );
                                    client.close();
                                    
                                    // Check for updated session key in the response
                                    if (response.statusCode == 200) {
                                      try {
                                        final responseData = jsonDecode(response.body);
                                        if (responseData['session_key'] != null) {
                                          // Log but don't update our session key to keep it consistent
                                          print('DEBUG: Server returned session_key: ${responseData['session_key']}');
                                          // Validate it matches our stable session key
                                          if (responseData['session_key'] != SessionService.instance.sessionKey) {
                                            print('DEBUG: Warning - Server returned different session key than our stored one');
                                          } else {
                                            print('DEBUG: Session key consistent with server');
                                          }
                                        }
                                      } catch (e) {
                                        print('Error parsing settings update response: $e');
                                      }
                                    }
                                    
                                    if (response.statusCode != 200) {
                                      throw Exception('Failed to update settings: ${response.statusCode}');
                                    }
                                    
                                    // Step 2: Get final confirmation and pricing
                                    final confirmUrl = Uri.parse('http://192.168.1.205:8080/api/flutter-confirmation/');
                                    
                                    final Map<String, dynamic> confirmBody = {};
                                    
                                    // Include session key if available
                                    if (SessionService.instance.sessionKey != null) {
                                      confirmBody['session_key'] = SessionService.instance.sessionKey!;
                                      confirmBody['upload_session_key'] = SessionService.instance.sessionKey!;
                                      
                                      print('DEBUG: Using consistent session key for flutter-confirmation: ${SessionService.instance.sessionKey}');
                                    }
                                    
                                    // Include customer ID if available
                                    if (widget.customerId != null) {
                                      confirmBody['customer_id'] = widget.customerId!;
                                    }
                                    
                                    print('DEBUG: Sending confirmation request');
                                    print('DEBUG: Confirmation body: ${jsonEncode(confirmBody)}');
                                    
                                    final confirmResponse = await client.post(
                                      confirmUrl,
                                      headers: headers,
                                      body: jsonEncode(confirmBody),
                                    );
                                    client.close();
                                    
                                    if (confirmResponse.statusCode != 200) {
                                      throw Exception('Failed to get confirmation: ${confirmResponse.statusCode}');
                                    }
                                    
                                    print('DEBUG: Confirmation successful');
                                    print('DEBUG: Confirm response: ${confirmResponse.body}');
                                    
                                    // Parse the confirmation response
                                    final confirmData = jsonDecode(confirmResponse.body);
                                    
                                    if (confirmData['success'] == true) {
                                      // Get data from confirmation response
                                      double totalAmount = confirmData['total_price'] != null ? 
                                          double.parse(confirmData['total_price'].toString()) : 45.00;
                                      
                                      List<Map<String, dynamic>> documents = [];
                                      if (confirmData['documents'] != null) {
                                        for (var doc in confirmData['documents']) {
                                          // Convert document to map and ensure we preserve all fields
                                          Map<String, dynamic> docMap = doc as Map<String, dynamic>;
                                          
                                          // Debug log for document data from API
                                          print('DEBUG: Document from confirmation API: $docMap');
                                          
                                          documents.add(docMap);
                                        }
                                        
                                        print('DEBUG: Number of documents from confirmation API: ${documents.length}');
                                      } else {
                                        documents = widget.uploadedFiles;
                                        print('DEBUG: Using original uploaded files as no documents returned from API');
                                      }
                                      
                                      // Check for file paths in documents
                                      for (var doc in documents) {
                                        final filePath = doc['file_path']?.toString() ?? 'not-present';
                                        final docId = doc['doc_id']?.toString() ?? 'not-present';
                                        print('DEBUG: Document with ID: $docId has file_path: $filePath');
                                      }
                                      
                                      if (mounted) {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) => PaymentPage(
                                              uploadedFiles: documents,
                                              totalAmount: totalAmount,
                                              customerId: confirmData['customer_id']?.toString(),
                                            ),
                                          ),
                                        );
                                      }
                                    } else {
                                      throw Exception('Confirmation response indicated failure');
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                                    );
                                  } finally {
                                    if (mounted) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  }
                                },
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
                              fontFamily: 'SpaceGrotesk',
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Color(0xFFFBB41D),
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Text(
                                  "Proceed",
                                  style: TextStyle(fontFamily: 'SpaceGrotesk'),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DocumentPreviewItem extends StatefulWidget {
  final String fileName;
  final String fileSize;
  final String numPages;
  final String orientation;
  final String paperSize;
  final String paperQuality;
  final String colorMode;
  final String storedName;
  final String docId;
  final String originalName;
  final String filePath;
  final VoidCallback onRemove;

  const DocumentPreviewItem({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.numPages,
    required this.orientation,
    required this.paperSize,
    required this.paperQuality,
    required this.colorMode,
    required this.storedName,
    required this.docId,
    required this.originalName,
    required this.filePath,
    required this.onRemove,
  });

  @override
  State<DocumentPreviewItem> createState() => _DocumentPreviewItemState();
}

class _DocumentPreviewItemState extends State<DocumentPreviewItem> {
  int copies = 1;
  String pagesSelection = "All Pages";
  String orientation = "Portrait";
  bool grayscale = false;
  String paperSize = "Long (8.5×13in)";
  String paperQuality = "70 GSM (thinner)";
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize default values from widget properties
    if (widget.orientation.isNotEmpty && widget.orientation != '-') {
      orientation = widget.orientation;
    }
    
    // Initialize grayscale value based on colorMode
    if (widget.colorMode.isNotEmpty && widget.colorMode != '-') {
      // If colorMode is "bw", set grayscale to true
      grayscale = (widget.colorMode.toLowerCase() == "bw");
    }
    
    // Initialize paper size from API value
    if (widget.paperSize.isNotEmpty && widget.paperSize != '-') {
      // Map the API paper size to our UI presentation format
      switch (widget.paperSize) {
        case "Long":
          paperSize = "Long (8.5×13in)";
          break;
        case "Letter":
          paperSize = "Letter (8.5×11in)";
          break;
        case "A4":
          paperSize = "A4 (8.3×11.7in)";
          break;
        default:
          paperSize = widget.paperSize.contains("×") ? widget.paperSize : "Letter (8.5×11in)";
      }
    }
    
    // Initialize paper quality from API value
    if (widget.paperQuality.isNotEmpty && widget.paperQuality != '-') {
      // API returns just the number (e.g. "70" or "80")
      if (widget.paperQuality == "70") {
        paperQuality = "70 GSM (thinner)";
      } else if (widget.paperQuality == "80") {
        paperQuality = "80 GSM (thicker)";
      }
    }
  }
  
  // Get the simplified paper size (for API)
  String getSimplifiedPaperSize() {
    if (paperSize.contains("Long")) {
      return "Long";
    } else if (paperSize.contains("Letter")) {
      return "Letter";
    } else if (paperSize.contains("A4")) {
      return "A4";
    }
    return paperSize;
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Register this state with parent after the widget is built
    _registerWithParent();
  }
  
  void _registerWithParent() {
    // Find parent state and register
    final ancestorState = context
        .findAncestorStateOfType<_UploadedDocumentsPreviewPageState>();
    if (ancestorState != null) {
      ancestorState._registerDocumentState(widget.fileName, this);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // File info header
          Row(
            children: [
              // PDF Icon
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
                            fontFamily: 'SpaceGrotesk',
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
              // File name and size
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.fileName,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.fileSize,
                      style: const TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              // Remove button
              InkWell(
                onTap: widget.onRemove,
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
          const SizedBox(height: 12),

          // Copies
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Copies",
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                height: 32,
                width: 110,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Minus button
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Text(
                          '−', // Unicode minus
                          style: TextStyle(
                            fontFamily: 'SpaceGrotesk',
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            height: 1,
                          ),
                        ),
                        onPressed: copies > 1 ? () => setState(() => copies--) : null,
                        splashRadius: 18,
                      ),
                    ),
                    // Yellow number box
                    Container(
                      width: 40,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB800),
                        border: Border(
                          left: BorderSide(color: Colors.black, width: 1),
                          right: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      child: Text(
                        copies.toString(),
                        style: const TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    // Plus button
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Text(
                          '+',
                          style: TextStyle(
                            fontFamily: 'SpaceGrotesk',
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            height: 1,
                          ),
                        ),
                        onPressed: () => setState(() => copies++),
                        splashRadius: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Pages to Print
          const Text(
            "Pages to Print",
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRadioOption("All Pages", pagesSelection == "All Pages", (value) {
                setState(() => pagesSelection = "All Pages");
              }),
              const SizedBox(height: 6),
              _buildRadioOption("Specific Pages", pagesSelection == "Specific Pages", (value) {
                setState(() => pagesSelection = "Specific Pages");
              }),
              const SizedBox(height: 10),
              // Page range box
              Container(
                width: double.infinity,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: pagesSelection == "Specific Pages"
                      ? Colors.white
                      : const Color(0xFFF6F6FF),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: pagesSelection == "Specific Pages"
                    ? TextField(
                        enabled: true,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontFamily: 'SpaceGrotesk',
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                          isCollapsed: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: const TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      )
                    : Text(
                        widget.numPages.isNotEmpty && widget.numPages != '-' 
                            ? "1-${widget.numPages}" 
                            : "1-3",
                        style: TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Orientation
          const Text(
            "Page Orientation",
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRadioOption("Portrait", orientation == "Portrait", (value) {
                setState(() => orientation = "Portrait");
              }),
              const SizedBox(height: 6),
              _buildRadioOption("Landscape", orientation == "Landscape", (value) {
                setState(() => orientation = "Landscape");
              }),
            ],
          ),
          const SizedBox(height: 16),

          // Print in Grayscale
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Print in Grayscale",
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontWeight: FontWeight.w600,
                ),
              ),
              _customToggle(grayscale, (val) => setState(() => grayscale = val)),
            ],
          ),

          const SizedBox(height: 14),

          // Paper Size
          const Text(
            "Paper Size",
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.black),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        value: paperSize,
                        items: [
                          "Long (8.5×13in)",
                          "Letter (8.5×11in)",
                          "A4 (8.3×11.7in)"
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                fontFamily: 'SpaceGrotesk',
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() => paperSize = newValue);
                          }
                        },
                        customButton: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Text(
                                  paperSize,
                                  style: const TextStyle(
                                    fontFamily: 'SpaceGrotesk',
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 44,
                              height: 48,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFB800),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(13),
                                  bottomRight: Radius.circular(13),
                                ),
                              ),
                              child: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                            ),
                          ],
                        ),
                        dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Quality of the Paper
          const Text(
            "Quality of the Paper",
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.black),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        value: paperQuality,
                        items: [
                          "70 GSM (thinner)",
                          "80 GSM (thicker)"
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                fontFamily: 'SpaceGrotesk',
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() => paperQuality = newValue);
                          }
                        },
                        customButton: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Text(
                                  paperQuality,
                                  style: const TextStyle(
                                    fontFamily: 'SpaceGrotesk',
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 44,
                              height: 49,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFB800),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(13),
                                  bottomRight: Radius.circular(13),
                                ),
                              ),
                              child: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                            ),
                          ],
                        ),
                        dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildRadioOption(String title, bool isSelected, Function(bool) onChanged) {
    return GestureDetector(
      onTap: () => onChanged(true),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 1),
              color: Colors.white,
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFB800),
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _customToggle(bool value, ValueChanged<bool> onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 44,
        height: 24,
        decoration: BoxDecoration(
          color: value ? const Color(0xFFFFB800) : Colors.white, // Yellow when ON
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 150),
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

