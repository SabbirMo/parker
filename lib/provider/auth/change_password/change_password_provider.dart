import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChangePasswordProvider extends ChangeNotifier {
  bool newPasswordVisible = true;
  bool confirmPasswordVisible = true;

  void toggleNewPasswordVisibility() {
    newPasswordVisible = !newPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    confirmPasswordVisible = !confirmPasswordVisible;
    notifyListeners();
  }

  bool isLoading = false;
  final String baseUrl = 'https://k47k7scv-8000.inc1.devtunnels.ms';

  Future<bool> changePassword(
    String token,
    String newPassword,
    String confirmPassword,
  ) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await http.post(
        Uri.parse('$baseUrl/api/users/forgot-password/reset/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'otp_token': token,
          'new_password': newPassword,
          'confirm_password': confirmPassword,
        }),
      );

      if (response.statusCode == 200) {
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint(e.toString());
      return false;
    }
  }
}
