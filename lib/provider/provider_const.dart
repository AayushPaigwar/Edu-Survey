//this provider is used to store the list of departments
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/supabase_function.dart';

//department list provider
final departmentlistProvider = StateProvider<List<String>>((ref) {
  return [
    "CSE Department",
    "IT Department",
    "Canteen",
    "Training & Placement",
  ];
});

//category list provider
final categorylistProvider = StateProvider<List<String>>((ref) {
  return [
    "Student",
    "Faculty",
  ];
});

//selected category provider
final selectedCategoryProvider = StateProvider<String?>((ref) {
  return null;
});

//selected department provider
final selectedDepartmentProvider = StateProvider<String?>((ref) {
  return null;
});

//student id provider
final studentIdProvider = StateProvider<String?>((ref) {
  return null;
});

//question List provider

// final questionListProvider = StateProvider<List<Map<String?, dynamic>>>((ref) {
//   return [
//     {
//       'id': 1,
//       'question': 'How was the food quality?',
//       'options': ['Excellent', 'Good', 'Average', 'Poor'],
//     },
//     {
//       'id': 2,
//       'question': 'How was the cleanliness?',
//       'options': ['Excellent', 'Good', 'Average', 'Poor'],
//     },
//     {
//       'id': 3,
//       'question': 'How was the service?',
//       'options': ['Excellent', 'Good', 'Average', 'Poor'],
//     },
//     {
//       'id': 4,
//       'question': 'How was the food price?',
//       'options': ['Excellent', 'Good', 'Average', 'Poor'],
//     },
//     {
//       'id': 5,
//       'question': 'How was the food quantity?',
//       'options': ['Excellent', 'Good', 'Average', 'Poor'],
//     },
//   ];
// });

// question list provider

final questionListProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return await SupabaseFunction().getQuestions();
});

final questionIdProvider = StateProvider<String>((ref) => '');
final feedbacksProvider = StateProvider<List<dynamic>>((ref) => []);

//student name provider
final studentNameProvider = StateProvider<String?>((ref) {
  return null;
});
