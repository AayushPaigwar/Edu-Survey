// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_feeedback/components/sized.dart';
import 'package:student_feeedback/model/supabase_function.dart';

import '../../components/dropdown.dart';
import '../../components/text_field.dart';
import '../../provider/provider_const.dart';
import '../feedback_fac.dart';

class SigninFac extends ConsumerWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  SigninFac({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? departmentSelected = ref.watch(selectedDepartmentProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          "Faculty Login",
          style: GoogleFonts.poppins(
            color: Colors.grey,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Login",
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            const MyDeptDropDown(),
            buildHeight(15),
            MyTextField(
              key: const Key("email_field"),
              labeltext: 'Email',
              obscureText: false,
              controller: emailController,
            ),
            buildHeight(15),
            MyTextField(
              key: const Key("password_field"),
              obscureText: true,
              labeltext: 'Passoword',
              controller: passwordController,
            ),
            buildHeight(30),
            MaterialButton(
              height: 50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              color: const Color(0xff5c0f8b),
              minWidth: double.infinity,
              onPressed: () async {
                String email = emailController.text;
                String password = passwordController.text;
                String? department = departmentSelected;
                final sm = ScaffoldMessenger.of(context);

                // Save isLoggedIn state
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', true);

                //supaase function
                try {
                  final result = await SupabaseFunction().signinFaculty(
                    email,
                    password,
                    department!,
                  );

                  if (result.isEmpty) {
                    sm.showSnackBar(
                      const SnackBar(
                        content: Text("No Data Found"),
                      ),
                    );
                  }
                  if (result.isNotEmpty) {
                    sm.showSnackBar(
                      const SnackBar(
                        content: Text("Sign In Successfull"),
                      ),
                    );
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ViewFeedBack(),
                      ),
                      (route) => false,
                    );
                  }
                } catch (error) {
                  log(error.toString());
                }
              },
              child: Text(
                "Login",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 15.0),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Don't have an account? ",
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                    ),
                  ),
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        log("Sign Up");
                        Navigator.pushNamed(context, '/signup');
                      },
                    text: "Sign Up",
                    style: GoogleFonts.poppins(
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
