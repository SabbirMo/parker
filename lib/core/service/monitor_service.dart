import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/patient_medicines/patient_medicines_response.dart';

class MonitorService {
  final String baseUrl;
  MonitorService({required this.baseUrl});

  Future<PatientMedicinesResponse> fetchPatientMedicines(int patientId) async {
    final url = Uri.parse('$baseUrl/api/monitor/patient-medicines/$patientId/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return PatientMedicinesResponse.fromJson(data);
    } else {
      throw Exception('Failed to load patient medicines');
    }
  }
}
