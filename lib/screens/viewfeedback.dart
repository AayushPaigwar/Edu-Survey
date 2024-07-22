import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    // Assuming studentIdProvider gives us the student's ID
    final studentId = ref.read(studentIdProvider).toString();
    final futureQuestionsAndFeedbacks =
        SupabaseFunction().getQuestionsAndFeedbacks(studentId);

    //arguments from the navigator
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;

    // Extracting the student ID from the arguments
    final studentName = arguments['studentName'];
    final studentDepartment = arguments['department'];

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('View Feedback'),
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'No',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/', (route) => false);

                            //prefs clear
                            final prefs = SharedPreferences.getInstance();
                            prefs.then((value) => value.clear());
                          },
                          child: Text(
                            'Yes',
                            style: TextStyle(color: Colors.red[500]),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: FutureBuilder(
            future: futureQuestionsAndFeedbacks,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                // Extracting the data from the snapshot
                List<Map<String, dynamic>> data = snapshot.data!.toList();
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    children: [
                      //name and depramtn
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: $studentName',
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '$studentDepartment',
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            var item = data[index];
                            var question = item['question']
                                ['question']; // Extracting the question
                            var feedback =
                                item['feedback']; // Extracting the feedback
                            return Card(
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 16),
                                title: Text(
                                  question,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    feedback,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                                leading: CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(child: Text('No data available'));
              }
            }));
  }
}
