import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginProvider extends ChangeNotifier {
  // Password toggle for UI
  bool _password = true;
  bool get password => _password;
  void togglePassword() {
    _password = !_password;
    notifyListeners();
  }

  // Login state
  bool isLoading = false;
  String? accessToken;
  String? refreshToken;
  String? role;

  final String baseUrl = 'https://k47k7scv-8000.inc1.devtunnels.ms';

  // -------------------- LOGIN --------------------
  Future<bool> loginUser(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await http.post(
        Uri.parse('$baseUrl/api/users/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      isLoading = false;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        accessToken = data['access'];
        refreshToken = data['refresh'];
        role = data['user']['role'];

        // Save tokens in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', accessToken!);
        await prefs.setString('refreshToken', refreshToken!);
        await prefs.setString('role', role!);

        notifyListeners();
        return true;
      } else {
        debugPrint('Login failed: ${response.body}');
        notifyListeners();
        return false;
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint('Error in login: $e');
      return false;
    }
  }

  // -------------------- INITIALIZE --------------------
  /// Call this on app start to load stored tokens
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString("accessToken");
    refreshToken = prefs.getString("refreshToken");
    role = prefs.getString("role");
    notifyListeners();
  }

  // -------------------- AUTH HEADERS --------------------
  /// Use this for API calls
  Future<Map<String, String>> getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("accessToken") ?? "";
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // -------------------- LOGOUT --------------------
  Future<void> logout() async {
    accessToken = null;
    refreshToken = null;
    role = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all stored tokens & role
  }
}
