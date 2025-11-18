import 'package:flutter/material.dart';

class ForgotPasswordProvider extends ChangeNotifier {
  bool _password = true;
  bool get password => _password;

  void togglePassword() {
    _password = !_password;
    notifyListeners();
  }
}
