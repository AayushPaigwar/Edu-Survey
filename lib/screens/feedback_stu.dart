// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_feeedback/model/supabase_function.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../components/sized.dart';
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

  Future<void> fetchQuestions() async {
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
                MaterialPageRoute(builder: (context) => const SignInScreen()),
                (route) => false,
              );
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
                        Column(
                          children: questions
                              .map(
                                (question) => buildMCQQuestion(question),
                              )
                              .toList(),
                        ),
                        buildHeight(30),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          color: const Color(0xff5c0f8b),
                          minWidth: 200,
                          height: 50,
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              _submitFeedback(context);
                            }
                          },
                          child: const Text("Submit Feedback"),
                        ),
                      ],
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) => Text('Error: $error'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMCQQuestion(Map<String, dynamic> question) {
    final questionIndex =
        ref.read(questionListProvider).value?.indexOf(question) ?? 0;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question['question'] ?? '',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            ...List.generate(
              (question['options'] as List).length,
              (index) => RadioListTile<String>(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                title: Text(question['options'][index]),
                value: question['options'][index],
                groupValue: _selectedAnswers[questionIndex],
                onChanged: (value) => setState(() {
                  _selectedAnswers[questionIndex] = value!;
                }),
                activeColor: const Color(0xff5c0f8b),
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  Future<void> _submitFeedback(BuildContext context) async {
    final questionsAsyncValue = ref.read(questionListProvider);
    final client = Supabase.instance.client;
    final studentId = ref.read(studentIdProvider);

    if (questionsAsyncValue is AsyncData<List<Map<String, dynamic>>>) {
      final questions = questionsAsyncValue.value;
      final feedbackList = List.generate(
        questions.length,
        (i) => _selectedAnswers[i],
      );
      final questionIds = questions.map((q) => q['id']).toList();

      // Validate that all questions have been answered
      if (feedbackList.any((answer) => answer.isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Please select an option for all questions'),
          ),
        );
        return;
      }

      final response = await client.from('feedback').upsert({
        'student_id': studentId,
        'question_id': questionIds,
        'feedbacks': feedbackList,
      });

      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Failed to submit feedback: $response'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Feedback submitted successfully'),
          ),
        );
        Navigator.pushNamed(context, '/');
      }
    }
  }
}
