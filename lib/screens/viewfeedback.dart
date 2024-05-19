import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/supabase_function.dart';
import '../provider/provider_const.dart';

// ViewStudentFeedback
class ViewStudentFeedback extends ConsumerStatefulWidget {
  const ViewStudentFeedback({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ViewStudentFeedbackState();
}

class _ViewStudentFeedbackState extends ConsumerState<ViewStudentFeedback> {
  @override
  Widget build(BuildContext context) {
    final feedbackData = ref.watch(feedbacksProvider);
    // final studentID = ;
    final studentName = SupabaseFunction()
        .getStudentName(ref.watch(studentIdProvider).toString());
    final getfeedbacks = SupabaseFunction().getFeedbacks(
      ref.read(studentIdProvider).toString(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      body: FutureBuilder(
        future: getfeedbacks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching data'),
            );
          }
          final feedbackData = snapshot.data!;

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              // to get student name
              final studentId = feedbackData[index]['student_id']; //
              final studentNameFuture =
                  SupabaseFunction().getStudentName(studentId.toString());

              return FutureBuilder(
                future: studentNameFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error fetching data'),
                    );
                  }
                  final studentName = snapshot.data![0]['name'];
                  log(snapshot.data.toString());

                  // final questions = ref.read(questionListProvider);
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Student Name: $studentName'),
                        Text(
                            'Question Id: ${feedbackData[index]['question_id']}'),
                        Text('Feedback: ${feedbackData[index]['feedbacks']}'),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
