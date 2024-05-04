import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pantherai/main.dart';

class FeedbackPage extends StatefulWidget {
  final String firstName;
  const FeedbackPage({
    super.key,
    required this.firstName,
  });
  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _submissionController = TextEditingController();
  late String _firstName;

  void _logout() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  void _submit() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Feedback submitted")));
    _submissionController.clear();
  }

  @override
  void initState() {
    super.initState();
    _firstName = widget.firstName; // Assign value in initState
  }

  void _chat() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ChatHomePage(firstName: _firstName)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: Text("What would you like the AI to know, $_firstName?"),
        actions: [
          IconButton(onPressed: _chat, icon: const Icon(Icons.message)),
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                autofocus: true,
                controller: _submissionController,
                decoration: const InputDecoration(
                  labelText: "Tell us BMCC secrets!",
                ),
              ),
              const SizedBox(height: 20, width: 50),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Submit"),
              ),
              const SizedBox(height: 20),
              const Text(
                'We\'d love to hear from you!',
                style: TextStyle(
                    color: Colors.white), // Adjust text color as needed
              ),
              const SizedBox(
                  height: 5.0), // Add a small gap between text and link
              InkWell(
                  onTap: () => launchUrl( Uri(scheme: "mailto" ,path: "mehdi.shakibapour@gmail.com", queryParameters: {'subject': 'Example'}
	)), 
                  child: const Text(
                    'Email us @ PantherAI@gmail.com',
                    style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration
                            .underline), // Underline the email address
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
