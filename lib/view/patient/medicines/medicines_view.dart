import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/header_section.dart';
import 'package:parker_touch/view/monitor/connect_potient/medicine_potient.dart';
import 'package:parker_touch/view/patient/add_medicine/add_manually_screen.dart';

class MedicinesView extends StatelessWidget {
  const MedicinesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderSection(
            title: "Good Morning",
            subtitle: "Mr. Parker",
            text: "Stay on track with your medications",
            image: "assets/images/man.png",
          ),
          AppSpacing.h14,
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("My Medicine", style: FontManager.connect),

                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AddManuallyScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: AppColors.optBlue,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.add,
                                color: AppColors.white,
                                size: 24.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    AppSpacing.h14,
                    const MedicineCart(
                      num: '1.',
                      medicineName: ' Paracetamol',
                      mg: '500mg',
                      time: '3 times',
                      days: '5 days',
                      index: 2,
                    ),
                    AppSpacing.h14,
                    const MedicineCart(
                      num: '2.',
                      medicineName: ' Omeprazole',
                      mg: '500mg',
                      time: '3 times',
                      days: '5 days',
                      index: 3,
                    ),
                    AppSpacing.h14,
                    const MedicineCart(
                      num: '3.',
                      medicineName: ' Cetirizine',
                      mg: '500mg',
                      time: '3 times',
                      days: '5 days',
                      color: AppColors.redOpa,
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
