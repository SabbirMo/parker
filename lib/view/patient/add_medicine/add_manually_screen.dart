import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/back_button.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'package:parker_touch/core/widget/custom_dropdown.dart';
import 'package:parker_touch/core/widget/custom_textfield.dart';

class AddManuallyScreen extends StatelessWidget {
  const AddManuallyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomBackButton(),
              AppSpacing.h12,
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
                text: "Medicine Name",
                hintText: 'e.g. Tylenol',
                borderColor: AppColors.textFieldBorderColor,
                bgColor: AppColors.textFieldBgColor,
              ),
              AppSpacing.h4,
              CustomTextfield(
                text: "Dosage",
                hintText: 'e.g. 500mg',
                borderColor: AppColors.textFieldBorderColor,
                bgColor: AppColors.textFieldBgColor,
              ),
              AppSpacing.h4,
              CustomTextfield(
                text: "How many days",
                hintText: 'e.g. 15 days',
                borderColor: AppColors.textFieldBorderColor,
                bgColor: AppColors.textFieldBgColor,
              ),
              AppSpacing.h4,
              CustomDropdown(
                text: "Frequency",
                hintText: 'Select frequency',
                items: ['Once a day', 'Twice a day', 'Three times a day'],
                borderColor: AppColors.textFieldBorderColor,
                bgColor: AppColors.textFieldBgColor,
              ),
              AppSpacing.h4,
              CustomTextfield(
                text: "Time 1",
                hintText: '--/--/--',
                borderColor: AppColors.textFieldBorderColor,
                bgColor: AppColors.textFieldBgColor,
              ),
              Spacer(),

              CustomButton(text: 'Save Medicine', onTap: () {}),
              AppSpacing.h24,
            ],
          ),
        ),
      ),
    );
  }
}
