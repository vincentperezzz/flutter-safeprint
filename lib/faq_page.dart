import 'package:flutter/material.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  int? expandedIndex;

  final faqs = [
    {
      'question': 'How do we keep your documents safe?',
      'answer':
          'All uploaded documents are stored temporarily and automatically deleted after printing. No files are retained on our servers beyond the printing process.',
    },
    {
      'question': 'Who can access my documents?',
      'answer':
          'Only authorized printing personnel can access your documents for the purpose of printing. Your privacy and security are our top priorities.',
    },
    {
      'question': 'How is my document protected during upload?',
      'answer':
          'We use secure encryption protocols to protect your document during upload, ensuring that your data remains private and secure.',
    },
    {
      'question': 'What happens if my document is not printed correctly?',
      'answer':
          'If there is a printing error (e.g., paper jam, misalignment), our system will notify our personnel for intervention. If necessary, you may need to re-upload your document.',
    },
    {
      'question': 'Is my personal information stored?',
      'answer':
          'We do not store any personal details beyond necessary session logs for managing the queue. No sensitive information is collected or shared.',
    },
    {
      'question': 'Do you track what I print?',
      'answer':
          'Our system logs basic job details like the number of pages, color mode, and timestamp for queue management. However, document contents are not stored or analyzed.',
    }
  ];

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
              'Frequently Asked Questions',
              style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "We understand the importance of protecting your documents and ensuring a secure printing experience.\n"
            "Below are some of the ways we safeguard your files and maintain your privacy.",
            style: TextStyle(fontSize: 12, color: Colors.black, height: 1.5),
          ),
          const SizedBox(height: 24),
          
          // FAQs List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: faqs.length,
            itemBuilder: (context, index) {
              final isExpanded = expandedIndex == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: isExpanded ? const Color(0xFFFBB41D) : const Color(0xFFF3F3F3),
                  borderRadius: BorderRadius.circular(32),
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
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(32),
                    onTap: () {
                      setState(() {
                        expandedIndex = isExpanded ? null : index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Baseline(
                                baseline: 18,
                                baselineType: TextBaseline.alphabetic,
                                child: Text(
                                  (index + 1).toString().padLeft(2, '0'),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: isExpanded ? Colors.black : Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Baseline(
                                  baseline: 18, // matches fontSize
                                  baselineType: TextBaseline.alphabetic,
                                  child: Text(
                                    faqs[index]['question']!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black),
                                ),
                                child: Icon(
                                  isExpanded ? Icons.close : Icons.add,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          if (isExpanded) ...[
                            const SizedBox(height: 12),
                            const Divider(color: Colors.black, thickness: 1),
                            const SizedBox(height: 8),
                            Text(
                              faqs[index]['answer']!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}