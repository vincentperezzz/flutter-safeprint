import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'feedback_form_page.dart';
import 'help_page.dart';
import 'faq_page.dart';
import 'about_us_page.dart';
import 'uploaded_documents_preview_page.dart';

void main() => runApp(const SampleApp());

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
  bool _isUploading = false;

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

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
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

    try {
      // Simulate upload process
      await Future.delayed(const Duration(seconds: 2));
      
      // Store the uploaded files
      final uploadedFiles = List<PlatformFile>.from(_selectedFiles);
      
      setState(() {
        _selectedFiles.clear();
        _isUploading = false;
      });

      // Navigate to uploaded documents preview page
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => UploadedDocumentsPreviewPage(
            uploadedFiles: uploadedFiles,
          ),
        ),
      );
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload failed: $e'),
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
  @override
  Widget build(BuildContext context) {
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
                  if (_selectedFiles.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text(
                      "Selected Files:",
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
                      itemCount: _selectedFiles.length,
                      itemBuilder: (context, index) {
                        final file = _selectedFiles[index];
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
                              // PDF Icon
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: Stack(
                                  alignment: Alignment.bottomLeft,
                                  children: [
                                    // Document outline icon
                                    Icon(Icons.insert_drive_file_outlined, color: Colors.grey[300], size: 40),
                                    // PDF label
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
                              // File name and size
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      file.name,
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
                                      _formatFileSize(file.size),
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
                              // Remove button
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
      ),
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
