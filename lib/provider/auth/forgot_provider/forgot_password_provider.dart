import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPasswordProvider extends ChangeNotifier {
  bool isLoading = false;
  final String baseUrl = 'https://k47k7scv-8000.inc1.devtunnels.ms';

  Future<String?> sendResetLink(String email) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await http.post(
        Uri.parse('$baseUrl/api/users/forgot-password/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String? token = data['otp_token'];
        isLoading = false;
        notifyListeners();
        return token;
      } else {
        isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint(e.toString());
      return null;
    }
  }

  //reset password
  Future<String?> verifyResetOtp(String toke, String otp) async {
    isLoading = true;
    notifyListeners();

    try {
      debugPrint('Verifying OTP - Token: $toke, OTP: $otp');
      final response = await http.post(
        Uri.parse('$baseUrl/api/users/forgot-password/verify/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'otp_token': toke, 'otp': otp}),
      );
      debugPrint('Verify OTP Response status: ${response.statusCode}');
      debugPrint('Verify OTP Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        isLoading = false;
        notifyListeners();
        debugPrint('OTP verified successfully');
        return data['detail'] ?? 'OTP verified successfully';
      } else {
        debugPrint(
          'OTP verification failed with status: ${response.statusCode}',
        );
        isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint('Exception in verifyResetOtp: $e');
      return null;
    }
  }

  //forgot password resend otp
  Future<String?> forgotPassResendOtp(String otpToken, String email) async {
    isLoading = true;
    notifyListeners();
    final uri = Uri.parse('$baseUrl/api/users/forgot-password/resend/');
    debugPrint(
      'Resending forgot password OTP - Token: $otpToken, Email: $email',
    );
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': otpToken, 'email': email}),
      );
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        isLoading = false;
        notifyListeners();
        // Check if new token is provided in response
        if (data.containsKey('otp_token')) {
          debugPrint('New OTP token received: ${data['otp_token']}');
          return data['otp_token'];
        }
        return data['detail'] ?? 'OTP resent successfully';
      } else {
        isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint('Error during OTP resend: $e');
      return null;
    }
  }
}
