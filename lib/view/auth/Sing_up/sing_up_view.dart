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
import 'package:parker_touch/view/auth/login/login_view.dart';
import 'package:parker_touch/view/auth/otp/otp_verification.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: SvgPicture.asset(
              SvgAssets.top,
              fit: BoxFit.contain,
              width: MediaQuery.of(context).size.width * 0.4,
            ),
          ),

          Positioned(top: 50, left: 20, child: CustomBackButton()),
          Positioned(
            bottom: 0,
            child: SvgPicture.asset(SvgAssets.bottom, fit: BoxFit.contain),
          ),

          Positioned(
            top: 98.h,
            bottom: 0,
            left: 0,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.92,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.loginCont.withValues(alpha: 0.6),
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
                    Text(
                      AppString.createAccount,
                      style: FontManager.titleStyle,
                    ),
                    Text(
                      AppString.singUp,
                      style: FontManager.subtitle.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    AppSpacing.h12,
                    Column(
                      children: [
                        CustomTextfield(
                          text: AppString.fullName,
                          hintText: AppString.hintFullName,
                        ),
                        CustomTextfield(
                          text: AppString.email,
                          hintText: AppString.hintEmailAddress,
                        ),
                        CustomTextfield(
                          text: AppString.age,
                          hintText: AppString.hintEmailAddress,
                        ),
                        CustomTextfield(
                          text: AppString.password,
                          hintText: AppString.hintPassword,
                          icon: Icons.visibility_outlined,
                          obscureText: true,
                        ),
                        CustomTextfield(
                          text: AppString.confirmPassword,
                          hintText: AppString.hintPassword,
                          icon: Icons.visibility_outlined,
                          obscureText: true,
                        ),
                        AppSpacing.h10,
                        CustomButton(
                          text: "Sign Up",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const OtpVerification(
                                  source: OtpSource.signup,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    AppSpacing.h10,
                    Align(
                      child: Text(
                        AppString.patient,
                        style: FontManager.loginStyle.copyWith(
                          color: AppColors.patient,
                          fontSize: 14.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Align(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginView(),
                            ),
                          );
                        },
                        child: Text(
                          AppString.loginHere,
                          style: FontManager.loginStyle.copyWith(
                            color: AppColors.login,
                          ),
                        ),
                      ),
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
