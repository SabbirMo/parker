import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:parker_touch/core/base_url/base_url.dart';
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
  String? errorMessage;
  String? accessToken;
  String? refreshToken;
  String? role;
  String? email;
  String? fullName;
  String? profilePicture;

  //final String baseUrl = 'https://1kklrhx5-8000.inc1.devtunnels.ms';

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
        this.email = data['user']['email'];
        fullName = data['user']['full_name'];
        profilePicture = data['user']['profile_picture'];

        // Save tokens in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', accessToken!);
        await prefs.setString('refreshToken', refreshToken!);
        await prefs.setString('role', role!);
        await prefs.setString('email', this.email!);
        await prefs.setString('fullName', fullName!);
        if (profilePicture != null) {
          await prefs.setString('profilePicture', profilePicture!);
        }

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
    email = prefs.getString("email");
    fullName = prefs.getString("fullName");
    profilePicture = prefs.getString("profilePicture");
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

  /// -------------------- Edit Profile --------------------
  Future<bool> editProfile(String fullName, int age) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final headers = await getAuthHeaders();

      debugPrint('Editing profile: fullName=$fullName, age=$age');
      debugPrint('Headers: $headers');

      final response = await http.put(
        Uri.parse('$baseUrl/api/users/edit-profile/'),
        headers: headers,
        body: jsonEncode({'full_name': fullName, 'age': age}),
      );

      isLoading = false;
      notifyListeners();

      debugPrint('Edit profile response: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        this.fullName = fullName;

        // Update stored full name
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('fullName', fullName);

        notifyListeners();
        return true;
      } else {
        // Parse error message from response
        try {
          final errorData = jsonDecode(response.body);
          errorMessage = errorData['detail'] ?? errorData.toString();
        } catch (e) {
          errorMessage = 'Profile update failed';
        }
        debugPrint('Profile update failed: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Error updating profile: $e');
      isLoading = false;
      errorMessage = 'An error occurred: $e';
      notifyListeners();
      return false;
    }
  }

  //-----------------upload profile picture-----------------
  Future<bool> uploadProfilePicture(File imageFile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("accessToken") ?? "";

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/users/upload-picture/'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      debugPrint("Upload Response: ${responseData.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(responseData.body);
        if (data['profile_picture'] != null) {
          profilePicture = data['profile_picture'];
          await prefs.setString('profilePicture', profilePicture!);
          notifyListeners();
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('Upload Error: $e');
      return false;
    }
  }

  // -------------------- FETCH USER PROFILE --------------------
  Future<void> fetchUserProfile() async {
    try {
      final headers = await getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/users/profile/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        fullName = data['full_name'];
        email = data['email'];
        role = data['role'];
        profilePicture = data['profile_picture'];

        // Update stored values
        final prefs = await SharedPreferences.getInstance();
        if (fullName != null) await prefs.setString('fullName', fullName!);
        if (email != null) await prefs.setString('email', email!);
        if (role != null) await prefs.setString('role', role!);
        if (profilePicture != null) {
          await prefs.setString('profilePicture', profilePicture!);
        }

        notifyListeners();
      } else {
        debugPrint('Failed to fetch user profile: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
    }
  }

  // -------------------- LOGOUT --------------------
  Future<void> logout() async {
    accessToken = null;
    refreshToken = null;
    role = null;
    email = null;
    fullName = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all stored tokens & role
  }
}
