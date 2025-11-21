import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ConnectMonitorProvider extends ChangeNotifier {
  bool isLoading = false;
  final String baseUrl = 'https://1kklrhx5-8000.inc1.devtunnels.ms';

  Future<bool> connectMonitor(String monitorEmail) async {
    try {
      isLoading = true;
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('Monitor connected successfully');
      } else {
        debugPrint('Failed to connect monitor: ${response.body}');
      }

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error connecting monitor: $e');
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
