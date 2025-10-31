import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/font_manager.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield({
    super.key,
    required this.text,
    required this.hintText,
    this.icon,
    this.controller,
    this.obscureText = false,
    this.bgColor,
    this.borderColor,
    this.enabled = true,
    this.isSelected = true,
  });

  final String text;
  final String hintText;
  final IconData? icon;
  final TextEditingController? controller;
  final Color? bgColor;
  final Color? borderColor;
  final bool isSelected;
  final bool enabled;

  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: isSelected
              ? FontManager.loginStyle.copyWith(
                  fontSize: 14.sp,
                  color: Colors.black,
                )
              : FontManager.subtitle.copyWith(color: Colors.black),
        ),
        Container(
          margin: const EdgeInsets.only(top: 6, bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: bgColor ?? AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: borderColor ?? Color(0xffd6d9dd)),
          ),
          child: TextField(
            controller: controller,
            scrollPadding: EdgeInsets.all(8),
            enabled: enabled,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
              hintStyle: FontManager.loginStyle.copyWith(
                color: AppColors.grey,
                fontSize: 14.sp,
              ),
              suffixIcon: icon != null
                  ? Icon(icon, color: AppColors.grey)
                  : null,
            ),
            obscureText: obscureText,
          ),
        ),
      ],
    );
  }
}
