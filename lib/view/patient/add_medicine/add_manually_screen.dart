import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/back_button.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'package:parker_touch/core/widget/custom_dropdown.dart';
import 'package:parker_touch/core/widget/custom_textfield.dart';
import 'package:parker_touch/core/widget/snack_bar.dart';
import 'package:parker_touch/provider/auth/login_provider/login_provider.dart';
import 'package:parker_touch/provider/patient_provider/add_medicine_manually_provider.dart';
import 'package:parker_touch/provider/patient_provider/medicine_list_provider.dart';
import 'package:provider/provider.dart';

// UI Screen
class AddManuallyScreen extends StatefulWidget {
  const AddManuallyScreen({super.key});

  @override
  State<AddManuallyScreen> createState() => _AddManuallyScreenState();
}

class _AddManuallyScreenState extends State<AddManuallyScreen> {
  final medicineNameController = TextEditingController();
  final dosageController = TextEditingController();
  final totalDaysController = TextEditingController();
  final time1Controller = TextEditingController();
  String? selectedFrequency;

  // Backend-approved mapping
  final Map<String, String> frequencyMap = {
    "Once a day": "Once in a day",
    "Twice a day": "Twice in a day",
    "Three times a day": "Thrice in a day",
  };

  @override
  void dispose() {
    medicineNameController.dispose();
    dosageController.dispose();
    totalDaysController.dispose();
    time1Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addMedicineProvider = Provider.of<AddMedicineManuallyProvider>(
      context,
    );

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            CustomBackButton(),
            AppSpacing.h12,
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Add Medicine', style: FontManager.connect),
                    AppSpacing.h6,
                    Text(
                      'Add Medicine Manually',
                      style: FontManager.contTitle.copyWith(
                        fontSize: 18.sp,
                        color: Color(0xff303030),
                      ),
                    ),
                    AppSpacing.h12,
                    CustomTextfield(
                      controller: medicineNameController,
                      text: "Medicine Name",
                      hintText: 'e.g. Tylenol',
                      borderColor: AppColors.textFieldBorderColor,
                      bgColor: AppColors.textFieldBgColor,
                    ),
                    AppSpacing.h4,
                    CustomTextfield(
                      controller: dosageController,
                      text: "Dosage",
                      hintText: 'e.g. 500mg',
                      borderColor: AppColors.textFieldBorderColor,
                      bgColor: AppColors.textFieldBgColor,
                    ),
                    AppSpacing.h4,
                    CustomTextfield(
                      controller: totalDaysController,
                      text: "How many days",
                      hintText: 'e.g. 15 days',
                      borderColor: AppColors.textFieldBorderColor,
                      bgColor: AppColors.textFieldBgColor,
                    ),
                    AppSpacing.h4,
                    CustomDropdown(
                      text: "Frequency",
                      hintText: 'Select frequency',
                      items: frequencyMap.keys.toList(),
                      value: selectedFrequency,
                      onChanged: (value) {
                        setState(() {
                          selectedFrequency = value;
                        });
                      },
                      borderColor: AppColors.textFieldBorderColor,
                      bgColor: AppColors.textFieldBgColor,
                    ),
                    AppSpacing.h4,
                    CustomTextfield(
                      controller: time1Controller,
                      text: "Time 1",
                      hintText: '--/--/--',
                      borderColor: AppColors.textFieldBorderColor,
                      bgColor: AppColors.textFieldBgColor,
                    ),
                    AppSpacing.h24,
                    addMedicineProvider.isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          )
                        : CustomButton(
                            text: 'Save Medicine',
                            onTap: () async {
                              FocusScope.of(context).unfocus();

                              final name = medicineNameController.text.trim();
                              final dosage = dosageController.text.trim();
                              final totalDays = totalDaysController.text.trim();
                              final time1 = time1Controller.text.trim();

                              if (name.isEmpty ||
                                  dosage.isEmpty ||
                                  totalDays.isEmpty ||
                                  selectedFrequency == null ||
                                  time1.isEmpty) {
                                CustomSnackBar.showError(
                                  context,
                                  'Please fill all the fields',
                                );
                                return;
                              }

                              final backendFrequency =
                                  frequencyMap[selectedFrequency]!;

                              final success = await addMedicineProvider
                                  .addMedicineManually(
                                    name,
                                    dosage,
                                    totalDays,
                                    backendFrequency,
                                    time1,
                                  );

                              if (success) {
                                // Refresh the medicine list
                                final medicineListProvider =
                                    Provider.of<MedicineListProvider>(
                                      context,
                                      listen: false,
                                    );
                                final loginProvider =
                                    Provider.of<LoginProvider>(
                                      context,
                                      listen: false,
                                    );

                                if (loginProvider.accessToken != null) {
                                  await medicineListProvider.fetchMedicines(
                                    loginProvider.accessToken!,
                                  );
                                }

                                CustomSnackBar.showSuccess(
                                  context,
                                  'Medicine added successfully',
                                );

                                // Navigate back to medicines list
                                Navigator.pop(context);
                              } else {
                                // Show specific error message from API
                                final errorMsg =
                                    addMedicineProvider.errorMessage ??
                                    'Failed to add medicine';
                                CustomSnackBar.showError(context, errorMsg);
                              }
                            },
                          ),
                    AppSpacing.h24,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
