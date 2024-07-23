// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_feeedback/components/sized.dart';
import 'package:student_feeedback/components/text_field.dart';
import 'package:student_feeedback/model/supabase_function.dart';

import '../../components/dropdown.dart';
import '../../provider/provider_const.dart';

class SignupScreen extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  SignupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final selectedDepartment = ref.watch(selectedDepartmentProvider);

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                //dropdown
                buildHeight(15.0),
                const MycategoryDropDown(),
                buildHeight(15.0),
                const MyDeptDropDown(),
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

                buildHeight(30.0),
                //signup button
                MaterialButton(
                  color: const Color(0xff5c0f8b),
                  height: 50.0,
                  minWidth: MediaQuery.of(context).size.width * 0.95,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  onPressed: () {
                    userCheck(selectedCategory, selectedDepartment, context);
                  },
                  child: Text(
                    "Signup",
                    style:
                        GoogleFonts.poppins(color: Colors.white, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void userCheck(String? selectedCategory, String? selectedDepartment,
      BuildContext context) {
    if (_formKey.currentState!.validate()) {
      try {
        var response;
        if (selectedCategory == 'Student') {
          response = SupabaseFunction().signupStudent(
            nameController.text,
            emailController.text,
            passwordController.text,
            selectedDepartment.toString(),
            selectedCategory.toString(),
          );
        } else if (selectedCategory == 'Faculty') {
          response = SupabaseFunction().signupFaculty(
              nameController.text,
              emailController.text,
              passwordController.text,
              selectedDepartment.toString(),
              selectedCategory.toString());
        }
        handleResponse(response, context);
      } catch (e) {
        showFailureMessage(context);
      }
    }
  }

  void handleResponse(response, BuildContext context) {
    if (response != null &&
        nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      // Signup successful
      showSuccessMessage(context);
      Navigator.pushNamed(context, '/');
    } else {
      // Signup failed
      showFailureMessage(context);
    }
  }

  void showSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("Signup Successful, Please Login"),
      ),
    );
  }

  void showFailureMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("Signup Failed, Please try again"),
      ),
    );
  }
}
