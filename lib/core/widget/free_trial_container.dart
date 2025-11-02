import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'package:parker_touch/core/widget/text_cart.dart';
import 'package:parker_touch/view/subscription/subscription_view.dart';

class FreeTrialContainer extends StatefulWidget {
  const FreeTrialContainer({super.key});

  @override
  State<FreeTrialContainer> createState() => _FreeTrialContainerState();
}

class _FreeTrialContainerState extends State<FreeTrialContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(width: 1, color: AppColors.primaryColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22.r,
                backgroundColor: AppColors.appBottomColor,
                child: Image.asset('assets/icons/gift.png'),
              ),
              AppSpacing.w10,
              const TextCart(),
            ],
          ),
          AppSpacing.h10,
          CustomButton(
            text: "START FREE TRIAL",
            bgColor: AppColors.optBlue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SubscriptionView()),
              );
            },
          ),
        ],
      ),
    );
  }
}
