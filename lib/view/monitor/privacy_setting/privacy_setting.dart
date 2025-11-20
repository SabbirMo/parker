import 'package:flutter/material.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/back_button.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'package:parker_touch/core/widget/custom_textfield.dart';
import 'package:parker_touch/core/widget/snack_bar.dart';
import 'package:parker_touch/provider/auth/change_password/new_password_provider.dart';
import 'package:provider/provider.dart';

class PrivacySetting extends StatefulWidget {
  const PrivacySetting({super.key});

  @override
  State<PrivacySetting> createState() => _PrivacySettingState();
}

class _PrivacySettingState extends State<PrivacySetting> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NewPasswordProvider>(context);
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
                    Text('Change Password', style: FontManager.connect),

                    AppSpacing.h12,
                    CustomTextfield(
                      text: 'Current Password',
                      hintText: "******",
                      controller: oldPasswordController,
                      obscureText: provider.oldPassword,
                      borderColor: AppColors.textFieldBorderColor,
                      bgColor: AppColors.textFieldBgColor,
                      icon: provider.oldPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      onIconPressed: () {
                        provider.toggleOldPassword();
                      },
                    ),
                    AppSpacing.h10,
                    CustomTextfield(
                      text: 'New Password',
                      hintText: "",
                      controller: newPasswordController,
                      borderColor: AppColors.textFieldBorderColor,
                      bgColor: AppColors.textFieldBgColor,
                      icon: provider.newPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      onIconPressed: () {
                        provider.toggleNewPassword();
                      },
                      obscureText: provider.newPassword,
                    ),
                    AppSpacing.h10,
                    CustomTextfield(
                      text: 'Confirm New Password',
                      hintText: "",
                      controller: confirmPasswordController,
                      borderColor: AppColors.textFieldBorderColor,
                      bgColor: AppColors.textFieldBgColor,
                      icon: provider.confirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      onIconPressed: () {
                        provider.toggleConfirmPassword();
                      },
                      obscureText: provider.confirmPassword,
                    ),
                    AppSpacing.h40,
                    provider.isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          )
                        : CustomButton(
                            text: "Change Password",
                            onTap: () async {
                              final oldPassword = oldPasswordController.text
                                  .trim();
                              final newPassword = newPasswordController.text
                                  .trim();
                              final confirmPassword = confirmPasswordController
                                  .text
                                  .trim();

                              if (oldPassword.isEmpty ||
                                  newPassword.isEmpty ||
                                  confirmPassword.isEmpty) {
                                CustomSnackBar.showError(
                                  context,
                                  "Please fill in all fields",
                                );
                                return;
                              } else if (newPassword != confirmPassword) {
                                CustomSnackBar.showError(
                                  context,
                                  "New passwords do not match",
                                );
                                return;
                              }

                              bool result = await provider.currntPasswordChange(
                                oldPassword,
                                newPassword,
                                confirmPassword,
                              );

                              if (result) {
                                CustomSnackBar.showSuccess(
                                  context,
                                  "Password changed successfully",
                                );
                                Navigator.pop(context);
                              } else {
                                CustomSnackBar.showError(
                                  context,
                                  "Password change failed",
                                );
                              }
                            },
                          ),
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
