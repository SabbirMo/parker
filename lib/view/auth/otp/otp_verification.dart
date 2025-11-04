import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/app_string.dart';
import 'package:parker_touch/core/constants/assets_manager.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/back_button.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'package:parker_touch/view/auth/otp/verify_sccessful.dart';
import 'package:parker_touch/view/auth/change_password/change_password.dart';

enum OtpSource { signup, send }

class OtpVerification extends StatefulWidget {
  final OtpSource source;

  const OtpVerification({super.key, required this.source});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final List<TextEditingController> _otpControllers = List.generate(
    5,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(5, (index) => FocusNode());
  bool _isOtpFilled = false;

  void _checkOtpFilled() {
    setState(() {
      _isOtpFilled = _otpControllers.every(
        (controller) => controller.text.length == 1,
      );
    });
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomBackButton(),
            ),
            Image.asset(
              ImageAssets.otp,
              width: 291.w,
              height: 291,
              fit: BoxFit.cover,
            ),
            Text(
              AppString.otp,
              style: FontManager.titleStyle.copyWith(
                color: AppColors.primaryColor,
              ),
            ),
            Text(
              AppString.otpMsg,
              style: FontManager.subtitle.copyWith(
                color: AppColors.optColor,
                fontSize: 14.sp,
              ),
            ),
            Text(
              AppString.otpMail,
              style: FontManager.subtitle.copyWith(fontSize: 14.sp),
            ),
            AppSpacing.h20,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  width: 45.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1),
                  ),
                  child: TextField(
                    controller: _otpControllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: TextStyle(fontSize: 20.sp),
                    decoration: const InputDecoration(
                      counterText: "",
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      if (value.length == 1 && index < 4) {
                        _focusNodes[index + 1].requestFocus();
                      }
                      if (value.isEmpty && index > 0) {
                        _focusNodes[index - 1].requestFocus();
                      }
                      _checkOtpFilled();
                    },
                  ),
                ),
              ),
            ),
            AppSpacing.h18,
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: AppString.rec,
                    style: FontManager.subtitle.copyWith(color: AppColors.back),
                  ),
                  TextSpan(
                    text: AppString.resend,
                    style: FontManager.subtitle.copyWith(
                      color: AppColors.optBlue,
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.h14,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: CustomButton(
                onTap: _isOtpFilled
                    ? () {
                        if (widget.source == OtpSource.signup) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const VerifySccessful(),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ChangePassword(),
                            ),
                          );
                        }
                      }
                    : null,
                bgColor: _isOtpFilled ? AppColors.primaryColor : AppColors.grey,
                boxShadowColor: Colors.transparent,
                text: "Verify",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
