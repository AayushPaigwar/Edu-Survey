import 'package:flutter/material.dart';
import 'package:student_feeedback/screens/signin/signin_screen.dart';

class ViewFeedBack extends StatefulWidget {
  const ViewFeedBack({super.key});

  @override
  State<ViewFeedBack> createState() => ViewFeedBackState();
}

class ViewFeedBackState extends State<ViewFeedBack> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Feedback'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignInScreen(),
                  ),
                  (route) => false);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const Center(
        child: Text('View Feedback'),
      ),
    );
  }
}
