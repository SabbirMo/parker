import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/app_string.dart';
import 'package:parker_touch/core/constants/assets_manager.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/back_button.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'package:parker_touch/core/widget/custom_textfield.dart';
import 'package:parker_touch/view/auth/forgot/forgot_password.dart';
import 'package:parker_touch/view/patient/patient_view.dart';
import 'package:parker_touch/view/monitor/monitor_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    // Check if either email or password fields have text
    if (_emailController.text.isNotEmpty ||
        _passwordController.text.isNotEmpty) {
      // Navigate to MonitorView if fields have content
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MonitorView()),
      );
    } else {
      // Navigate to PatientView if fields are empty
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PatientView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: SvgPicture.asset(
                  SvgAssets.top,
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context).size.width * 0.4,
                ),
              ),

              Positioned(top: 50, left: 20, child: CustomBackButton()),
            ],
          ),

          const Spacer(flex: 2),
          Container(
            width: MediaQuery.of(context).size.width * 0.92,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.loginCont,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xffd6d9dd)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppString.login, style: FontManager.titleStyle),
                Text(
                  AppString.account,
                  style: FontManager.subtitle.copyWith(color: AppColors.grey),
                ),
                AppSpacing.h12,
                CustomTextfield(
                  text: AppString.email,
                  hintText: AppString.hintEmailAddress,
                  controller: _emailController,
                ),
                CustomTextfield(
                  text: AppString.password,
                  hintText: AppString.hintPassword,
                  icon: Icons.visibility_outlined,
                  obscureText: true,
                  controller: _passwordController,
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ForgotPassword()),
                    );
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      AppString.forgot,
                      style: FontManager.subtitle.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                ),

                AppSpacing.h10,
                CustomButton(text: "Login", onTap: _handleLogin),
                AppSpacing.h10,
                Align(
                  child: Text(
                    AppString.dontHave,
                    style: FontManager.loginStyle.copyWith(
                      color: AppColors.patient,
                      fontSize: 14.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                AppSpacing.h2,
                Align(
                  child: InkWell(
                    onTap: () {},
                    child: Text(
                      AppString.create,
                      style: FontManager.loginStyle.copyWith(
                        color: AppColors.login,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(flex: 3),
          Align(
            alignment: Alignment.bottomLeft,
            child: SvgPicture.asset(SvgAssets.bottom, fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }
}
