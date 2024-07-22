import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_feeedback/components/sized.dart';
import 'package:student_feeedback/model/supabase_function.dart';
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
    fetchQuestions();
  }

  void fetchQuestions() async {
    try {
      await SupabaseFunction().getQuestions();
    } catch (e, stackTrace) {
      log('Error fetching questions: $e', stackTrace: stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    final questionProvider = ref.watch(questionListProvider);
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
                buildHeight(30),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  color: const Color(0xff5c0f8b),
                  minWidth: 200,
                  height: 50,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _submitFeedback(ref);
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

  Widget buildMCQQuestion(Map<String?, dynamic> question, WidgetRef ref) {
    final questionsAsyncValue = ref.watch(questionListProvider);
    int questionIndex = 0;

    if (questionsAsyncValue is AsyncData<List<Map<String, dynamic>>>) {
      final questions = questionsAsyncValue.value;
      questionIndex = questions.indexOf(question as Map<String, dynamic>);
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question['question'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            for (final option in question['options'])
              RadioListTile<String>(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                title: Text(option),
                value: option,
                groupValue: _selectedAnswers[questionIndex],
                onChanged: (value) =>
                    setState(() => _selectedAnswers[questionIndex] = value!),
                activeColor: const Color(0xff5c0f8b),
              ),
            const Divider(),
          ],
        ),
      ),
    );
  }

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
      var questionIds = questions.map((question) => question['id']).toList();

      var feedbacks = {
        'student_id': studentId,
        'question_id': questionIds,
        'feedbacks': feedbackList,
      };

      log(_selectedAnswers.toString());

      var response = await client.from('feedback').upsert(feedbacks);

      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit feedback: $response'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Feedback submitted successfully'),
          ),
        );

        Navigator.pushNamed(context, '/');
      }
    }
  }
}
