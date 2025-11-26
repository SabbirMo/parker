import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:parker_touch/core/base_url/base_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FcmTokenService {
  /// Send FCM token to backend after login/signup
  /// Backend should save this token with user ID
  static Future<bool> sendTokenToBackend(String fcmToken) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        debugPrint('No access token found. User not logged in.');
        return false;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/users/fcm-token/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'fcm_token': fcmToken,
          'device_type': 'android', // or 'ios' based on platform
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('FCM token sent to backend successfully');
        await prefs.setString('fcm_token', fcmToken);
        return true;
      } else {
        debugPrint('Failed to send FCM token: ${response.statusCode}');
        debugPrint('Response: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Error sending FCM token to backend: $e');
      return false;
    }
  }

  /// Update FCM token when it refreshes
  static Future<bool> updateTokenOnBackend(String newToken) async {
    return await sendTokenToBackend(newToken);
  }

  /// Delete FCM token from backend on logout
  static Future<bool> deleteTokenFromBackend() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      final fcmToken = prefs.getString('fcm_token');

      if (accessToken == null || fcmToken == null) {
        debugPrint('No tokens found');
        return false;
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/api/users/fcm-token/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'fcm_token': fcmToken}),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        debugPrint('FCM token deleted from backend successfully');
        await prefs.remove('fcm_token');
        return true;
      } else {
        debugPrint('Failed to delete FCM token: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('Error deleting FCM token from backend: $e');
      return false;
    }
  }
}
