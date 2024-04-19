// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_feeedback/screens/feedback_screen.dart';

import '../../components/text_field.dart';
import '../../model/supabase_function.dart';
import '../signup/signup_screen.dart';

class SignInStu extends StatelessWidget {
  const SignInStu({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return Scaffold(
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
            // const MyDeptDropDown(),
            const SizedBox(height: 15.0),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              color: const Color(0xff0000FE),
              minWidth: double.infinity,
              onPressed: () async {
                String email = emailController.text;
                String password = passwordController.text;
                final sm = ScaffoldMessenger.of(context);

                //supaase function
                try {
                  final result =
                      await SupabaseFunction().signinStudent(email, password);

                  // log(result.toString());
                  if (result.isEmpty) {
                    log("No data found");
                    sm.showSnackBar(
                      const SnackBar(
                        content: Text("No Data Found"),
                      ),
                    );
                  }
                  if (result.isNotEmpty) {
                    log("Data found");
                    sm.showSnackBar(
                      const SnackBar(
                        content: Text("Sign In Successfull"),
                      ),
                    );
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                      builder: (context) {
                        return const FeedBackScreen();
                      },
                    ), (route) => false);
                    //clear controller
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const SignupScreen();
                    }));
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
