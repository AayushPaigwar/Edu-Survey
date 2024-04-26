// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:student_feeedback/screens/signin/signin_screen.dart';

// import '../model/supabase_function.dart';
// import '../provider/provider_const.dart';

// class ViewFeedBack extends ConsumerStatefulWidget {
//   const ViewFeedBack({super.key});

//   @override
//   ConsumerState<ViewFeedBack> createState() => _ViewFeedBackState();
// }

// class _ViewFeedBackState extends ConsumerState<ViewFeedBack> {
//   @override
//   Widget build(BuildContext context) {
//     final getfeedbacks = SupabaseFunction().getFeedbacks();
//     final getstudentname = SupabaseFunction()
//         .getStudentName(ref.read(studentIdProvider).toString());
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('View Feedback'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const SignInScreen(),
//                   ),
//                   (route) => false);
//             },
//             icon: const Icon(Icons.logout),
//           ),
//         ],
//       ),
//       body: FutureBuilder(
//         future: Future.wait([getfeedbacks, getstudentname]),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           if (snapshot.hasError) {
//             return const Center(
//               child: Text('Error fetching data'),
//             );
//           }
//           var feedbacks = snapshot.data![0];
//           var studentid = snapshot.data![1];
//           return ListView.builder(
//             itemCount: feedbacks.length,
//             itemBuilder: (context, index) {
//               return Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey.shade800, width: 0.5),
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 height: MediaQuery.of(context).size.height * 0.2,
//                 width: MediaQuery.of(context).size.width * 0.9,
//                 margin: const EdgeInsets.all(10.0),
//                 child: Column(
//                   children: [
//                     // ListTile(
//                     //   title: Text('Feedback: ${feedbacks[index]['feedback']}'),
//                     //   subtitle: Text(
//                     //       'Question_id: ${feedbacks[index]['question_id']}'),
//                     // )
//                     Text('Feedback: ${feedbacks[index]['feedback']}'),
//                     Text('Question_id: ${feedbacks[index]['question_id']}'),
//                     Text('Student Name: ${studentid[0]['name']}'),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
