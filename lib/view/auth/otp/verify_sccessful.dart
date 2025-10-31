import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/app_string.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/back_button.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'package:parker_touch/view/auth/login/login_view.dart';

class VerifySccessful extends StatelessWidget {
  final String? message;
  const VerifySccessful({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              CustomBackButton(),
              Lottie.asset('assets/animations/success.json'),
              AppSpacing.h24,
              Text(AppString.conga, style: FontManager.cong),
              AppSpacing.h16,
              Text(
                AppString.success,
                style: FontManager.subtitle.copyWith(color: AppColors.success),
                textAlign: TextAlign.center,
              ),
              AppSpacing.h26,
              CustomButton(
                text: 'Back to Login',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginView()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
