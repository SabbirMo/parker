import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parker_touch/core/base_url/base_url.dart';
import 'package:parker_touch/view/patient/medicines/model/medicine_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConnectMonitorProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  Map<String, dynamic>? monitorData;
  List<MonitorItem> monitorsList = [];
  // final String baseUrl = 'https://1kklrhx5-8000.inc1.devtunnels.ms';

  Future<bool> connectMonitor(String monitorEmail) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final perfs = await SharedPreferences.getInstance();
      final token = perfs.getString('accessToken') ?? '';

      final response = await http.post(
        Uri.parse('$baseUrl/api/patient-monitors/search-monitor/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'email_or_username': monitorEmail}),
      );

      isLoading = false;
      notifyListeners();

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('Monitor found successfully');
        debugPrint('API Response: ${response.body}');
        // Parse and store monitor data
        try {
          final responseData = jsonDecode(response.body);
          monitorData = responseData['monitor'];
          debugPrint('Monitor Data: $monitorData');
          debugPrint('Full Name: ${monitorData?['full_name']}');
          debugPrint('Email: ${monitorData?['email']}');
          debugPrint('Profile Image: ${monitorData?['profile_image']}');
        } catch (e) {
          debugPrint('Error parsing monitor data: $e');
        }
        return true;
      } else {
        debugPrint('Failed to connect monitor: ${response.body}');
        // Parse error message from response
        try {
          final errorData = jsonDecode(response.body);
          if (errorData['email_or_username'] != null &&
              errorData['email_or_username'] is List) {
            errorMessage = errorData['email_or_username'][0];
          } else {
            errorMessage = 'Monitor not found';
          }
        } catch (e) {
          errorMessage = 'Monitor not found';
        }
        return false;
      }
    } catch (e) {
      debugPrint('Error connecting monitor: $e');
      isLoading = false;
      errorMessage = 'An error occurred. Please try again.';
      notifyListeners();
      return false;
    }
  }

  //Monitor List for Patient
  Future<bool> fetchPatientMonitors() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final response = await http.get(
        Uri.parse('$baseUrl/api/patient-monitors/my-monitors/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      isLoading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('API Response: ${response.body}');
        final monitorsData = data['monitors'] as List;

        // Parse and store monitors list
        monitorsList = monitorsData
            .map((monitor) => MonitorItem.fromJson(monitor))
            .toList();

        debugPrint(
          'Patient monitors fetched successfully: ${monitorsList.length} monitors',
        );
        for (var monitor in monitorsList) {
          debugPrint('Monitor: ${monitor.fullName}, Status: ${monitor.status}');
        }
        notifyListeners();
        return true;
      } else {
        debugPrint('Failed to fetch patient monitors: ${response.body}');
        errorMessage = 'Failed to fetch patient monitors';
        return false;
      }
    } catch (e) {
      debugPrint('Error fetching patient monitors: $e');
      isLoading = false;
      errorMessage = 'An error occurred. Please try again.';
      notifyListeners();
      return false;
    }
  }
}
