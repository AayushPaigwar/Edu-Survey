import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/supabase_function.dart';
import '../provider/provider_const.dart';

class ViewStudentFeedback extends ConsumerStatefulWidget {
  const ViewStudentFeedback({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ViewStudentFeedbackState();
}

class _ViewStudentFeedbackState extends ConsumerState<ViewStudentFeedback> {
  // function - Fetch questions and feedbacks
  Future<List<Map<String, dynamic>>> _fetchQuestionsAndFeedbacks(
      String studentId) {
    return SupabaseFunction().getQuestionsAndFeedbacks(studentId);
  }

  //show logout dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (route) => false);
                // Optional: Clear shared preferences or other cleanup actions
                // final prefs = SharedPreferences.getInstance();
                // prefs.then((value) => value.clear());
              },
              child: Text('Yes', style: TextStyle(color: Colors.red[500])),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final studentId = ref.read(studentIdProvider).toString();

    final futureQuestionsAndFeedbacks = _fetchQuestionsAndFeedbacks(studentId);

    final arguments = ModalRoute.of(context)?.settings.arguments as Map?;
    final studentName = arguments?['studentName'] ?? 'Unknown';
    final studentDepartment = arguments?['department'] ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('View Feedback'),
        actions: [
          IconButton(
            onPressed: () => _showLogoutDialog(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureQuestionsAndFeedbacks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: $studentName',
                      style: const TextStyle(fontSize: 18)),
                  Text('Department: $studentDepartment',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final item = snapshot.data![index];
                      final question =
                          item['question']['question'] ?? 'No Question';
                      final feedback = item['feedback'] ?? 'No Feedback';

                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          title: Text(question,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(feedback,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[600])),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text('${index + 1}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
