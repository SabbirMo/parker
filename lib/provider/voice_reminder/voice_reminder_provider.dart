import 'package:flutter/material.dart';

class VoiceReminderProvider extends ChangeNotifier {
  bool voiceReminder = true;

  void toggleVoiceReminder(bool value) {
    voiceReminder = value;
    notifyListeners();
  }
}
