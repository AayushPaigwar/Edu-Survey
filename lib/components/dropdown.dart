//dropdown
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/provider_const.dart';

class MyDeptDropDown extends ConsumerWidget {
  const MyDeptDropDown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDepartment = ref.watch(selectedDepartmentProvider);
    return Container(
      height: 55.0,
      width: MediaQuery.of(context).size.width * 0.95,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: DropdownButton<String>(
        underline: Container(),
        isExpanded: true,
        hint: const Text("Select Department"),
        value: selectedDepartment,
        onChanged: (value) {
          if (value != null && value != selectedDepartment) {
            ref.read(selectedDepartmentProvider.notifier).state = value;
          }
        },
        items: ref
            .watch(departmentlistProvider.notifier)
            .state
            .map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}

class MycategoryDropDown extends ConsumerWidget {
  const MycategoryDropDown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? selectCategory = ref.watch(selectedCategoryProvider);

    return Container(
      height: 55.0,
      width: MediaQuery.of(context).size.width * 0.95,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: DropdownButton<String>(
        underline: Container(),
        isExpanded: true,
        hint: const Text("Select Category"),
        value: selectCategory,
        onChanged: (value) {
          ref.read(selectedCategoryProvider.notifier).state = value!;
        },
        items:
            ref.watch(categorylistProvider.notifier).state.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
