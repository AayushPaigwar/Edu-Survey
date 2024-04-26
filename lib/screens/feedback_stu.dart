import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_feeedback/components/sized.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../provider/provider_const.dart';
import 'signin/signin_screen.dart';

class StudentFeedbackScreen extends ConsumerStatefulWidget {
  const StudentFeedbackScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StudentFeedbackScreenState();
}

class _StudentFeedbackScreenState extends ConsumerState<StudentFeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _selectedAnswers = List<String>.filled(5, '');

  @override
  Widget build(BuildContext context) {
    //question list from provider
    final _questions = ref.read(questionListProvider);
    return Scaffold(
      appBar: AppBar(
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
        centerTitle: true,
        title: const Text('Student Feedback'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                for (final question in _questions)
                  buildMCQQuestion(question, ref),
                buildHeight(30),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  color: const Color(0xff0000FE),
                  minWidth: 200,
                  height: 50,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _submitFeedback(ref);
                      // Navigate to success screen or handle feedback submission
                    }
                  },
                  child: const Text("Submit Feedback"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Add a TextField to buildMCQQuestion
  Widget buildMCQQuestion(Map<String?, dynamic> question, WidgetRef ref) {
    final questions = ref.read(questionListProvider);
    int questionIndex = questions.indexOf(question);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question['text']),
        const SizedBox(height: 8.0),
        for (final option in question['options'] as List<String>)
          RadioListTile<String>(
            title: Text(option),
            value: option,
            groupValue: _selectedAnswers[questionIndex],
            onChanged: (value) =>
                setState(() => _selectedAnswers[questionIndex] = value!),
          ),
        const Divider(),
      ],
    );
  }

// Use _feedbackTexts in _submitFeedback
  void _submitFeedback(WidgetRef ref) async {
    final questions = ref.read(questionListProvider);
    final client = Supabase.instance.client;
    final studentId = ref.read(studentIdProvider);
    final department = ref.read(selectedDepartmentProvider);

    var feedbacks = questions.asMap().entries.map((entry) {
      int i = entry.key;
      var question = entry.value;
      return {
        'student_id': studentId,
        'question_id': question['id'],
        'feedback': _selectedAnswers[i],
        'department': department,
      };
    }).toList();

    var response = await client.from('feedback').upsert(feedbacks);

    if (response != null) {
      // Handle specific Supabase error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Failed to submit feedback: ${response.error!.message}'),
        ),
      );
    } else {
      // Feedback submitted successfully
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Feedback submitted successfully'),
        ),
      );

      // Clear the selected answers
      Navigator.pushNamed(context, '/');
    }

    //   if (response == null) {
    //     log(response.toString());
    //     // Handle complete operation failure (e.g., network issue)
    //     // ScaffoldMessenger.of(context).showSnackBar(
    //     //   const SnackBar(
    //     //     content: Text('Failed to submit feedback.'),
    //     //   ),
    //     // );
    //     return;
    //   }

    //   try {
    //     if (response.error != null) {
    //       // Handle specific Supabase error
    //       // ScaffoldMessenger.of(context).showSnackBar(
    //       //   SnackBar(
    //       //     content:
    //       //         Text('Failed to submit feedback: ${response.error.message}'),
    //       //   ),
    //       // );
    //     } else {
    //       // Feedback submitted successfully
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         const SnackBar(
    //           content: Text('Feedback submitted successfully'),
    //         ),
    //       );
    //     }
    //   } catch (error) {
    //     // log('Failed to submit feedback: $error');
    //     // Display a generic error message to the user (optional)
    //   }
    // }
  }
}
