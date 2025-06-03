import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../../common/services/authSharedPrefHelper.dart';

class ApiClient {
  static const _baseUrl = 'https://myhealthvaults.com/api/v1/';

  static Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? body}) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$path'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    print(response.body);
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> postWithToken(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final token = await SharedPrefHelper.getToken();
      final response = await http.post(
        Uri.parse('$_baseUrl$endpoint'),
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // Debug log
      debugPrint('GET $endpoint → Status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e, st) {
      debugPrint('GET $endpoint failed: $e');
      debugPrintStack(stackTrace: st);
      rethrow; // Pass the error to the caller (like the controller)
    }
  }

  static Future<Map<String, dynamic>> deleteProfile(String endpoint, String pId) async {
    try {
      final token = await SharedPrefHelper.getToken();
      final response = await http.post(Uri.parse('$_baseUrl$endpoint'), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      }, body:jsonEncode({
        "pid": pId
      }) );

      // Debug log
      debugPrint('GET $endpoint → Status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e, st) {
      debugPrint('GET $endpoint failed: $e');
      debugPrintStack(stackTrace: st);
      rethrow; // Pass the error to the caller (like the controller)
    }
  }

  static Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final token = await SharedPrefHelper.getToken();
      final response = await http.get(
        Uri.parse('$_baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // Debug log
      debugPrint('GET $endpoint → Status: ${response.statusCode}');
      // debugPrint('Response body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e, st) {
      debugPrint('GET $endpoint failed: $e');
      debugPrintStack(stackTrace: st);
      rethrow; // Pass the error to the caller (like the controller)
    }
  }
}
