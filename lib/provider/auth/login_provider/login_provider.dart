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
  String? accessToken;
  String? refreshToken;
  String? role;
  final baseUrl = 'https://k47k7scv-8000.inc1.devtunnels.ms';

  Future<bool> loginUser(String email, String password) async {
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
        accessToken = data['access'];
        refreshToken = data['refresh'];

        role = data['user']['role'];

        isloading = false;
        notifyListeners();
        return true;
      } else {
        isloading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      isloading = false;
      notifyListeners();
      debugPrint(e.toString());
      return false;
    }
  }

  //logout user
  void logout() {
    accessToken = null;
    refreshToken = null;
    role = null;
    notifyListeners();
  }
}
