import 'package:flutter/material.dart';

class FeedbackFormPage extends StatelessWidget {
  const FeedbackFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const SizedBox.shrink(),
          centerTitle: true,
          toolbarHeight: 40,
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(36),
            child: TabBar(
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              tabs: [
                Tab(icon: Icon(Icons.comment), text: 'Comments'),
                Tab(icon: Icon(Icons.report_problem), text: 'Problems'),
              ],
            ),
          ),
          elevation: 0,
        ),
        body: const TabBarView(
          children: [
            FeedbackFormContent(formType: 'Comments'),
            FeedbackFormContent(formType: 'Problems'),
          ],
        ),
      ),
    );
  }
}

class FeedbackFormContent extends StatelessWidget {
  final String formType;
  const FeedbackFormContent({super.key, required this.formType});

  @override
  Widget build(BuildContext context) {
    String title;
    if (formType == 'Comments') {
      title = 'Comment';
    } else if (formType == 'Problems') {
      title = 'Report a Problem';
    } else {
      title = formType;
    }

    return Center(
      child: SingleChildScrollView( // Added to prevent overflow
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // Fill the whole container with white
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Your Message Here...',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  maxLines: 4,
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Thank you!'),
                        content: const Text('Your feedback has been submitted.'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}