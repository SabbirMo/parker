import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NewPasswordProvider extends ChangeNotifier {
  bool oldPassword = true;
  bool newPassword = true;
  bool confirmPassword = true;

  void toggleOldPassword() {
    oldPassword = !oldPassword;
    notifyListeners();
  }

  void toggleNewPassword() {
    newPassword = !newPassword;
    notifyListeners();
  }

  void toggleConfirmPassword() {
    confirmPassword = !confirmPassword;
    notifyListeners();
  }

  // You can add more logic related to password change here
  bool isLoading = false;
  final String baseUrl = 'https://1kklrhx5-8000.inc1.devtunnels.ms';

  Future<bool> currntPasswordChange(
    String oldPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    try {
      isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("accessToken") ?? "";

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.post(
        Uri.parse('$baseUrl/api/users/change-password/'),
        headers: headers,
        body: jsonEncode({
          'current_password': oldPassword,
          'new_password': newPassword,
          'confirm_password': confirmPassword,
        }),
      );

      isLoading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint(data.toString());
        return true;
      } else {
        return false;
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
