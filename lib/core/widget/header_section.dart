import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/font_manager.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.text,
    this.image,
  });

  final String title;
  final String subtitle;
  final String text;
  final String? image;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.20,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withValues(alpha: 0.6),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: FontManager.titleStyle.copyWith(
                    color: AppColors.white,
                  ),
                ),
                Text(
                  subtitle,
                  style: FontManager.loginStyle.copyWith(
                    color: AppColors.white,
                    fontSize: 24.sp,
                  ),
                ),
                Text(
                  text,
                  style: FontManager.subtitle.copyWith(
                    color: AppColors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (image != null && image!.isNotEmpty)
            Positioned(
              right: 0,
              bottom: 0,
              child: Image.asset(image!, height: size.height * 0.15),
            ),
        ],
      ),
    );
  }
}
