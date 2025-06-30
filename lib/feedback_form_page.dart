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
          // Reduce toolbarHeight to bring TabBar closer to the top/logo line
          toolbarHeight: 40, // Default is 56, reduce as needed
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(36), // Reduce TabBar height
            child: TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.black,
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

// ...rest of the code unchanged...

class FeedbackFormContent extends StatelessWidget {
  final String formType;
  const FeedbackFormContent({super.key, required this.formType});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          color: Colors.white, // Card background white
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$formType Form",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black, // Text color black
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Your Name',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white, // TextField background white
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Your $formType',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white, // TextField background white
                  ),
                  maxLines: 4,
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Button color for contrast
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {},
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