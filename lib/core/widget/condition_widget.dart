import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/back_button.dart';

class ConditionWidget extends StatelessWidget {
  const ConditionWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
  });

  final String title;
  final String subtitle;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomBackButton(),
        AppSpacing.h12,
        Text(title, style: FontManager.connect),
        AppSpacing.h12,
        Text(subtitle, style: FontManager.bodyText6),
        AppSpacing.h10,
        Text(description, style: FontManager.bodyText7),
      ],
    );
  }
}

class BulletText extends StatelessWidget {
  final String text;
  const BulletText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "• ",
            style: TextStyle(fontSize: 18.sp, height: 1.5, color: Colors.black),
          ),
          Expanded(child: Text(text, style: FontManager.bodyText7)),
        ],
      ),
    );
  }
}
