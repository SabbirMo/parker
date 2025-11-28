import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:parker_touch/core/base_url/base_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/model/patient_medicines/patient_medicines_response.dart';
import 'package:http/http.dart' as http;

class PatientDetailsProvider extends ChangeNotifier {
  bool isLoading = false;
  String? error;

  PatientMedicinesResponse? patientMedicines; // ★ Stored data here

  Future<void> fetchPatientMedicines(int patientId) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final response = await http.get(
        Uri.parse('$baseUrl/api/monitor/patient-medicines/$patientId/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        patientMedicines = PatientMedicinesResponse.fromJson(data); // ★ Store

        isLoading = false;
        notifyListeners();
      } else {
        error =
            'Failed to load patient medicines (Status ${response.statusCode})';
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }
}
