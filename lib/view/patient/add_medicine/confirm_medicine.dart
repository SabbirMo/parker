import 'package:flutter/material.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/back_button.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'package:parker_touch/view/monitor/connect_potient/medicine_potient.dart';

class ConfirmMedicine extends StatelessWidget {
  const ConfirmMedicine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomBackButton(),
              AppSpacing.h14,
              Text('Confirm Medicine', style: FontManager.connect),
              AppSpacing.h24,
              const MedicineCart(
                num: '1.',
                medicineName: ' Paracetamol',
                mg: '500mg',
                time: '3 times',
                days: '5 days',
                color: AppColors.white,
                index: 2,
              ),
              AppSpacing.h14,
              const MedicineCart(
                num: '2.',
                medicineName: ' Omeprazole',
                mg: '500mg',
                time: '3 times',
                days: '5 days',
                color: AppColors.white,
                index: 3,
              ),
              AppSpacing.h14,
              const MedicineCart(
                num: '3.',
                medicineName: ' Cetirizine',
                mg: '500mg',
                time: '3 times',
                days: '5 days',
                color: AppColors.white,
                index: 1,
              ),
              AppSpacing.h14,
              const MedicineCart(
                num: '4.',
                medicineName: ' Amoxicillin',
                mg: '500mg',
                time: '3 times',
                days: '5 days',
                color: AppColors.white,
                index: 3,
              ),
              Spacer(),
              CustomButton(text: 'Save Medicine', onTap: () {}),
              AppSpacing.h38,
            ],
          ),
        ),
      ),
    );
  }
}
