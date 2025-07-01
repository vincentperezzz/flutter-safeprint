import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatefulWidget {
  final void Function(int)? onNavigate;
  const AboutUsPage({super.key, this.onNavigate});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _contactKey = GlobalKey();

  void _scrollToContact() {
    final ctx = _contactKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            controller: _scrollController,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // About Us
                    Padding(
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
                              'About Us',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            "Meet the skilled and experienced team behind\nour successful privacy-focused print management system.",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE4EFFF),
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
                            child: Column(
                              children: [
                                const Text(
                                  "SafePrint is a secure and efficient print management system developed as a college capstone project by Crystaline M. Datu, Charles Gabriel D. Gavino, and Vincent P. Perez taking BS Information Technology from Batangas State University The National Engineering University - Alangilan Campus. It aims to improve the printing process by providing a secure file transfer portal between customers and print shops, ensuring that documents are not stored or left behind on shop computers.",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 12,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                                const SizedBox(height: 24),
                                Image.asset(
                                  'assets/about-us.png',
                                  height: 120,
                                  fit: BoxFit.contain,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 48),
                        ],
                      ),
                    ),
                    const Spacer(),

                    // Footer
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Color(0xFF181924),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(36),
                          topRight: Radius.circular(36),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/nanoprint-logo.png',
                                width: 70,
                                height: 70,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 12),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFBB41D),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      "NanoPrint",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white70,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      "Powered by SafePrint",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Contact Us
                          Container(
                            key: _contactKey,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFBB41D),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Contact Us',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () async {
                              final Uri emailUri = Uri(
                                scheme: 'mailto',
                                path: 'nanoprint.alangilan@gmail.com',
                              );
                              if (await canLaunchUrl(emailUri)) {
                                await launchUrl(emailUri);
                              }
                            },
                            child: const Text(
                              'Email: nanoprint.alangilan@gmail.com',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () async {
                              final Uri mapUri = Uri.parse(
                                "https://www.google.com/maps/place/13%C2%B047'07.5%22N+121%C2%B004'24.0%22E/@13.7854084,121.0733296,17z/data=!3m1!4b1!4m4!3m3!8m2!3d13.7854084!4d121.0733296",
                              );
                              if (await canLaunchUrl(mapUri)) {
                                await launchUrl(mapUri, mode: LaunchMode.externalApplication);
                              }
                            },
                            child: const Text(
                              'Address: Neptune St. Golden Country Homes, Alangilan, Batangas City, Philippines',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _FooterLink('Help', onTap: () {
                                if (widget.onNavigate != null) widget.onNavigate!(2);
                              }),
                              const SizedBox(height: 8),
                              _FooterLink('FAQs', onTap: () {
                                if (widget.onNavigate != null) widget.onNavigate!(3);
                              }),
                              const SizedBox(height: 8),
                              _FooterLink('About Us', onTap: () {
                                if (widget.onNavigate != null) widget.onNavigate!(4);
                              }),
                              const SizedBox(height: 8),
                              _FooterLink('Feedback', onTap: () {
                                if (widget.onNavigate != null) widget.onNavigate!(1);
                              }),
                              const SizedBox(height: 8),
                              _FooterLink('Contact Us', onTap: _scrollToContact),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                const url = 'https://www.facebook.com/people/Nano-Print-Alangilan/61570320149415/';
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                                }
                              },
                              icon: const Icon(Icons.facebook, color: Colors.white),
                              label: const Text(
                                'Follow on Facebook',
                                style: TextStyle(fontSize: 12),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4267B2),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                textStyle: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Divider(color: Colors.white24, thickness: 1),
                          const SizedBox(height: 8),
                          Center(
                            child: Text(
                              '© 2025 SafePrint. All Rights Reserved.',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  const _FooterLink(this.text, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}