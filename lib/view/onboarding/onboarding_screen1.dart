import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/app_string.dart';
import 'package:parker_touch/core/constants/assets_manager.dart';
import 'package:parker_touch/core/constants/font_manager.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: Image.asset(
                ImageAssets.onboardingOne,
                fit: BoxFit.contain,
              ),
            ),
            AppSpacing.h24,
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppString.onboardingTitleOne,
                    style: FontManager.titleStyle
                        .copyWith(
                          color: AppColors.black,
                          fontWeight: FontWeight.w400,
                          height: 1.2,
                        )
                        .merge(
                          const TextStyle(
                            fontFamilyFallback: ['Poppins', 'sans-serif'],
                          ),
                        ),
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.h8,
                  Text(
                    AppString.onboardingSubTitleOne,
                    style: FontManager.subtitle
                        .copyWith(color: AppColors.grey)
                        .merge(
                          const TextStyle(
                            fontFamilyFallback: ['Nunito', 'sans-serif'],
                          ),
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
