import 'package:flutter/material.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/widget/condition_widget.dart';

class TeamCondition extends StatelessWidget {
  const TeamCondition({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),

        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            ConditionWidget(
              title: 'Terms and Conditions',
              subtitle: "Welcome to Parker’s Touch.",
              description:
                  "By using this app, you agree to our Terms & Conditions.",
            ),
            AppSpacing.h10,
            BulletText(
              'This app helps you manage medicines and reminders but does not replace medical advice.',
            ),
            AppSpacing.h6,
            BulletText(
              "You must enter correct information and use the app responsibly.",
            ),
            AppSpacing.h6,
            BulletText(
              "A 7-day free trial is included; after that, subscriptions renew automatically unless canceled.",
            ),
            AppSpacing.h6,
            BulletText(
              "Payments and cancellations are managed through your app store.",
            ),
            AppSpacing.h6,
            BulletText("Misuse or violation may result in account suspension."),
            AppSpacing.h6,
            BulletText(
              "We are not liable for missed doses or errors caused by device or user mistakes.",
            ),
            AppSpacing.h6,
            BulletText(
              "Continued use means you accept future updates to these terms",
            ),
            AppSpacing.h72,
            Text('Version AIMED 1.1.2'),
          ],
        ),
      ),
    );
  }
}
