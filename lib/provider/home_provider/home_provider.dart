import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parker_touch/core/base_url/base_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  // Today Summary Data
  int taken = 0;
  int total = 0;
  double percentage = 0.0;
  String summaryText = '';
  String currentDate = '';
  List<int> takenMedicineIds = [];

  //final String baseUrl = 'https://1kklrhx5-8000.inc1.devtunnels.ms';

  Future<bool> todaySummaryProgressBar() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final response = await http.get(
        Uri.parse('$baseUrl/api/medicine/today-summary/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      isLoading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final summary = data['today_summary'];

        // Store the data
        taken = summary['taken'] ?? 0;
        total = summary['total'] ?? 0;
        percentage = (summary['percentage'] ?? 0.0).toDouble();
        summaryText = summary['text'] ?? '';
        currentDate = data['current_date'] ?? '';
        takenMedicineIds = List<int>.from(data['taken_medicine_ids'] ?? []);

        debugPrint('Today Summary: $summaryText');
        debugPrint('Date: $currentDate');
        debugPrint('Progress: $taken/$total ($percentage%)');

        notifyListeners();
        return true;
      } else {
        debugPrint('Failed to fetch today summary: ${response.body}');
        errorMessage = 'Failed to fetch today summary';
        return false;
      }
    } catch (e) {
      debugPrint('Error fetching today summary: $e');
      isLoading = false;
      errorMessage = 'An error occurred. Please try again.';
      notifyListeners();
      return false;
    }
  }

  //Take now home summary

  Future<bool> takeNowMedicine(int medicineId, String doseTime) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final response = await http.post(
        Uri.parse('$baseUrl/api/medicine/take-now/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'medicine_id': medicineId, 'dose_time': doseTime}),
      );

      isLoading = false;
      notifyListeners();

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('Medicine taken successfully: ${response.body}');
        return true;
      } else {
        debugPrint('Failed to take medicine: ${response.body}');
        errorMessage = 'Failed to take medicine';
        return false;
      }
    } catch (e) {
      debugPrint('Error taking medicine: $e');
      isLoading = false;
      errorMessage = 'An error occurred. Please try again.';
      notifyListeners();
      return false;
    }
  }

  //Confirm taken medicine (Match photo)
  Future<bool> confirmTakenMedicine(int medicineId, String doseTime) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      debugPrint(
        'Confirming medicine: medicineId=$medicineId, doseTime=$doseTime',
      );

      final response = await http.post(
        Uri.parse('$baseUrl/api/medicine/confirm-taken/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'medicine_id': medicineId, 'dose_time': doseTime}),
      );

      isLoading = false;
      notifyListeners();

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('Medicine confirmed taken successfully: ${response.body}');
        return true;
      } else {
        debugPrint('Failed to confirm taken medicine: ${response.body}');
        errorMessage = 'Failed to confirm taken medicine';
        return false;
      }
    } catch (e) {
      debugPrint('Error confirming taken medicine: $e');
      isLoading = false;
      errorMessage = 'An error occurred. Please try again.';
      notifyListeners();
      return false;
    }
  }

  // Verify medicine image
  bool? isMatchedMedicine;

  Future<bool> verifyMedicineImage(String imagePath, int medicineId) async {
    try {
      isLoading = true;
      errorMessage = null;
      isMatchedMedicine = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/medicine/match-photo/'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.fields['medicine_id'] = medicineId.toString();
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      isLoading = false;

      debugPrint('Verify response: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        isMatchedMedicine = data['is_match'] ?? false;
        debugPrint('Medicine match result: $isMatchedMedicine');
        notifyListeners();
        return isMatchedMedicine!;
      } else {
        errorMessage = 'Failed to verify medicine';
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('Error verifying medicine: $e');
      isLoading = false;
      errorMessage = 'An error occurred during verification';
      isMatchedMedicine = false;
      notifyListeners();
      return false;
    }
  }
}
