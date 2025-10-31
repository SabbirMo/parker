import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/font_manager.dart';

class TextCart extends StatelessWidget {
  const TextCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Parker's Touch",
          style: FontManager.titleStyle.copyWith(fontSize: 20.sp),
        ),
        AppSpacing.h2,
        Text(
          "Enjoy premium access for free",
          style: FontManager.subtitle.copyWith(
            color: AppColors.text,
            fontSize: 14.sp,
          ),
        ),
        Text(
          "Cancel anytime before trial ends",
          style: FontManager.subtitle.copyWith(
            color: AppColors.text,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }
}
