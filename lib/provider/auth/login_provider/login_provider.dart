import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginProvider extends ChangeNotifier {
  bool _password = true;
  bool get password => _password;

  void togglePassword() {
    _password = !_password;
    notifyListeners();
  }

  //login user
  bool isloading = false;
  final baseUrl = 'https://k47k7scv-8000.inc1.devtunnels.ms';

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    try {
      isloading = true;
      notifyListeners();

      final response = await http.post(
        Uri.parse('$baseUrl/api/users/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String? accessToken = data['access'];
        final String? refreshToken = data['refresh'];

        debugPrint('Access Token: $accessToken');
        debugPrint('Refresh Token: $refreshToken');
        isloading = false;
        notifyListeners();
        return data;
      } else {
        isloading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      isloading = false;
      notifyListeners();
      debugPrint(e.toString());
      return null;
    }
  }
}
