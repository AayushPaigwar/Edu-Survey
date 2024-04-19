import 'package:flutter/material.dart';
import 'package:student_feeedback/screens/signin/signin_screen.dart';

import '../model/supabase_function.dart';

class ViewFeedBack extends StatefulWidget {
  const ViewFeedBack({super.key});

  @override
  State<ViewFeedBack> createState() => ViewFeedBackState();
}

class ViewFeedBackState extends State<ViewFeedBack> {
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
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade800, width: 0.5),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.9,
                margin: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                          'Feedback: ${snapshot.data![index]['feedback']}'),
                      subtitle:
                          Text('Faculty: ${snapshot.data![index]['faculty']}'),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
