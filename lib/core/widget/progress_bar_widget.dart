import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/font_manager.dart';

class ProgressBarWidget extends StatelessWidget {
  final int completed;
  final int total;

  const ProgressBarWidget({super.key, this.completed = 2, this.total = 4});

  @override
  Widget build(BuildContext context) {
    double progress = total > 0 ? completed / total : 0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Progress",
              style: FontManager.loginStyle.copyWith(
                color: Color(0xff303030),
                fontSize: 14.sp,
              ),
            ),
            Text(
              '$completed/$total completed',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
        AppSpacing.h8,
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: LinearProgressIndicator(
            minHeight: 14.h,
            value: progress,
            backgroundColor: AppColors.lineColors,
            borderRadius: BorderRadius.circular(12.r),
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
          ),
        ),
      ],
    );
  }
}
