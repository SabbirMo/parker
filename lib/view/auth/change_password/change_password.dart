import 'package:flutter/material.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/back_button.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'package:parker_touch/core/widget/custom_textfield.dart';
import 'package:parker_touch/view/auth/otp/verify_sccessful.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              CustomBackButton(),
              const Spacer(flex: 2),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    "New Password",
                    style: FontManager.titleStyle.copyWith(
                      color: AppColors.optBlue,
                    ),
                  ),
                  AppSpacing.h20,
                  CustomTextfield(
                    text: "Create new Password",
                    hintText: "Enter your new password",
                    icon: Icons.visibility_outlined,
                    obscureText: true,
                  ),
                  CustomTextfield(
                    text: "Re-Type Password",
                    hintText: "Confirm your new password",
                    icon: Icons.visibility_outlined,
                    obscureText: true,
                  ),
                  AppSpacing.h26,
                  CustomButton(
                    text: "Save",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const VerifySccessful(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
