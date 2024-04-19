import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextField extends StatelessWidget {
  final bool obscureText;
  final String labeltext;
  final TextEditingController controller;
  final Key? keyvalue;
  const MyTextField({
    super.key,
    required this.labeltext,
    required this.obscureText,
    required this.controller,
    this.keyvalue,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      width: double.infinity,
      child: TextFormField(
        key: key,
        controller: controller,
        obscureText: obscureText,
        style: GoogleFonts.poppins(),
        decoration: InputDecoration(
          //enable border
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),

          // Add focused border
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          labelText: labeltext,
          hintText: "Enter your email",
          labelStyle: GoogleFonts.poppins(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
