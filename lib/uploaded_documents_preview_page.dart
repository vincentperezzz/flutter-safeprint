import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'payment_page.dart';

class UploadedDocumentsPreviewPage extends StatefulWidget {
  final List<PlatformFile> uploadedFiles;

  const UploadedDocumentsPreviewPage({
    super.key,
    required this.uploadedFiles,
  });

  @override
  State<UploadedDocumentsPreviewPage> createState() => _UploadedDocumentsPreviewPageState();
}

class _UploadedDocumentsPreviewPageState extends State<UploadedDocumentsPreviewPage> {
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 70,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
              children: const [
                Text(
                  "NanoPrint",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  "Powered by SafePrint",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
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
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Documents list
                    ...widget.uploadedFiles.map((file) => DocumentPreviewItem(
                      fileName: file.name,
                      fileSize: _formatFileSize(file.size),
                    )),
                    
                    const SizedBox(height: 20),
                    
                    // Proceed button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Calculate total amount (₱45.00 for 2 documents as shown in image)
                          double totalAmount = 45.00;
                          
                          // Navigate to payment page
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PaymentPage(
                                uploadedFiles: widget.uploadedFiles,
                                totalAmount: totalAmount,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Proceed",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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

  const DocumentPreviewItem({
    super.key,
    required this.fileName,
    required this.fileSize,
  });

  @override
  State<DocumentPreviewItem> createState() => _DocumentPreviewItemState();
}

class _DocumentPreviewItemState extends State<DocumentPreviewItem> {
  int copies = 1;
  String pagesSelection = "All Pages";
  String orientation = "Portrait";
  bool grayscale = false;
  String paperSize = "Auto (8.5x13in)";
  String paperQuality = "70 GSM (thinner)";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // File info header
          Row(
            children: [
              const Icon(Icons.picture_as_pdf, color: Colors.red, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.fileName,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      widget.fileSize,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  // Handle remove file
                },
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Copies
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Copies", style: TextStyle(fontWeight: FontWeight.w500)),
              Row(
                children: [
                  IconButton(
                    onPressed: copies > 1 ? () => setState(() => copies--) : null,
                    icon: const Icon(Icons.remove),
                    iconSize: 20,
                  ),
                  Container(
                    width: 40,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB800),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      copies.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => copies++),
                    icon: const Icon(Icons.add),
                    iconSize: 20,
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Pages to Print
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Pages to Print", style: TextStyle(fontWeight: FontWeight.w500)),
              Row(
                children: [
                  _buildRadioOption("All Pages", pagesSelection == "All Pages", (value) {
                    setState(() => pagesSelection = "All Pages");
                  }),
                  const SizedBox(width: 16),
                  _buildRadioOption("Specific Pages", pagesSelection == "Specific Pages", (value) {
                    setState(() => pagesSelection = "Specific Pages");
                  }),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Page range input
          Container(
            width: double.infinity,
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            alignment: Alignment.centerLeft,
            child: const Text("1-5", style: TextStyle(color: Colors.grey)),
          ),
          
          const SizedBox(height: 12),
          
          // Orientation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Orientation", style: TextStyle(fontWeight: FontWeight.w500)),
              Row(
                children: [
                  _buildRadioOption("Portrait", orientation == "Portrait", (value) {
                    setState(() => orientation = "Portrait");
                  }),
                  const SizedBox(width: 16),
                  _buildRadioOption("Landscape", orientation == "Landscape", (value) {
                    setState(() => orientation = "Landscape");
                  }),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Print in Grayscale
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Print in Grayscale", style: TextStyle(fontWeight: FontWeight.w500)),
              Switch(
                value: grayscale,
                onChanged: (value) => setState(() => grayscale = value),
                activeColor: const Color(0xFFFFB800),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Paper Size
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Paper Size", style: TextStyle(fontWeight: FontWeight.w500)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB800),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black),
                ),
                child: DropdownButton<String>(
                  value: paperSize,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: [
                    "Auto (8.5x13in)",
                    "A4",
                    "Letter",
                    "Legal"
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() => paperSize = newValue);
                    }
                  },
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Quality of the Paper
          const Text("Quality of the Paper", style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildQualityButton("70 GSM (thinner)", paperQuality == "70 GSM (thinner)"),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildQualityButton("80 GSM (thicker)", paperQuality == "80 GSM (thicker)"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(String title, bool isSelected, Function(bool) onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<bool>(
          value: true,
          groupValue: isSelected,
          onChanged: (value) => onChanged(value ?? false),
          activeColor: const Color(0xFFFFB800),
        ),
        Text(title, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildQualityButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => paperQuality = text),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFB800) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey[400]!,
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
