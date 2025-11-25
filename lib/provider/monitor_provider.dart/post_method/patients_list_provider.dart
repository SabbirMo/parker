import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:parker_touch/core/base_url/base_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PatientsListProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  List<MonitoredPatient> patients = [];

  Future<void> fetchPatientsList() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final response = await http.get(
        Uri.parse('$baseUrl/api/monitor/my-patients/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final list = data['monitors'] as List;

        patients = list.map((json) => MonitoredPatient.fromJson(json)).toList();

        notifyListeners();
      } else {
        errorMessage = 'Failed to fetch patients list';
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = 'Error: $e';
      notifyListeners();
    }
  }

  // Respond to patient request
  Future<bool> respondToRequest(int requestId, String action) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final response = await http.post(
        Uri.parse('$baseUrl/api/monitor/respond-request/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'request_id': requestId, 'action': action}),
      );

      debugPrint('Respond Status Code: ${response.statusCode}');
      debugPrint('Respond Response: ${response.body}');

      if (response.statusCode == 200) {
        // Remove the patient from the list if declined/rejected
        if (action == 'decline') {
          patients.removeWhere((patient) => patient.requestId == requestId);
          notifyListeners();
        } else if (action == 'accept') {
          // Update the status to accepted for the specific patient
          final index = patients.indexWhere(
            (patient) => patient.requestId == requestId,
          );
          if (index != -1) {
            patients[index] = MonitoredPatient(
              id: patients[index].id,
              fullName: patients[index].fullName,
              email: patients[index].email,
              status: 'accepted',
              isOutgoing: patients[index].isOutgoing,
              requestId: patients[index].requestId,
            );
            notifyListeners();
          }
        }
        return true;
      } else {
        errorMessage = 'Failed to respond to request';
        return false;
      }
    } catch (e) {
      errorMessage = 'An error occurred: $e';
      notifyListeners();
      return false;
    }
  }

  // Get all patients summary
  List<ConnectedPatient> connectedPatients = [];
  bool isSummaryLoading = false;
  String? summaryErrorMessage;

  Future<void> fetchAllPatientsSummary() async {
    try {
      isSummaryLoading = true;
      summaryErrorMessage = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final response = await http.get(
        Uri.parse('$baseUrl/api/monitor/all-patients-summary/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      debugPrint('All Patients Summary Status Code: ${response.statusCode}');
      debugPrint('All Patients Summary Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final list = data['connected_patients'] as List;

        connectedPatients = list
            .map((json) => ConnectedPatient.fromJson(json))
            .toList();

        notifyListeners();
      } else {
        summaryErrorMessage = 'Failed to fetch patients summary';
      }

      isSummaryLoading = false;
      notifyListeners();
    } catch (e) {
      isSummaryLoading = false;
      summaryErrorMessage = 'Error: $e';
      notifyListeners();
    }
  }
}

//All Patient

class MonitoredPatient {
  final int id;
  final String fullName;
  final String email;
  final String status;
  final bool isOutgoing;
  final int requestId;

  MonitoredPatient({
    required this.fullName,
    required this.status,
    required this.isOutgoing,
    required this.requestId,
    required this.email,
    required this.id,
  });

  factory MonitoredPatient.fromJson(Map<String, dynamic> json) {
    return MonitoredPatient(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      status: json['status'] ?? '',
      isOutgoing: json['is_outgoing'] ?? false,
      requestId: json['request_id'] ?? 0,
    );
  }
}

// Connected Patient Model for All Patients Summary
class ConnectedPatient {
  final int id;
  final String fullName;
  final String email;
  final int age;
  final String? profilePhoto;
  final TodayProgress todayProgress;

  ConnectedPatient({
    required this.id,
    required this.fullName,
    required this.email,
    required this.age,
    this.profilePhoto,
    required this.todayProgress,
  });

  factory ConnectedPatient.fromJson(Map<String, dynamic> json) {
    return ConnectedPatient(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      age: json['age'] ?? 0,
      profilePhoto: json['profile_photo'],
      todayProgress: TodayProgress.fromJson(json['today_progress'] ?? {}),
    );
  }
}

// Today Progress Model
class TodayProgress {
  final int taken;
  final int total;
  final int percentage;
  final bool hasMissedDose;
  final List<String> missedMedicines;
  final String? lastTakenTime;

  TodayProgress({
    required this.taken,
    required this.total,
    required this.percentage,
    required this.hasMissedDose,
    required this.missedMedicines,
    this.lastTakenTime,
  });

  factory TodayProgress.fromJson(Map<String, dynamic> json) {
    return TodayProgress(
      taken: json['taken'] ?? 0,
      total: json['total'] ?? 0,
      percentage: (json['percentage'] ?? 0).toInt(),
      hasMissedDose: json['has_missed_dose'] ?? false,
      missedMedicines: List<String>.from(json['missed_medicines'] ?? []),
      lastTakenTime: json['last_taken_time'],
    );
  }
}
