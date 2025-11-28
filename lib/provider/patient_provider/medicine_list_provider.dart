import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:parker_touch/core/base_url/base_url.dart';
import 'package:parker_touch/view/patient/home/model/patient_home_model.dart';
import 'package:parker_touch/view/patient/medicines/model/medicine_list_model.dart';
import 'package:http/http.dart' as http;

class MedicineListProvider extends ChangeNotifier {
  bool isLoading = false;
  List<MedicineListModel> medicines = [];
  String? errorMessage;

  //final String baseUrl = 'https://1kklrhx5-8000.inc1.devtunnels.ms';

  Future<void> fetchMedicines(String accessToken) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      debugPrint('Fetching medicines from: $baseUrl/api/medicine/list/');
      debugPrint('Access Token: ${accessToken.substring(0, 20)}...');

      final response = await http.get(
        Uri.parse('$baseUrl/api/medicine/list/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      debugPrint('Response Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Check if response is HTML (error page)
        if (response.body.trim().startsWith('<!DOCTYPE') ||
            response.body.trim().startsWith('<html')) {
          debugPrint('ERROR: Received HTML response instead of JSON');
          debugPrint('API endpoint may not exist or returned error page');
          errorMessage = 'API endpoint error';
          medicines = [];
          isLoading = false;
          notifyListeners();
          return;
        }

        final data = jsonDecode(response.body);
        debugPrint('Decoded data: $data');

        if (data is List) {
          // If the response is directly a list
          medicines = List<MedicineListModel>.from(
            data.map((x) => MedicineListModel.fromJson(x)),
          );
        } else if (data is Map && data.containsKey('medicines')) {
          // If the response has a 'medicines' key
          medicines = List<MedicineListModel>.from(
            data['medicines'].map((x) => MedicineListModel.fromJson(x)),
          );
        } else if (data is Map && data.containsKey('data')) {
          // If the response has a 'data' key
          medicines = List<MedicineListModel>.from(
            data['data'].map((x) => MedicineListModel.fromJson(x)),
          );
        } else {
          debugPrint('Unknown response structure: $data');
          errorMessage = 'Unknown response structure';
          medicines = [];
        }

        debugPrint('Parsed ${medicines.length} medicines');
      } else {
        debugPrint('Failed to load medicines: ${response.statusCode}');
        debugPrint('Error body: ${response.body}');
        errorMessage = 'Failed to load: ${response.statusCode}';
        medicines = [];
      }
      isLoading = false;
      notifyListeners();
    } catch (e, stackTrace) {
      isLoading = false;
      errorMessage = 'Error: $e';
      medicines = [];
      debugPrint('Error fetching medicines: $e');
      debugPrint('Stack trace: $stackTrace');
      notifyListeners();
    }
  }

  //Home page next medicine
  NextMedicine? nextMedicine;
  Future<void> getNextMedicine(String accessToken) async {
    try {
      isLoading = true;
      errorMessage = null; // Reset error message
      notifyListeners();

      debugPrint(
        'Fetching next medicine from: $baseUrl/api/medicine/home-summary/',
      );
      debugPrint('Access Token: ${accessToken.substring(0, 20)}...');

      final response = await http.get(
        Uri.parse('$baseUrl/api/medicine/home-summary/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      debugPrint('Response Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      isLoading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        // Check if response is HTML (error page)
        if (response.body.trim().startsWith('<!DOCTYPE') ||
            response.body.trim().startsWith('<html')) {
          debugPrint('ERROR: Received HTML response instead of JSON');
          debugPrint('API endpoint may not exist or returned error page');
          errorMessage = 'API endpoint error';
          nextMedicine = null;
          notifyListeners();
          return;
        }

        final data = jsonDecode(response.body);
        debugPrint('Decoded data: $data');

        // Handle both direct object and nested response
        if (data is Map<String, dynamic>) {
          // Check if data has a 'next_medicine' key or is the medicine object itself
          final medicineData = data.containsKey('next_medicine')
              ? data['next_medicine']
              : data;

          if (medicineData != null) {
            nextMedicine = NextMedicine.fromJson(medicineData);
            debugPrint(
              'Next Medicine: ${nextMedicine?.name} - ${nextMedicine?.dosage} at ${nextMedicine?.time}',
            );
          } else {
            debugPrint('No next medicine data found');
            nextMedicine = null;
          }
        }
        notifyListeners();
      } else {
        debugPrint('Error Status: ${response.statusCode}');
        debugPrint('Error body: ${response.body}');
        nextMedicine = null;
        notifyListeners();
      }
    } catch (e, stackTrace) {
      isLoading = false;
      debugPrint('Error fetching next medicine: $e');
      debugPrint('Stack trace: $stackTrace');
      nextMedicine = null;
      notifyListeners();
    }
  }
}
