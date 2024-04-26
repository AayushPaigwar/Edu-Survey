import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_feeedback/screens/signin/signin_screen.dart';

import '../model/supabase_function.dart';
import '../provider/provider_const.dart';

class ViewFeedBack extends ConsumerStatefulWidget {
  const ViewFeedBack({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViewFeedBackState();
}

class _ViewFeedBackState extends ConsumerState<ViewFeedBack> {
  @override
  Widget build(BuildContext context) {
    final getfeedbacks = SupabaseFunction().getFeedbacks();
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
              final studentId = feedbackData[index]['student_id']; //
              final studentNameFuture =
                  SupabaseFunction().getStudentName(studentId.toString());

              return FutureBuilder(
                future: studentNameFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error fetching data'),
                    );
                  }
                  final studentName = snapshot.data![0]['name'];
                  final questions = ref.read(questionListProvider);
                  return Container(
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.grey.shade800, width: 0.5),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.9,
                    margin: const EdgeInsets.all(10.0),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Student Name: $studentName'),
                          Text('Feedback: ${feedbackData[index]['feedback']}'),
                          Text(
                              'Question_id: ${feedbackData[index]['question_id']}'),
                        ],
                      ),
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
