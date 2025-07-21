import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'services/session_service.dart';

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
              labelStyle: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
              unselectedLabelStyle: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
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

class FeedbackFormContent extends StatefulWidget {
  final String formType;
  const FeedbackFormContent({super.key, required this.formType});

  @override
  State<FeedbackFormContent> createState() => _FeedbackFormContentState();
}

class _FeedbackFormContentState extends State<FeedbackFormContent> {
  final _nameController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitFeedback() async {
    if (_nameController.text.trim().isEmpty || _messageController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Textbox is empty'),
          content: const Text('Please fill in both Name and Message fields.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Log the feedback data
    print('Submitting feedback:');
    print('Category: ${widget.formType == 'Comments' ? 'Comment' : 'Report a Problem'}');
    print('Name: ${_nameController.text}');
    print('Message: ${_messageController.text}');

    final url = Uri.parse('$serverIp/feedback/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'category': widget.formType == 'Comments' ? 'Comment' : 'Report a Problem',
        'name': _nameController.text,
        'message': _messageController.text,
      },
    );
    setState(() => _isSubmitting = false);

    if (response.statusCode == 302 || response.statusCode == 200) {
      // 302 is redirect after successful POST in Django
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Thank you!'),
          content: const Text('Your feedback has been submitted.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      _nameController.clear();
      _messageController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit feedback.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String title;
    if (widget.formType == 'Comments') {
      title = 'Comment';
    } else if (widget.formType == 'Problems') {
      title = 'Report a Problem';
    } else {
      title = widget.formType;
    }

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
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
                      fontFamily: 'SpaceGrotesk',
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  style: const TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    labelText: 'Your Message Here...',
                    labelStyle: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  maxLines: 4,
                  style: const TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: _isSubmitting ? null : _submitFeedback,
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}