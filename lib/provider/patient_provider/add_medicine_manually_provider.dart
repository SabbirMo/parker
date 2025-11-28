import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:parker_touch/core/base_url/base_url.dart';
import 'package:parker_touch/core/time/alarm/alarm_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMedicineManuallyProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  Future<bool> addMedicineManually(
    String name,
    String dosage,
    String totalDays,
    String frequency,
    String time1,
  ) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) {
        debugPrint('No access token found');
        errorMessage = 'No access token found';
        isLoading = false;
        notifyListeners();
        return false;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/medicine/add-manual/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'dosage': dosage,
          'total_days': totalDays,
          'frequency': frequency,
          'times': [time1],
        }),
      );

      isLoading = false;
      notifyListeners();

      if (response.statusCode == 200 || response.statusCode == 201) {
        await scheduleMedicineAlarm(time1, name);
        return true;
      } else {
        debugPrint("Medicine add failed: ${response.body}");

        try {
          final errorData = jsonDecode(response.body);
          final firstKey = errorData.keys.first;
          final firstError = errorData[firstKey];

          if (firstError is List && firstError.isNotEmpty) {
            errorMessage = firstError[0].toString();
          } else if (firstError is String) {
            errorMessage = firstError;
          } else {
            errorMessage = 'Failed to add medicine';
          }
        } catch (e) {
          errorMessage = 'Failed to add medicine';
        }
        return false;
      }
    } catch (e) {
      isLoading = false;
      errorMessage = 'Network error: ${e.toString()}';
      notifyListeners();
      debugPrint("Error adding medicine: $e");
      return false;
    }
  }

  Future<void> scheduleMedicineAlarm(String time, String medicineName) async {
    try {
      debugPrint("Scheduling alarm for time: $time, medicine: $medicineName");

      // Try multiple time formats
      DateTime parsedTime;
      try {
        parsedTime = DateFormat("hh:mm a").parse(time);
      } catch (e) {
        try {
          parsedTime = DateFormat("h:mm a").parse(time);
        } catch (e2) {
          parsedTime = DateFormat("HH:mm").parse(time);
        }
      }

      final now = DateTime.now();
      DateTime alarmTime = DateTime(
        now.year,
        now.month,
        now.day,
        parsedTime.hour,
        parsedTime.minute,
        0,
        0,
      );

      // If the alarm time is in the past, schedule for tomorrow
      if (alarmTime.isBefore(now)) {
        alarmTime = alarmTime.add(const Duration(days: 1));
        debugPrint("Time is in past, scheduling for tomorrow: $alarmTime");
      }

      final alarmId = parsedTime.hour * 100 + parsedTime.minute;
      debugPrint("Alarm ID: $alarmId, Time: $alarmTime");

      await AlarmService.scheduleAlarm(
        id: alarmId,
        time: alarmTime,
        medicineName: medicineName,
      );

      debugPrint(
        "✅ Alarm scheduled successfully at $alarmTime for $medicineName",
      );
    } catch (e) {
      debugPrint("❌ Alarm scheduling error: $e");
    }
  }
}
