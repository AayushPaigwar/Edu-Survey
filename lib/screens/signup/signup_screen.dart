import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_feeedback/components/sized.dart';
import 'package:student_feeedback/components/text_field.dart';

import '../../components/dropdown.dart';
import '../../components/provider_const.dart';

class SignupScreen extends ConsumerWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildHeight(20.0),
            const Text(
              "Signup",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            buildHeight(20.0),
            MyTextField(
              obscureText: false,
              labeltext: 'Name',
              controller: nameController,
            ),
            buildHeight(15.0),

            MyTextField(
              labeltext: 'Email',
              obscureText: false,
              controller: emailController,
            ),
            buildHeight(15.0),
            MyTextField(
              obscureText: true,
              labeltext: 'Passoword',
              controller: passwordController,
            ),
            buildHeight(15.0), const MyDeptDropDown(),
            buildHeight(15.0), //dropdown
            const MycategoryDropDown(),
            buildHeight(30.0),
            //signup button
            MaterialButton(
              color: const Color(0xff0000FE),
              height: 50.0,
              minWidth: MediaQuery.of(context).size.width * 0.95,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              onPressed: () {
                //supabase insert

                //navigation

                //log message
                log(selectedCategory.toString());
              },
              child: Text(
                "Signup",
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
