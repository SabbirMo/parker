import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parker_touch/core/base_url/base_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SendRequestMonitorProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  // final String baseUrl = 'https://1kklrhx5-8000.inc1.devtunnels.ms';

  Future<bool> sendMonitorRequest(int monitorId) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final response = await http.post(
        Uri.parse('$baseUrl/api/patient-monitors/send-request/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'monitor_id': monitorId}),
      );

      isLoading = false;
      notifyListeners();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final success = data['detail'];
        debugPrint('Monitor request sent successfully: $success');
        return true;
      } else {
        // Handle error response
        try {
          final errorData = jsonDecode(response.body);
          errorMessage = errorData['detail'] ?? 'Failed to send request';
        } catch (e) {
          errorMessage = 'Failed to send request';
        }
        debugPrint('Failed to send request: ${response.body}');
        return false;
      }
    } catch (e) {
      isLoading = false;
      errorMessage = 'An error occurred. Please try again.';
      notifyListeners();
      debugPrint('Error sending request: $e');
      return false;
    }
  }

  //Respond Request from Incoming Monitor
  Future<bool> respondToRequest(int requestId, String action) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final response = await http.post(
        Uri.parse('$baseUrl/api/patient-monitors/respond-request/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'request_id': requestId,
          'action': action, // "accept" or "reject"
        }),
      );

      isLoading = false;
      notifyListeners();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        debugPrint('Request $action successfully: ${data['detail']}');
        return true;
      } else {
        // Handle error response
        try {
          final errorData = jsonDecode(response.body);
          errorMessage = errorData['detail'] ?? 'Failed to $action request';
        } catch (e) {
          errorMessage = 'Failed to $action request';
        }
        debugPrint('Failed to $action request: ${response.body}');
        return false;
      }
    } catch (e) {
      isLoading = false;
      errorMessage = 'An error occurred. Please try again.';
      notifyListeners();
      debugPrint('Error responding to request: $e');
      return false;
    }
  }
}
