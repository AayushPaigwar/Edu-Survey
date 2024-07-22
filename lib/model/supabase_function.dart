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

      return response ?? [];
    } catch (e) {
      log(e.toString());
    }
    return [];
  }

//Sign up a faculty
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
      final response = await client
          .from("student")
          .select("name, department")
          .eq('id', studentId);

      return response;
    } catch (e) {
      log(e.toString());
    }
    return [];
  }

  //Function to view feedback according to the department
  // Future<List<Map<String, dynamic>>> viewFeedback(String department) async {
  //   try {
  //     final response = await client
  //         .from("feedback")
  //         .select("*")
  //         .eq('department', department);
  //     return response;
  //   } catch (e) {
  //     log(e.toString());
  //   }
  //   return [];
  // }

  //Function to get all the feedbacks
  Future<List<Map<String, dynamic>>> getFeedbacks(dynamic studentId) async {
    try {
      final response = await client.from("feedback").select("*");

      log(response.toString(), name: 'getFeedbacks');
      return response;
    } catch (e) {
      log(e.toString());
    }
    return [];
  }

// Function to get questions
  Future<List<Map<String, dynamic>>> getQuestions() async {
    try {
      final response = await client.from("questions").select("*");
      return response;
    } catch (e) {
      log(e.toString());
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getQuestionsAndFeedbacks(
      String studentId) async {
    try {
      // Fetch feedbacks for a department
      final feedbacksData = await getFeedbacks(studentId);
      if (feedbacksData.isEmpty) {
        return [];
      }
      List<dynamic> questionIds = feedbacksData.first['question_id'];
      List<dynamic> feedbacks = feedbacksData.first['feedbacks'];

      //Fetch all questions and filter by questionIds
      final allQuestions = await getQuestions();
      List<Map<String, dynamic>> relevantQuestions = allQuestions
          .where((question) => questionIds.contains(question['id']))
          .toList();

      // log(relevantQuestions.toString(), name: 'revelantQuestions');

      // Combine questions with their feedbacks
      List<Map<String, dynamic>> combinedData = [];
      for (int i = 0; i < relevantQuestions.length; i++) {
        combinedData.add({
          'question': relevantQuestions[i],
          'feedback': feedbacks[i],
        });
      }

      // log(combinedData.toString(), name: 'combinedData');

      // Return combined data
      return combinedData;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  // //Function to fetch questions
  // Future<List<String>> getQuestionFromQuestionID(
  //     List<dynamic> questionIds) async {
  //   var response =
  //       await client.from('questions').select('question').eq('id', questionIds);

  //   if (response.isNotEmpty) {
  //     return response.map((e) => e['question'].toString()).toList();
  //   } else {
  //     throw Exception('Failed to fetch questions: $response');
  //   }
  // }
}
