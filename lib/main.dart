import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_feeedback/screens/feedback_stu.dart';
import 'package:student_feeedback/screens/signup/signup_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/signin/signin_fac.dart';
import 'screens/signin/signin_screen.dart';
import 'screens/signin/signin_stu.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "assets/.env");

  await Supabase.initialize(
    url: dotenv.env["SUPABASE_URL"]!,
    anonKey: dotenv.env["SUPABASE_KEY"]!,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const SignInScreen(),
        '/signinstu': (context) => const SignInStu(),
        '/signinfac': (context) => SigninFac(),
        '/signup': (context) => SignupScreen(),
        '/feedbackstu': (context) => const StudentFeedbackScreen(),
      },
      theme: ThemeData(
          fontFamily: GoogleFonts.poppins().fontFamily,
          brightness: Brightness.dark),
      initialRoute: '/',
    );
  }
}
