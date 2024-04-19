import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/provider_const.dart';
import 'feedback_screen.dart';

class SelectDepartment extends ConsumerWidget {
  const SelectDepartment({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final departments = ref.watch(departmentlistProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Select Department",
              style: GoogleFonts.poppins(
                fontSize: 25.0,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5.0),
            ListView.builder(
                shrinkWrap: true,
                itemCount: departments.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    child: SizedBox(
                      height: 45,
                      child: ListTile(
                        minVerticalPadding: 0.0,
                        contentPadding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        tileColor: const Color(0xff0000FE),
                        title: Center(child: Text(departments[index])),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FeedBackScreen(),
                            ),
                          );
                          log("Department $index");
                        },
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
