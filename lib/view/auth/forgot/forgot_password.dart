import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/app_string.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/back_button.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'package:parker_touch/core/widget/custom_textfield.dart';
import 'package:parker_touch/core/widget/snack_bar.dart';
import 'package:parker_touch/provider/auth/forgot_provider/forgot_password_provider.dart';
import 'package:parker_touch/view/auth/login/login_view.dart';
import 'package:parker_touch/view/auth/otp/otp_verification.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final forgotPasswordProvider = Provider.of<ForgotPasswordProvider>(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomBackButton(),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Reset Password",
                    style: FontManager.loginStyle.copyWith(
                      fontSize: 20.sp,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(flex: 2),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppString.forgot,
                    style: FontManager.contTitle.copyWith(
                      fontSize: 24,
                      color: AppColors.login,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    AppString.resMessage,
                    style: FontManager.subtitle.copyWith(
                      color: AppColors.patient,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.h24,
                  CustomTextfield(
                    controller: emailController,
                    text: "Email",
                    hintText: 'someone@gmail.com',
                  ),
                  AppSpacing.h24,
                  forgotPasswordProvider.isLoading
                      ? CircularProgressIndicator(color: AppColors.primaryColor)
                      : CustomButton(
                          text: "Send",
                          onTap: () async {
                            final email = emailController.text.trim();

                            if (email.isEmpty) {
                              CustomSnackBar.showError(
                                context,
                                "Please enter your email.",
                              );
                              return;
                            }

                            final otpToken = await forgotPasswordProvider
                                .sendResetLink(email);

                            if (otpToken != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OtpVerification(
                                    source: OtpSource.send,
                                    email: email,
                                    otpToken: otpToken,
                                  ),
                                ),
                              );
                            } else {
                              CustomSnackBar.showError(
                                context,
                                "Failed to send reset link. Please try again.",
                              );
                            }
                          },
                        ),
                  AppSpacing.h24,
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginView()),
                      );
                    },
                    child: Text(
                      "Back to Login",
                      style: FontManager.subtitle.copyWith(
                        color: AppColors.optBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}
