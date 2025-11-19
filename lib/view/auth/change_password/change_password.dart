import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/back_button.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'package:parker_touch/core/widget/custom_textfield.dart';
import 'package:parker_touch/provider/auth/change_password/change_password_provider.dart';
import 'package:parker_touch/view/auth/otp/verify_sccessful.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  final String? token;
  const ChangePassword({super.key, this.token});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final changePasswordProvider = Provider.of<ChangePasswordProvider>(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
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
                  controller: newPasswordController,
                  text: "Create new Password",
                  hintText: "Enter your new password",
                  icon: changePasswordProvider.newPasswordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  onIconPressed: () {
                    changePasswordProvider.toggleNewPasswordVisibility();
                  },
                  obscureText: changePasswordProvider.newPasswordVisible,
                ),
                AppSpacing.h10,
                CustomTextfield(
                  controller: confirmPasswordController,
                  text: "Re-Type Password",
                  hintText: "Confirm your new password",
                  icon: changePasswordProvider.confirmPasswordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  onIconPressed: () {
                    changePasswordProvider.toggleConfirmPasswordVisibility();
                  },
                  obscureText: changePasswordProvider.confirmPasswordVisible,
                ),
                AppSpacing.h26,
                changePasswordProvider.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      )
                    : CustomButton(
                        text: "Save",
                        onTap: () async {
                          final newPassword = newPasswordController.text.trim();
                          final confirmPassword = confirmPasswordController.text
                              .trim();

                          if (newPassword.isEmpty || confirmPassword.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill in all fields!'),
                              ),
                            );
                            return;
                          }

                          if (newPassword != confirmPassword) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Passwords do not match!'),
                              ),
                            );
                            return;
                          }

                          final result = await changePasswordProvider
                              .changePassword(
                                widget.token!,
                                newPassword,
                                confirmPassword,
                              );

                          if (result) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const VerifySccessful(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Failed to change password. Try again.',
                                ),
                              ),
                            );
                          }
                        },
                      ),
              ],
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}
