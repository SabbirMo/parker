import 'package:flutter/material.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_string.dart';
import 'package:parker_touch/core/constants/assets_manager.dart';
import 'package:parker_touch/core/constants/font_manager.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: double.infinity,
          child: Image.asset(ImageAssets.onboardingThree, fit: BoxFit.cover),
        ),
        Text(
          AppString.onboardingTitleThree,
          style: FontManager.titleStyle
              .copyWith(color: AppColors.black, fontWeight: FontWeight.w400)
              .merge(
                const TextStyle(fontFamilyFallback: ['Poppins', 'sans-serif']),
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          AppString.onboardingSubTitleThree,
          style: FontManager.subtitle
              .copyWith(color: AppColors.grey)
              .merge(
                const TextStyle(fontFamilyFallback: ['Nunito', 'sans-serif']),
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
