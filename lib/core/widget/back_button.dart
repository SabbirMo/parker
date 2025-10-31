import 'package:flutter/material.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_string.dart';
import 'package:parker_touch/core/constants/font_manager.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Row(
        children: [
          const Icon(Icons.arrow_back_ios_new, size: 22, color: AppColors.back),
          Text(AppString.back, style: FontManager.loginStyle),
        ],
      ),
    );
  }
}
