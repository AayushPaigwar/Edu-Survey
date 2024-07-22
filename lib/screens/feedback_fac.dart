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
  @override
  Widget build(BuildContext context) {
    final getfeedbacks = SupabaseFunction().getFeedbacks(
      ref.read(studentIdProvider).toString(),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('View Feedback'),
      ),
      body: FutureBuilder(
        future: getfeedbacks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          }
          final feedbackData = snapshot.data!;
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final studentId = feedbackData[index]['student_id'];
              final studentNameFuture =
                  SupabaseFunction().getStudentName(studentId.toString());

              return FutureBuilder(
                future: studentNameFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error fetching data'));
                  }
                  final studentName = snapshot.data![0]['name'];
                  final department = snapshot.data![0]['department'];

                  return InkWell(
                    onTap: () {
                      //navigate to feedback page'
                      Navigator.pushNamed(context, '/viewfeedback', arguments: {
                        'studentName': studentName,
                        'department': department,
                      });
                    },
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 16),
                        title: Text(
                          studentName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '$department',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            studentName[0],
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
              );
            },
          );
        },
      ),
    );
  }
}
