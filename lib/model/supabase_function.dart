import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseFunction {
  final client = Supabase.instance.client;
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
}
