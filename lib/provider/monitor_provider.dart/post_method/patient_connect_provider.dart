import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:parker_touch/core/base_url/base_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PatientConnectProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  Map<String, dynamic>? patientData;

  Future<bool> searchToPatient(String email) async {
    try {
      isLoading = true;
      errorMessage = null;
      patientData = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final response = await http.post(
        Uri.parse('$baseUrl/api/monitor/search-patient/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"email_or_username": email}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        patientData = data['patient'];
        debugPrint('Patient Data: $patientData');
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        debugPrint('Failed to connect to patient: ${response.body}');
        errorMessage = 'Patient not found';
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      isLoading = false;
      errorMessage = 'Failed to connect to patient: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> sendPatientRequest(int patientId) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final response = await http.post(
        Uri.parse('$baseUrl/api/monitor/send-request/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'patient_id': patientId}),
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
}
