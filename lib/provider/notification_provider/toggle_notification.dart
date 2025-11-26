import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parker_touch/core/base_url/base_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ToggleNotification extends ChangeNotifier {
  bool pushNotification = true;
  bool isLoading = false;
  String? errorMessage;

  // Initialize notification preference from SharedPreferences
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      pushNotification = prefs.getBool('receive_notifications') ?? true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing notification preference: $e');
    }
  }

  // Toggle notification preference and sync with backend
  Future<bool> togglePushNotification(bool value) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        debugPrint('No access token found. User not logged in.');
        isLoading = false;
        errorMessage = 'User not logged in';
        notifyListeners();
        return false;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/users/toggle-notifications/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'receive_notifications': value}),
      );

      isLoading = false;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        pushNotification = data['receive_notifications'] ?? value;

        // Save to local storage
        await prefs.setBool('receive_notifications', pushNotification);

        debugPrint('Notification preference updated: $pushNotification');
        notifyListeners();
        return true;
      } else {
        errorMessage =
            'Failed to update notification preference: ${response.statusCode}';
        debugPrint(errorMessage);
        debugPrint('Response: ${response.body}');
        notifyListeners();
        return false;
      }
    } catch (e) {
      isLoading = false;
      errorMessage = 'Error updating notification preference: $e';
      debugPrint(errorMessage);
      notifyListeners();
      return false;
    }
  }

  // Fetch current notification preference from backend
  Future<void> fetchNotificationPreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        debugPrint('No access token found. User not logged in.');
        return;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/users/notification-preferences/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        pushNotification = data['receive_notifications'] ?? true;

        // Save to local storage
        await prefs.setBool('receive_notifications', pushNotification);

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching notification preference: $e');
    }
  }
}
