import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:parker_touch/core/base_url/base_url.dart';
import 'package:parker_touch/provider/auth/upload_prescription/save_scan_prescription_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UploadPrescriptionProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  List<MedicineData>? scannedMedicines;

  //final String baseUrl = 'https://1kklrhx5-8000.inc1.devtunnels.ms';

  Future<bool> uploadPrescription(File imageFile) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null || token.isEmpty) {
        debugPrint('No access token found');
        errorMessage = 'No access token found';
        isLoading = false;
        notifyListeners();
        return false;
      }

      debugPrint(
        'Uploading prescription to: $baseUrl/api/medicine/upload-scan/',
      );
      debugPrint('Token: ${token.substring(0, 20)}...');
      debugPrint('Image path: ${imageFile.path}');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/medicine/upload-scan/'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      debugPrint('Sending request...');
      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      debugPrint("Upload Status Code: ${response.statusCode}");
      debugPrint("Upload Response: ${responseData.body}");

      isLoading = false;
      notifyListeners();

      if (response.statusCode == 200 || response.statusCode == 201) {
        errorMessage = null;

        // Parse scanned medicine data
        try {
          final responseJson = jsonDecode(responseData.body);
          debugPrint("Response JSON: $responseJson");

          if (responseJson is Map<String, dynamic> &&
              responseJson.containsKey('medicines')) {
            final medicinesJson = responseJson['medicines'] as List;
            debugPrint("Medicines JSON: $medicinesJson");

            scannedMedicines = medicinesJson.map((medicine) {
              return MedicineData(
                name: medicine['name'] ?? '',
                dosage: medicine['dosage'] ?? '',
                frequency: medicine['frequency'] ?? '',
                times: List<String>.from(medicine['times'] ?? []),
                whenToTake: medicine['when_to_take'] ?? 'Not mentioned',
                durationDays: medicine['duration_days']?.toString() ?? '0',
              );
            }).toList();
            debugPrint("Scanned ${scannedMedicines?.length} medicines");
            notifyListeners();
          } else {
            debugPrint("Response does not contain 'medicines' key");
            scannedMedicines = null;
          }
        } catch (e) {
          debugPrint("Error parsing scanned medicines: $e");
          scannedMedicines = null;
        }

        return true;
      } else {
        // Parse error message from API
        try {
          final errorData = jsonDecode(responseData.body);
          if (errorData is Map<String, dynamic>) {
            if (errorData.containsKey('error')) {
              errorMessage = errorData['error'];
            } else if (errorData.containsKey('image')) {
              final imageError = errorData['image'];
              if (imageError is List && imageError.isNotEmpty) {
                errorMessage = imageError[0];
              } else {
                errorMessage = imageError.toString();
              }
            } else {
              errorMessage = 'Upload failed: ${response.statusCode}';
            }
          }
        } catch (e) {
          errorMessage = 'Upload failed: ${response.statusCode}';
        }
        return false;
      }
    } catch (e) {
      debugPrint("Upload error: $e");
      errorMessage = 'Network error: $e';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
