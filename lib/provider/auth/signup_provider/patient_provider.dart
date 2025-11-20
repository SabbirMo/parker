import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PatientProvider extends ChangeNotifier {
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

  //signup patient
  bool isloading = false;
  final baseUrl = 'https://1kklrhx5-8000.inc1.devtunnels.ms';

  Future<String?> signupPatient(
    String name,
    String email,
    int age,
    String password,
    String confirmPassword,
  ) async {
    isloading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/users/register/patient/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "full_name": name,
          "email": email,
          "age": age,
          "password": password,
          "confirm_password": confirmPassword,
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

  //Verify OTP
  Future<String?> verifyOtp(String otp, String otpToken) async {
    isloading = true;
    notifyListeners();
    final uri = Uri.parse('$baseUrl/api/users/verify-otp/');
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': otpToken, 'otp': otp}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        isloading = false;
        notifyListeners();
        return data['detail'] ?? 'OTP verified successfully';
      } else {
        isloading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      isloading = false;
      notifyListeners();
      debugPrint('Error during OTP verification: $e');
      return null;
    }
  }

  // Resend OTP
  Future<String?> resendOtp(String otpToken) async {
    isloading = true;
    notifyListeners();
    final uri = Uri.parse('$baseUrl/api/users/resend-otp/');
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': otpToken}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        isloading = false;
        notifyListeners();
        return data['detail'] ?? 'OTP resent successfully';
      } else {
        isloading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      isloading = false;
      notifyListeners();
      debugPrint('Error during OTP resend: $e');
      return null;
    }
  }
}
