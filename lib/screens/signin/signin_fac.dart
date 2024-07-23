import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_feeedback/components/sized.dart';
import 'package:student_feeedback/model/supabase_function.dart';

import '../../components/dropdown.dart';
import '../../components/text_field.dart';
import '../../provider/provider_const.dart';

class SigninFac extends ConsumerStatefulWidget {
  const SigninFac({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SigninFacState();
}

class _SigninFacState extends ConsumerState<SigninFac> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final departmentSelected = ref.watch(selectedDepartmentProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Faculty Login",
          style: GoogleFonts.poppins(color: Colors.grey),
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
            _buildTextField(emailController, 'Email', false),
            buildHeight(15),
            _buildTextField(passwordController, 'Password', true),
            buildHeight(30),
            _buildLoginButton(departmentSelected),
            const SizedBox(height: 15.0),
            _buildSignUpText(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String labelText, bool obscureText) {
    return MyTextField(
      key: Key("${labelText.toLowerCase()}_field"),
      labeltext: labelText,
      obscureText: obscureText,
      controller: controller,
    );
  }

  Widget _buildLoginButton(String? departmentSelected) {
    return MaterialButton(
      height: 50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      color: const Color(0xff5c0f8b),
      minWidth: double.infinity,
      onPressed: () async {
        await _handleLogin(departmentSelected);
      },
      child: Text(
        "Login",
        style: GoogleFonts.poppins(color: Colors.white),
      ),
    );
  }

  Future<void> _handleLogin(String? departmentSelected) async {
    final email = emailController.text;
    final password = passwordController.text;
    final sm = ScaffoldMessenger.of(context);

    if (email.isEmpty || password.isEmpty || departmentSelected == null) {
      sm.showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Please fill all fields"),
        ),
      );
      return;
    }

    try {
      final result = await SupabaseFunction()
          .signinFaculty(email, password, departmentSelected);

      if (result.isEmpty) {
        sm.showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("No Data Found"),
          ),
        );
      } else {
        sm.showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Sign In Successful"),
          ),
        );
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/feedbackfac',
          (route) => false,
        );
      }
    } catch (error) {
      log(error.toString());
      sm.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("An error occurred: $error"),
        ),
      );
    }
  }

  Widget _buildSignUpText(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "Don't have an account? ",
            style: GoogleFonts.poppins(color: Colors.grey),
          ),
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushNamed(context, '/signup');
              },
            text: "Sign Up",
            style: GoogleFonts.poppins(color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
