import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:parker_touch/core/base_url/base_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RespondRequestProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  Future<bool> respondToRequest(int requestId, bool accept) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final response = await http.post(
        Uri.parse('$baseUrl/api/monitor/respond-request/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'request_id': requestId, 'action': accept}),
      );
      debugPrint('Respond Status Code: ${response.statusCode}');
      debugPrint('Respond Response: ${response.body}');

      isLoading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        return true;
      } else {
        errorMessage = 'Failed to respond to request';
        return false;
      }
    } catch (e) {
      isLoading = false;
      errorMessage = 'An error occurred: $e';
      notifyListeners();
      return false;
    }
  }
}
