import 'package:flutter/material.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_string.dart';
import 'package:parker_touch/core/constants/assets_manager.dart';
import 'package:parker_touch/core/constants/font_manager.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            ImageAssets.onboardingOne,
            fit: BoxFit.cover,
          ),
          Text(
              AppString.onboardingTitleOne,
              style: FontManager.titleStyle.copyWith(color: AppColors.black, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 8),
          Text(
            AppString.onboardingSubTitleOne,
            style: FontManager.subtitle.copyWith(color: AppColors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
