import 'package:flutter/material.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/back_button.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'package:parker_touch/core/widget/custom_textfield.dart';

class PrivacySetting extends StatelessWidget {
  const PrivacySetting({super.key});

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
              Text('Change Password', style: FontManager.connect),

              AppSpacing.h12,
              CustomTextfield(
                text: 'Current Password',
                hintText: "******",
                obscureText: true,
                borderColor: AppColors.textFieldBorderColor,
                bgColor: AppColors.textFieldBgColor,
              ),
              AppSpacing.h10,
              CustomTextfield(
                text: 'New Password',
                hintText: "",
                borderColor: AppColors.textFieldBorderColor,
                bgColor: AppColors.textFieldBgColor,
              ),
              AppSpacing.h10,
              CustomTextfield(
                text: 'Confirm New Password',
                hintText: "",
                borderColor: AppColors.textFieldBorderColor,
                bgColor: AppColors.textFieldBgColor,
              ),
              AppSpacing.h40,
              CustomButton(text: "Change Password", onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
