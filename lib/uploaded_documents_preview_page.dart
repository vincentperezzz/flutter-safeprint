import 'package:flutter/material.dart';
import 'payment_page.dart';
import 'appbar_drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UploadedDocumentsPreviewPage extends StatefulWidget {
  final List<Map<String, dynamic>> uploadedFiles;

  const UploadedDocumentsPreviewPage({
    super.key,
    required this.uploadedFiles,
  });

  @override
  State<UploadedDocumentsPreviewPage> createState() => _UploadedDocumentsPreviewPageState();
}

class _UploadedDocumentsPreviewPageState extends State<UploadedDocumentsPreviewPage> {
  bool _isLoading = false;

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
                    const SizedBox(height: 20),

                    // Documents list
                    ...widget.uploadedFiles.asMap().entries.map((entry) {
                      final i = entry.key;
                      final doc = entry.value;
                      return DocumentPreviewItem(
                        fileName: doc['filename'] ?? '',
                        fileSize: _formatFileSize(doc['file_size'] ?? 0),
                        numPages: doc['num_pages']?.toString() ?? '-',
                        orientation: doc['orientation']?.toString() ?? '-',
                        paperSize: doc['paper_size']?.toString() ?? '-',
                        onRemove: () {
                          setState(() {
                            widget.uploadedFiles.removeAt(i);
                          });
                          if (widget.uploadedFiles.isEmpty) {
                            Navigator.of(context).pop(); // Go back to previous (main) page
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
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  double totalAmount = 45.00;
                                  await Future.delayed(const Duration(milliseconds: 600));
                                  if (mounted) {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => PaymentPage(
                                          uploadedFiles: widget.uploadedFiles,
                                          totalAmount: totalAmount,
                                        ),
                                      ),
                                    );
                                    setState(() {
                                      _isLoading = false;
                                    });
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
  final VoidCallback onRemove;

  const DocumentPreviewItem({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.numPages,
    required this.orientation,
    required this.paperSize,
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

  Future<void> _saveSettings() async {
    setState(() { isSaving = true; });
    final url = Uri.parse('http://192.168.1.205:8080/api/update-document-settings/');
    final payload = {
      'filename': widget.fileName,
      'copies': copies,
      'pages_selection': pagesSelection,
      'orientation': orientation,
      'grayscale': grayscale,
      'paper_size': paperSize,
      'paper_quality': paperQuality,
    };
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings updated!'), backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update: ${response.statusCode}'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
    setState(() { isSaving = false; });
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
                        "1-3",
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
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
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
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
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
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isSaving ? null : _saveSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              child: isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Save Settings'),
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

