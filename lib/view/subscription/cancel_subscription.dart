import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/back_button.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'package:parker_touch/view/subscription/subscription_view.dart';

class CancelSubscription extends StatelessWidget {
  const CancelSubscription({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            CustomBackButton(),
            AppSpacing.h12,
            Text('You are', style: FontManager.bodyText8),
            Text(
              'Premium',
              style: FontManager.bodyText8.copyWith(
                color: AppColors.login,
                height: 1,
              ),
            ),
            Text('User', style: FontManager.bodyText8),
            AppSpacing.h6,
            Text(
              'with premium you can',
              style: FontManager.connectPotient.copyWith(
                color: AppColors.black1,
              ),
            ),
            AppSpacing.h8,
            FeatureTile(
              text: 'Get smart, friendly alerts that speak to you by name.',
            ),
            AppSpacing.h8,
            FeatureTile(
              text:
                  'Use your camera to confirm the right medicine before taking it.',
            ),
            AppSpacing.h8,
            FeatureTile(
              text: ' Let your loved ones track your progress in real time.',
            ),
            AppSpacing.h18,
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(width: 1, color: AppColors.primaryColor),
              ),
              child: Column(
                children: [
                  Text(
                    "Currently You’ve been using premium subscription",
                    style: FontManager.bodyText7,
                  ),
                  AppSpacing.h8,
                  Text(
                    "12 month Plan",
                    style: FontManager.bodyText9.copyWith(fontSize: 24.sp),
                  ),
                ],
              ),
            ),
            AppSpacing.h64,
            CustomButton(
              text: "Cancel subscription",
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              "Are You Sure?",
                              style: FontManager.bodyText8.copyWith(
                                fontSize: 20.sp,
                              ),
                            ),
                            AppSpacing.h8,
                            Text(
                              'You will lost your premium access',
                              style: FontManager.bodyText4.copyWith(
                                color: Color(0xff6C6C6C),
                              ),
                            ),
                            AppSpacing.h12,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CustomButton(
                                  text: 'No',
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  width: 100.w,
                                  bgColor: Colors.blue.withValues(alpha: 0.1),
                                  border: Border.all(
                                    width: 1,
                                    color: AppColors.primaryColor,
                                  ),
                                  isBoxShadow: false,
                                ),
                                CustomButton(
                                  text: 'Yes',
                                  onTap: () {},
                                  width: 100.w,
                                  bgColor: AppColors.cColor2,
                                  isBoxShadow: false,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              bgColor: AppColors.cColor2,
            ),
          ],
        ),
      ),
    );
  }
}
