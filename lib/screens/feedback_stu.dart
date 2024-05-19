import 'dart:developer';

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
  void initState() {
    super.initState();
    // Fetch the question list
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(questionListProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    //question list from provider
    final questionProvider = ref.read(questionListProvider);
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
                questionProvider.when(
                  data: (questions) {
                    return Column(
                      children: [
                        for (final question in questions)
                          buildMCQQuestion(question, ref),
                      ],
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stackTrace) => Text('Error: $error'),
                ),
                // for (final question in questions)
                //   buildMCQQuestion(question, ref),
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
  // Widget buildMCQQuestion(Map<String?, dynamic> question, WidgetRef ref) {
  //   // final questions = ref.read(questionListProvider);
  //   // int questionIndex = questions.indexOf(question);
  //   return
  //   Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(question['text']),
  //       const SizedBox(height: 8.0),
  //       for (final option in question['options'] as List<String>)
  //         // RadioListTile<String>(
  //         //   title: Text(option),
  //         //   value: option,
  //         //   groupValue: _selectedAnswers[questionIndex],
  //         //   onChanged: (value) =>
  //         //       setState(() => _selectedAnswers[questionIndex] = value!),
  //         // ),
  //         const Divider(),
  //     ],
  //   );
  // }
  Widget buildMCQQuestion(Map<String?, dynamic> question, WidgetRef ref) {
    final questionsAsyncValue = ref.watch(questionListProvider);
    int questionIndex = 0;

    if (questionsAsyncValue is AsyncData<List<Map<String, dynamic>>>) {
      final questions = questionsAsyncValue.value;
      questionIndex = questions.indexOf(question as Map<String, dynamic>);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question['question']),
        const SizedBox(height: 8.0),

        // radio buttons form the supabse options column
        for (final option in question['options'])
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
    final questionsAsyncValue = ref.read(questionListProvider);
    final client = Supabase.instance.client;
    final studentId = ref.read(studentIdProvider);

    if (questionsAsyncValue is AsyncData) {
      var questions = questionsAsyncValue.value;

      var feedbackList = questions!.asMap().entries.map((entry) {
        int i = entry.key;
        return _selectedAnswers[i];
      }).toList();
      var questionids = questions.map((question) => question['id']).toList();

      var feedbacks = {
        'student_id': studentId,
        'question_id': questionids,
        'feedbacks': feedbackList,
      };

      log(_selectedAnswers.toString());

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
    }
  }
}
