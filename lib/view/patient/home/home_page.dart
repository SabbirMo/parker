// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'package:parker_touch/core/widget/free_trial_container.dart';
import 'package:parker_touch/core/widget/header_section.dart';
import 'package:parker_touch/core/widget/medicine_container.dart';
import 'package:parker_touch/core/widget/progress_bar_widget.dart';
import 'package:parker_touch/core/widget/show_dialog_widget.dart';
import 'package:parker_touch/view/patient/add_medicine/add_manually_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _progressCount = 0;
  final int _maxProgress = 4;

  void _incrementProgress() {
    setState(() {
      if (_progressCount < _maxProgress) {
        _progressCount++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Fixed header section
        HeaderSection(
          title: "Good Morning",
          subtitle: "Mr. Parker",
          text: "Stay on track with your medications",
          image: "assets/images/man.png",
        ),
        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppSpacing.h10,
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    children: [
                      const FreeTrialContainer(),
                      AppSpacing.h16,
                      MedicineContainer(onTakeMedicine: _incrementProgress),

                      AppSpacing.h16,
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            width: 1,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Today's Summary",
                              style: FontManager.contTitle,
                            ),
                            ProgressBarWidget(
                              completed: _progressCount,
                              total: _maxProgress,
                            ),
                          ],
                        ),
                      ),

                      AppSpacing.h16,

                      CustomButton(
                        text: "ADD MEDICINE",
                        textColor: AppColors.login,
                        bgColor: Color(0xffedf5fe),
                        border: Border.all(width: 1, color: AppColors.login),
                        rightIcon: Icons.add,
                        iconColor: AppColors.login,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddManuallyScreen(),
                            ),
                          );
                        },
                      ),
                      AppSpacing.h16,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
