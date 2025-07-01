import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFBB41D),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Need help?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "We’re here to assist you in ensuring a seamless and secure printing experience.\n"
            "Follow the steps below to submit your documents and understand our procedures.",
            style: TextStyle(fontSize: 12, color: Colors.black, height: 1.5),
          ),
          const SizedBox(height: 28),
          
          // Drag and Drop Uploading
          Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.only(bottom: 32),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.black, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  offset: const Offset(0, 5),
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    children: [
                      WidgetSpan(
                        child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFFBB41D),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Drag and Drop Uploading',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Easily upload your files by dragging and dropping them into the designated area on our platform.",
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Image.asset(
                    'assets/drag-n-drop.png',
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),

          // Browse Files
          Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.only(bottom: 32),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.black, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  offset: const Offset(0, 5),
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    children: [
                      WidgetSpan(
                        child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFFBB41D),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Browse Files to Upload',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Select your document from your computer or mobile device. Ensure the file format is supported.",
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Image.asset(
                    'assets/browse.png',
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
          
          // Print Preference
          Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.only(bottom: 32),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.black, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  offset: const Offset(0, 5),
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    children: [
                      WidgetSpan(
                        child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFFBB41D),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Print Preference',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Choose black or colored, what specific pages and what paper size suits your requirements.",
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Image.asset(
                    'assets/print-preference.png',
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),

          // Customer ID
          Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.only(bottom: 32),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.black, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  offset: const Offset(0, 5),
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    children: [
                      WidgetSpan(
                        child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFFBB41D),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Give to our team\nyour Customer ID',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Your Customer ID will be our guide to find your documents in our system and for our personnel to verify and queue the documents for printing.",
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Image.asset(
                    'assets/customer-id.png',
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),

          // Payment Process
          Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.only(bottom: 32),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.black, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  offset: const Offset(0, 5),
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    children: [
                      WidgetSpan(
                        child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFFBB41D),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Payment Process',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "After submitting your document, please proceed to the counter to complete the payment. Our printing personnel will then authorize and initiate the printing of your document.",
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Image.asset(
                    'assets/payment.png',
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),

          // Error Occur
          Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.only(bottom: 32),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.black, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  offset: const Offset(0, 5),
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    children: [
                      WidgetSpan(
                        child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFFBB41D),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'In case error occurs',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "If you encounter any issues during the submission or printing process, our personnel may request you to resend the document to ensure optimal print quality.",
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Image.asset(
                    'assets/error-occur.png',
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}