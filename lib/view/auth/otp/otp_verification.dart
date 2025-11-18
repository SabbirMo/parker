import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/app_string.dart';
import 'package:parker_touch/core/constants/assets_manager.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/back_button.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'package:parker_touch/core/widget/snack_bar.dart';
import 'package:parker_touch/provider/auth/signup_provider/patient_provider.dart';
import 'package:parker_touch/view/auth/otp/verify_sccessful.dart';
import 'package:provider/provider.dart';

enum OtpSource { signup, send }

class OtpVerification extends StatefulWidget {
  final OtpSource source;
  final String? email;
  final String? otpToken;

  const OtpVerification({
    super.key,
    required this.source,
    this.email,
    this.otpToken,
  });

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

  String _maskEmail(String email) {
    if (email.isEmpty) return email;

    final parts = email.split('@');
    if (parts.length != 2) return email;

    final localPart = parts[0];
    final domain = parts[1];

    if (localPart.length <= 3) return email;

    // Calculate middle position
    final middleStart = (localPart.length / 2 - 1.5).round();
    final middleEnd = middleStart + 3;

    // Split into three parts: before mask, mask, after mask
    final beforeMask = localPart.substring(0, middleStart);
    final afterMask = localPart.substring(middleEnd);

    return '$beforeMask***$afterMask@$domain';
  }

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
    final provider = Provider.of<PatientProvider>(context);

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
              height: 291.h,
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
              widget.email != null
                  ? _maskEmail(widget.email!)
                  : AppString.otpMail,
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

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppString.rec,
                  style: FontManager.subtitle.copyWith(color: AppColors.back),
                ),
                InkWell(
                  onTap: () async {
                    // Resend OTP logic here
                    if (widget.source == OtpSource.signup &&
                        widget.otpToken != null) {
                      final result = await provider.resendOtp(widget.otpToken!);
                      if (result != null) {
                        CustomSnackBar.showSuccess(
                          context,
                          'OTP resent successfully to your email.',
                        );
                      } else {
                        CustomSnackBar.showError(
                          context,
                          'Failed to resend OTP. Please try again.',
                        );
                      }
                    }
                  },
                  child: Text(
                    AppString.resend,
                    style: FontManager.subtitle.copyWith(
                      color: AppColors.optBlue,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.h14,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: provider.isloading
                  ? CircularProgressIndicator(color: AppColors.primaryColor)
                  : CustomButton(
                      onTap: _isOtpFilled
                          ? () async {
                              final otp = _otpControllers
                                  .map((controller) => controller.text)
                                  .join();
                              if (widget.source == OtpSource.signup &&
                                  widget.otpToken != null) {
                                final result = await provider.verifyOtp(
                                  otp,
                                  widget.otpToken!,
                                );
                                if (result != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => VerifySccessful(),
                                    ),
                                  );
                                } else {
                                  CustomSnackBar.showError(
                                    context,
                                    'OTP verification failed. Please try again.',
                                  );
                                }
                              }
                            }
                          : null,
                      bgColor: _isOtpFilled
                          ? AppColors.primaryColor
                          : AppColors.grey,
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
