import 'package:flutter/material.dart';
import 'appbar_drawer.dart';

class PaymentPage extends StatefulWidget {
  final List<Map<String, dynamic>> uploadedFiles;
  final double totalAmount;

  const PaymentPage({
    super.key,
    required this.uploadedFiles,
    required this.totalAmount,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int selectedStars = 0;
  late final String _customerId;

  @override
  void initState() {
    super.initState();
    // Check if any document contains a customer_id, otherwise generate one
    String? customerIdFromDocs;
    
    for (var doc in widget.uploadedFiles) {
      if (doc.containsKey('customer_id') && doc['customer_id'] != null) {
        customerIdFromDocs = doc['customer_id'].toString();
        break;
      }
    }
    
    _customerId = customerIdFromDocs ?? _generateCustomerId();
  }

  String _generateCustomerId() {
    String ms = DateTime.now().millisecondsSinceEpoch.toString();
    return "#CID-${ms.substring(ms.length - 4)}";
  }

  String _getDocumentId(Map<String, dynamic> doc, int index) {
    // Use doc_id from API if available, otherwise generate one
    if (doc.containsKey('doc_id') && doc['doc_id'] != null && doc['doc_id'].toString().isNotEmpty) {
      String docId = doc['doc_id'].toString();
      // Add # prefix if not present
      return docId.startsWith('#') ? docId : '#$docId';
    }
    return "#DOC-${1001 + index}";
  }
  
  double _calculateTotalAmount() {
    // Use the total_amount from API if available in the documents
    for (var doc in widget.uploadedFiles) {
      if (doc.containsKey('total_amount') && doc['total_amount'] != null) {
        try {
          return double.parse(doc['total_amount'].toString());
        } catch (e) {
          print('Error parsing total_amount: $e');
        }
      }
    }
    
    // If no total_amount found, calculate based on individual document prices
    double total = 0.0;
    for (var doc in widget.uploadedFiles) {
      if (doc.containsKey('price') && doc['price'] != null) {
        try {
          total += double.parse(doc['price'].toString());
        } catch (e) {
          total += 2.0; // Default price
        }
      } else {
        total += 2.0; // Default price
      }
    }
    
    // Fallback to the passed totalAmount if no prices found
    return total > 0 ? total : widget.totalAmount;
  }

  void _sendFeedback() {
    // Handle feedback submission
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thank you!', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w700)),
          content: const Text('Your feedback has been sent.', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w500)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK', style: TextStyle(fontFamily: 'SpaceGrotesk')),
            ),
          ],
        );
      },
    );
  }

  void _uploadAnotherDocument() {
    // Navigate back to upload page
    Navigator.of(context).popUntil((route) => route.isFirst);
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
                    // Thank you message (no container)
                    const Text(
                      "Thank you! Please approach to our personnel for payment.",
                      style: TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Please provide your Customer ID to our personnel",
                      style: TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Customer ID
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC6FF8A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 0,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Customer ID",
                            style: TextStyle(
                              fontFamily: 'SpaceGrotesk',
                              fontWeight: FontWeight.w800,
                              fontSize: 26,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _customerId,
                            style: const TextStyle(
                              fontFamily: 'SpaceGrotesk',
                              fontWeight: FontWeight.w900,
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Your Document ID
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE6E6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 0,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    'assets/avatar.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                "Your Documents",
                                style: TextStyle(
                                  fontFamily: 'SpaceGrotesk',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Document list
                          ...widget.uploadedFiles.asMap().entries.map((entry) {
                            final index = entry.key;
                            final doc = entry.value;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Row(
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
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          doc['filename'] ?? '',
                                          style: const TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        Text(
                                          doc.containsKey('price') && doc['price'] != null
                                              ? "₱${doc['price'].toString()}"
                                              : "₱2.00", // Fallback price
                                          style: const TextStyle(
                                            fontFamily: 'SpaceGrotesk',
                                            color: Colors.grey,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _getDocumentId(doc, index),
                                    style: const TextStyle(
                                      fontFamily: 'SpaceGrotesk',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Amount to Pay
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBB41D),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "₱${_calculateTotalAmount().toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontFamily: 'SpaceGrotesk',
                              fontWeight: FontWeight.w900,
                              fontSize: 30,
                              color: Colors.black,
                            ),
                          ),
                          const Text(
                            "Amount to Pay",
                            style: TextStyle(
                              fontFamily: 'SpaceGrotesk',
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Feedback Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00c6ae),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.black),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 0,
                            spreadRadius: 0,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "How was your experience?",
                            style: TextStyle(
                              fontFamily: 'SpaceGrotesk',
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "Your review meant a lot to us!",
                            style: TextStyle(
                              fontFamily: 'SpaceGrotesk',
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedStars = index + 1;
                                  });
                                },
                                child: Icon(
                                  index < selectedStars ? Icons.star : Icons.star_border,
                                  size: 30,
                                  color: index < selectedStars ? const Color(0xFFFBB41D) : Colors.black,
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: 170,
                            height: 44,
                            child: ElevatedButton(
                              onPressed: _sendFeedback,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                textStyle: const TextStyle(
                                  fontFamily: 'SpaceGrotesk',
                                  fontSize: 14,
                                ),
                                elevation: 0,
                              ),
                              child: const Text("Send a Feedback", style: TextStyle(fontFamily: 'SpaceGrotesk')),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Finish Transaction
                    Container(
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
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _uploadAnotherDocument,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            side: const BorderSide(color: Colors.black),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontFamily: 'SpaceGrotesk',
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                            ),
                          ),
                          child: const Text(
                            "Finish Transaction",
                            style: TextStyle(
                              fontFamily: 'SpaceGrotesk',
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                            ),
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