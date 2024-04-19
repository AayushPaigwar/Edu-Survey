//this provider is used to store the list of departments
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
