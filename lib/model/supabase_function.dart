import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseFunction {
  //Instance of the Supabase client
  final client = Supabase.instance.client;

//Function to sign in a student
  Future<List<Map<String, dynamic>>> signinStudent(
      String email, String password) async {
    try {
      final response = await client
          .from("faculty")
          .select("*")
          .eq('email', email)
          .eq('password', password);

      return response;
    } catch (e) {
      log(e.toString());
    }
    return [];
  }

//Function to sign in a faculty
  Future<List<Map<String, dynamic>>> signinFaculty(
    String email,
    String password,
    String department,
  ) async {
    try {
      final response = await client
          .from("faculty")
          .select("*")
          .eq('email', email)
          .eq('password', password)
          .eq('department', department);
      return response;
    } catch (e) {
      log(e.toString());
    }
    return [];
  }

  //Function to get all the feedbacks
  Future<List<Map<String, dynamic>>> getFeedbacks() async {
    try {
      final response = await client.from("feedback").select("*");
      return response;
    } catch (e) {
      log(e.toString());
    }
    return [];
  }
}
