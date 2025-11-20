import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/back_button.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'package:parker_touch/view/subscription/cancel_subscription.dart';

class SubscriptionView extends StatefulWidget {
  const SubscriptionView({super.key});

  @override
  State<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView> {
  int _selectedCardIndex = 0; // First card selected by default

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
            Text('Get', style: FontManager.bodyText8),
            Text(
              'Premium',
              style: FontManager.bodyText8.copyWith(
                color: AppColors.login,
                height: 1,
              ),
            ),
            Text('Access', style: FontManager.bodyText8),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCardIndex = 0;
                    });
                  },
                  child: PriceCard(
                    duration: '1',
                    durationUnit: 'month',
                    originalPrice: '\$199.00',
                    discountedPrice: '\$129.00',
                    isSelected: _selectedCardIndex == 0,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCardIndex = 1;
                    });
                  },
                  child: PriceCard(
                    duration: '6',
                    durationUnit: 'month',
                    originalPrice: '\$299.00',
                    discountedPrice: '\$229.00',
                    isSelected: _selectedCardIndex == 1,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCardIndex = 2;
                    });
                  },
                  child: PriceCard(
                    duration: '12',
                    durationUnit: 'month',
                    originalPrice: '\$399.00',
                    discountedPrice: '\$329.00',
                    isPopular: true,
                    isSelected: _selectedCardIndex == 2,
                  ),
                ),
              ],
            ),
            AppSpacing.h22,
            Align(
              alignment: Alignment.center,
              child: Text(
                'Start your first plan today',
                style: FontManager.contTitle.copyWith(fontSize: 16.sp),
              ),
            ),
            Align(
              child: Text(
                "Automatic Renewal | Cancel Anytime",
                style: FontManager.contSubTitle.copyWith(
                  color: Color(0xff626060),
                ),
              ),
            ),
            AppSpacing.h22,
            CustomButton(
              text: "Buy Now",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CancelSubscription()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PriceCard extends StatelessWidget {
  final String duration;
  final String durationUnit;
  final String originalPrice;
  final String discountedPrice;
  final bool isPopular;
  final bool isSelected;

  const PriceCard({
    super.key,
    required this.duration,
    required this.durationUnit,
    required this.originalPrice,
    required this.discountedPrice,
    this.isPopular = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 32,
            bottom: 14,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F5FF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.transparent,
              width: 2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Column(
            children: [
              Text(duration, style: FontManager.bodyText9),
              Text(durationUnit, style: FontManager.bodyText9),
              const SizedBox(height: 12),
              Text(
                originalPrice,
                style: FontManager.bodyText5.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: Color(0xff787878),
                ),
              ),
              Text(
                discountedPrice,
                style: FontManager.bodyText5.copyWith(color: AppColors.black1),
              ),
            ],
          ),
        ),
        if (isPopular)
          Positioned(
            top: 0,
            left: 18,
            right: 18,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: const Center(
                child: Text(
                  'popular',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class FeatureTile extends StatelessWidget {
  final String text;
  const FeatureTile({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset('assets/icons/right.png', color: AppColors.green),
        AppSpacing.w10,
        Expanded(
          child: Text(
            text,
            style: FontManager.contSubTitle.copyWith(color: Color(0xff626060)),
          ),
        ),
      ],
    );
  }
}
