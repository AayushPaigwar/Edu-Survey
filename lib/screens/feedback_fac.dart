import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/supabase_function.dart';
import '../provider/provider_const.dart';

class ViewFeedBack extends ConsumerStatefulWidget {
  const ViewFeedBack({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViewFeedBackState();
}

class _ViewFeedBackState extends ConsumerState<ViewFeedBack> {
  late Future<Map<String, dynamic>> _feedbacksFuture;

  @override
  void initState() {
    super.initState();
    _feedbacksFuture = _fetchFeedbacksAndStudentData();
  }

  Future<Map<String, dynamic>> _fetchFeedbacksAndStudentData() async {
    final studentId = ref.read(studentIdProvider).toString();
    final feedbacks = await SupabaseFunction().getFeedbacks(studentId);

    // Create a map to hold student names and departments for all feedbacks
    final Map<String, Map<String, String>> studentData = {};

    for (var feedback in feedbacks) {
      final studentId = feedback['student_id'].toString();
      if (!studentData.containsKey(studentId)) {
        final studentNameData =
            await SupabaseFunction().getStudentName(studentId.toString());
        if (studentNameData.isNotEmpty) {
          studentData[studentId] = {
            'name': studentNameData[0]['name'].toString(),
            'department': studentNameData[0]['department'].toString()
          };
        }
      }
    }

    return {
      'feedbacks': feedbacks,
      'studentData': studentData,
    };
  }

  Future<void> _refreshData() async {
    setState(() {
      _feedbacksFuture = _fetchFeedbacksAndStudentData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('View Feedback'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _feedbacksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data available'));
          }

          final data = snapshot.data!;
          final feedbacks = data['feedbacks'] as List<dynamic>;
          final studentData =
              data['studentData'] as Map<String, Map<String, String>>;

          return RefreshIndicator(
            onRefresh: _refreshData,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: feedbacks.length,
              itemBuilder: (context, index) {
                final studentId = feedbacks[index]['student_id'].toString();
                final student = studentData[studentId];

                if (student == null) {
                  return const SizedBox(); // Empty widget if no student data is available
                }

                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/viewfeedback', arguments: {
                      'studentName': student['name'],
                      'department': student['department'],
                    });
                  },
                  child: Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 16),
                      title: Text(
                        student['name']!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        student['department']!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          student['name']![0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
