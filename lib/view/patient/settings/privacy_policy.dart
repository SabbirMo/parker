import 'package:flutter/material.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/condition_widget.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConditionWidget(
                title: "Privacy Policy",
                subtitle: "We respect your privacy.",
                description:
                    "Parker’s Touch collects limited data to provide reminders and app functionality.",
              ),
              AppSpacing.h10,
              BulletText(
                'Data collected: name, email, medicine info, reminders, and optional images.',
              ),
              AppSpacing.h4,
              BulletText(
                "Use: to send reminders, verify medicines, and improve app performance.",
              ),
              AppSpacing.h4,
              BulletText(
                "Sharing: never sold; shared only with trusted services (like payment or AI tools).",
              ),
              AppSpacing.h4,
              BulletText("Security: your data is encrypted and safely stored."),
              AppSpacing.h4,
              BulletText(
                "Your control: you can edit or delete your data anytime.",
              ),
              AppSpacing.h4,
              BulletText("Children: not for users under 13."),

              Text(
                'By using this app, you agree to this policy.',
                style: FontManager.bodyText7,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
