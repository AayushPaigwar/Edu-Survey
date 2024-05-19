import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextField extends StatefulWidget {
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
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _isValid = true;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      width: double.infinity,
      child: TextFormField(
        key: widget.keyvalue,
        controller: widget.controller,
        obscureText: widget.obscureText,
        style: GoogleFonts.poppins(),
        decoration: InputDecoration(
          //content padding
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),

          //error style
          errorStyle: GoogleFonts.poppins(
            color: Colors.red,
            height: 0.3, // to increase space between error text and input field
          ),
          //focused error border
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
          //error border
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
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
          labelText: widget.labeltext,
          hintText: "Enter your email",
          labelStyle: GoogleFonts.poppins(
            color: Colors.grey,
          ),
          errorText: _isValid
              ? null
              : 'Please enter ${widget.labeltext.toLowerCase()}',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            setState(() {
              _isValid = false;
            });
          } else {
            setState(() {
              _isValid = true;
            });
          }
        },
      ),
    );
  }
}
