import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onTap,
    required this.text,
    this.rightIcon,
    this.leftIcon,
    this.bgColor,
    this.boxShadowColor,
    this.border,
    this.width,
    this.textColor,
    this.iconColor,
    this.isBoxShadow = true,
  });
  final VoidCallback? onTap;
  final String text;
  final IconData? rightIcon;
  final String? leftIcon;
  final Color? bgColor;
  final Color? boxShadowColor;
  final Border? border;
  final double? width;
  final Color? textColor;
  final Color? iconColor;
  final bool isBoxShadow;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width ?? MediaQuery.of(context).size.width,
        height: 36.h,
        decoration: BoxDecoration(
          color: bgColor ?? AppColors.primaryColor,
          borderRadius: BorderRadius.circular(14.r),
          border: border,
          boxShadow: [
            isBoxShadow
                ? BoxShadow(
                    color:
                        boxShadowColor ??
                        AppColors.primaryColor.withValues(alpha: 0.25),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                : BoxShadow(color: Colors.transparent),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leftIcon != null ? Image.asset(leftIcon!) : SizedBox.shrink(),
            AppSpacing.w10,
            Text(
              text,
              style: TextStyle(
                color: textColor ?? AppColors.white,
                fontSize: 16.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            AppSpacing.w10,
            rightIcon != null
                ? Icon(
                    rightIcon,
                    color: iconColor ?? AppColors.white,
                    size: 20.sp,
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
