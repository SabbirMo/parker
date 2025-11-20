import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Provider
class AddMedicineManuallyProvider extends ChangeNotifier {
  bool isLoading = false;
  final String baseUrl = 'https://k47k7scv-8000.inc1.devtunnels.ms';

  Future<bool> addMedicineManually(
    String name,
    String dosage,
    String totalDays,
    String frequency,
    String time1,
  ) async {
    try {
      isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) {
        debugPrint('No access token found');
        isLoading = false;
        notifyListeners();
        return false;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/medicine/add-manual/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'dosage': dosage,
          'total_days': totalDays,
          'frequency': frequency,
          'time1': time1,
        }),
      );

      isLoading = false;
      notifyListeners();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        debugPrint("Medicine add failed: ${response.body}");
        return false;
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint("Error adding medicine: $e");
      return false;
    }
  }
}
