import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parker_touch/core/base_url/base_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider
class AddMedicineManuallyProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  // final String baseUrl = 'https://1kklrhx5-8000.inc1.devtunnels.ms';

  Future<bool> addMedicineManually(
    String name,
    String dosage,
    String totalDays,
    String frequency,
    String time1,
  ) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) {
        debugPrint('No access token found');
        errorMessage = 'No access token found';
        isLoading = false;
        notifyListeners();
        return false;
      }

      // API expects times as a list
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
          'times': [time1], // Send as array
        }),
      );

      isLoading = false;
      notifyListeners();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        debugPrint("Medicine add failed: ${response.body}");

        // Parse error message from API
        try {
          final errorData = jsonDecode(response.body);
          if (errorData is Map<String, dynamic>) {
            // Extract first error message
            final firstKey = errorData.keys.first;
            final firstError = errorData[firstKey];
            if (firstError is List && firstError.isNotEmpty) {
              errorMessage = firstError[0].toString();
            } else if (firstError is String) {
              errorMessage = firstError;
            } else {
              errorMessage = 'Failed to add medicine';
            }
          } else {
            errorMessage = 'Failed to add medicine';
          }
        } catch (e) {
          errorMessage = 'Failed to add medicine';
        }
        return false;
      }
    } catch (e) {
      isLoading = false;
      errorMessage = 'Network error: ${e.toString()}';
      notifyListeners();
      debugPrint("Error adding medicine: $e");
      return false;
    }
  }
}
