import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/app_string.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/back_button.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'package:parker_touch/core/widget/custom_textfield.dart';
import 'package:parker_touch/view/auth/login/login_view.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                  SizedBox(height: 12),
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
                  CustomButton(
                    text: "Send",
                    onTap: () {
                      final email = emailController.text.trim();
                      print('Reset link sent to $email');
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
