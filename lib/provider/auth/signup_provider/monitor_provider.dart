import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MonitorProvider extends ChangeNotifier {
  bool _password = true;
  bool get password => _password;

  bool _confirmPassword = true;
  bool get confirmPassword => _confirmPassword;

  void togglePassword() {
    _password = !_password;
    notifyListeners();
  }

  void toggleConfirmPassword() {
    _confirmPassword = !_confirmPassword;
    notifyListeners();
  }

  //signup monitor
  bool isloading = false;
  final baseUrl = 'https://1kklrhx5-8000.inc1.devtunnels.ms';

  Future<String?> signupMonitor(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    try {
      isloading = true;
      notifyListeners();

      final response = await http.post(
        Uri.parse('$baseUrl//api/users/register/monitor/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'full_name': name,
          'email': email,
          'password': password,
          'confirm_password': confirmPassword,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final String? token = data['otp_token'];
        isloading = false;
        notifyListeners();
        return token;
      } else {
        isloading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      isloading = false;
      notifyListeners();
      debugPrint('Error during signup: $e');
      return null;
    }
  }
}
