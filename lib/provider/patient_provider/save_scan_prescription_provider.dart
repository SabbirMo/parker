import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/base_url/base_url.dart';

class MedicineData {
  final String name;
  final String dosage;
  final String frequency;
  final List<String> times;
  final String whenToTake;
  final String durationDays;

  MedicineData({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.times,
    required this.whenToTake,
    required this.durationDays,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'times': times,
      'when_to_take': whenToTake,
      'duration_days': durationDays,
    };
  }
}

class SavedMedicine {
  final int id;
  final String name;
  final String dosage;
  final String frequency;
  final List<String> times;
  final int totalDays;
  final String createdAt;
  final bool isActive;

  SavedMedicine({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.times,
    required this.totalDays,
    required this.createdAt,
    required this.isActive,
  });

  factory SavedMedicine.fromJson(Map<String, dynamic> json) {
    return SavedMedicine(
      id: json['id'],
      name: json['name'],
      dosage: json['dosage'],
      frequency: json['frequency'],
      times: List<String>.from(json['times']),
      totalDays: json['total_days'],
      createdAt: json['created_at'],
      isActive: json['is_active'],
    );
  }
}

class SaveScanPrescriptionProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  String? successMessage;
  List<SavedMedicine> savedMedicines = [];

  Future<bool> saveScanPrescription(List<MedicineData> medicines) async {
    try {
      isLoading = true;
      errorMessage = null;
      successMessage = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final response = await http.post(
        Uri.parse('$baseUrl/api/medicine/save-scanned/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'medicines': medicines.map((m) => m.toJson()).toList(),
        }),
      );

      isLoading = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        successMessage = data['detail'];

        savedMedicines = (data['medicines'] as List)
            .map((m) => SavedMedicine.fromJson(m))
            .toList();

        notifyListeners();
        return true;
      } else {
        final data = jsonDecode(response.body);
        errorMessage = data['detail'] ?? 'Failed to save medicines';
        notifyListeners();
        return false;
      }
    } catch (e) {
      isLoading = false;
      errorMessage = 'An error occurred while saving the prescription.';
      notifyListeners();
      return false;
    }
  }
}
