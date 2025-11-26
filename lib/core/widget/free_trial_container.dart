import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'package:parker_touch/core/widget/text_cart.dart';
import 'package:parker_touch/provider/subscription_provider/subscription_status_provider.dart';
import 'package:parker_touch/view/subscription/subscription_view.dart';
import 'package:provider/provider.dart';

class FreeTrialContainer extends StatefulWidget {
  const FreeTrialContainer({super.key});

  @override
  State<FreeTrialContainer> createState() => _FreeTrialContainerState();
}

class _FreeTrialContainerState extends State<FreeTrialContainer> {
  @override
  void initState() {
    super.initState();
    // Fetch subscription status when widget loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SubscriptionStatusProvider>(
        context,
        listen: false,
      ).getSubscriptionStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SubscriptionStatusProvider>(context);
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

          // Show trial info only if trial days are remaining
          if (provider.isTrialing && provider.trialDaysLeft > 0) ...[
            Text(
              'Your Free Trial Ends in ${provider.trialDaysLeft} days',
              style: TextStyle(
                color: Color(0xff0067D8),
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.h10,
          ],

          CustomButton(
            text: 'MANAGE SUBSCRIPTION',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SubscriptionView()),
              );
            },
          ),
        ],
      ),
    );
  }
}
