import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/text_field.dart';
import '../../model/supabase_function.dart';
import '../../provider/provider_const.dart';
import '../feedback_stu.dart';

class SignInStu extends ConsumerWidget {
  const SignInStu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
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
          "Student Login",
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
            MyTextField(
              labeltext: 'Email',
              obscureText: false,
              controller: emailController,
            ),
            const SizedBox(height: 15.0),
            MyTextField(
              obscureText: true,
              labeltext: 'Passoword',
              controller: passwordController,
            ),
            const SizedBox(height: 15.0),
            const SizedBox(height: 15.0),
            MaterialButton(
              height: 50.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              color: const Color(0xff5c0f8b),
              minWidth: double.infinity,
              onPressed: () async {
                String email = emailController.text;
                String password = passwordController.text;
                final sm = ScaffoldMessenger.of(context);

                // Supabase function signin
                try {
                  final result =
                      await SupabaseFunction().signinStudent(email, password);

                  if (result.isEmpty) {
                    log("No data found");
                    sm.showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text("No Data Found"),
                      ),
                    );
                  }
                  if (result.isNotEmpty) {
                    log("Data found");
                    sm.showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text("Sign In Successfull"),
                      ),
                    );

                    // Supabase function to get Student ID
                    final studentIdResponse =
                        await SupabaseFunction().getStudentId(email);
                    if (studentIdResponse.isNotEmpty) {
                      // Access student ID from the first element of the response
                      final studentId = studentIdResponse[0]['id'].toString();
                      // Update studentIdProvider with the retrieved ID
                      ref.read(studentIdProvider.notifier).state = studentId;
                      log("Student ID: $studentIdResponse");
                    }

                    // Navigate to StudentFeedbackScreen
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                      builder: (context) {
                        return const StudentFeedbackScreen();
                      },
                    ), (route) => false);
                    // Clear controller
                    emailController.clear();
                    passwordController.clear();
                  }
                } catch (e) {
                  log(e.toString());
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
                text: TextSpan(children: [
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
            ]))
          ],
        ),
      ),
    );
  }
}
