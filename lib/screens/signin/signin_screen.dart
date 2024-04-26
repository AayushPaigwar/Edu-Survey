import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_feeedback/components/sized.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Feedback App",
          style: GoogleFonts.poppins(color: Colors.white70),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "LOGIN AS A",
              style: GoogleFonts.poppins(
                  fontSize: 25.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500),
            ),
            buildHeight(20),
            ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              tileColor: const Color(0xff0000FE),
              title: const Center(
                child: Text("Student"),
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/signinstu',
                );
              },
            ),
            buildHeight(20),
            ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              tileColor: const Color(0xff0000FE),
              title: const Center(child: Text("Faculty")),
              onTap: () {
                Navigator.pushNamed(context, '/signinfac');
              },
            ),
          ],
        ),
      ),
    );
  }
}
