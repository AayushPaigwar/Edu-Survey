// ignore_for_file: use_build_context_synchronously

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
          .from("student")
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

  //Sign up a student
  Future<List<Map<String, dynamic>>> signupStudent(
    String name,
    String email,
    String password,
    String selecteddepartment,
    String selectedcategory,
  ) async {
    try {
      final response = await client.from("student").insert(
        {
          'name': name,
          'email': email,
          'password': password,
          'category': selectedcategory,
          'department': selecteddepartment,
        },
      );
      log("Data inserted successfully");

      //navigation

      return response ?? [];
    } catch (e) {
      log(e.toString());
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> signupFaculty(
    String name,
    String email,
    String password,
    String selecteddepartment,
    String selectedcategory,
  ) async {
    try {
      final response = await client.from("faculty").insert(
        {
          'name': name,
          'email': email,
          'password': password,
          'category': selectedcategory,
          'department': selecteddepartment,
        },
      );
      log("Data inserted successfully");

      //navigation

      return response ?? [];
    } catch (e) {
      log(e.toString());
    }
    return [];
  }

  //Function to view feedback according to the department
  Future<List<Map<String, dynamic>>> viewFeedback(String department) async {
    try {
      final response = await client
          .from("feedback")
          .select("*")
          .eq('department', department);
      return response;
    } catch (e) {
      log(e.toString());
    }
    return [];
  }

  //access student ID
  Future<List<Map<String, dynamic>>> getStudentId(String email) async {
    try {
      final response =
          await client.from("student").select("id").eq('email', email);

      return response;
    } catch (e) {
      log(e.toString());
    }
    return [];
  }

  //access student name from student ID
  Future<List<Map<String, dynamic>>> getStudentName(String studentId) async {
    try {
      final response =
          await client.from("student").select("name").eq('id', studentId);

      return response;
    } catch (e) {
      log(e.toString());
    }
    return [];
  }
}
