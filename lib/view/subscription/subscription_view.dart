import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/back_button.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'package:parker_touch/core/widget/snack_bar.dart';
import 'package:parker_touch/provider/subscription_provider/subscription_status_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionView extends StatefulWidget {
  const SubscriptionView({super.key});

  @override
  State<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView> {
  int? _selectedCardIndex; // Selected plan ID

  @override
  void initState() {
    super.initState();
    // Fetch plans when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<SubscriptionStatusProvider>(
        context,
        listen: false,
      );
      if (!provider.plansLoaded) {
        provider.fetchPlans();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SubscriptionStatusProvider>(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            CustomBackButton(),
            AppSpacing.h16,
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
            provider.isLoading
                ? SizedBox(
                    height: 140.h,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  )
                : provider.plans.isEmpty
                ? SizedBox(
                    height: 140.h,
                    child: Center(
                      child: Text(
                        'No plans available',
                        style: FontManager.contSubTitle,
                      ),
                    ),
                  )
                : SizedBox(
                    height: 140.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: provider.plans.length,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemBuilder: (context, index) {
                        final plan = provider.plans[index];
                        final isPopular =
                            index == 1; // Make second plan popular
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index < provider.plans.length - 1 ? 16.w : 0,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCardIndex = plan.id;
                              });
                            },
                            child: PriceCard(
                              planName: plan.name,
                              duration: _getDuration(plan.interval),
                              durationUnit: plan.intervalDisplay,
                              price: '\$${plan.price.toStringAsFixed(2)}',
                              features: plan.features,
                              isPopular: isPopular,
                              isSelected: _selectedCardIndex == plan.id,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
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
            provider.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  )
                : CustomButton(
                    text: "Buy Now",
                    onTap: () async {
                      final provider = Provider.of<SubscriptionStatusProvider>(
                        context,
                        listen: false,
                      );

                      // Get plan_id from selected plan
                      if (provider.plans.isEmpty) {
                        CustomSnackBar.showSuccess(
                          context,
                          'No plans available',
                        );
                        return;
                      }

                      if (_selectedCardIndex == null) {
                        CustomSnackBar.showSuccess(
                          context,
                          'Please select a plan',
                        );
                        return;
                      }

                      String planId = _selectedCardIndex.toString();

                      // Create checkout session
                      final checkoutUrl = await provider.createCheckout(planId);

                      if (checkoutUrl != null) {
                        try {
                          // Open Stripe checkout URL
                          final uri = Uri.parse(checkoutUrl);
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        } catch (e) {
                          // Show error if URL can't be opened
                          debugPrint('Error launching URL: $e');
                          if (context.mounted) {
                            CustomSnackBar.showSuccess(
                              context,
                              'Unable to open checkout page',
                            );
                          }
                        }
                      } else {
                        // Show error if checkout creation failed
                        if (context.mounted) {
                          CustomSnackBar.showSuccess(
                            context,
                            provider.errorMessage ??
                                'Failed to create checkout',
                          );
                        }
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }

  String _getDuration(String interval) {
    switch (interval.toLowerCase()) {
      case 'day':
        return '1';
      case 'week':
        return '1';
      case 'month':
        return '1';
      case 'year':
        return '12';
      default:
        return '1';
    }
  }
}

class PriceCard extends StatelessWidget {
  final String planName;
  final String duration;
  final String durationUnit;
  final String price;
  final List<String> features;
  final bool isPopular;
  final bool isSelected;

  const PriceCard({
    super.key,
    required this.planName,
    required this.duration,
    required this.durationUnit,
    required this.price,
    required this.features,
    this.isPopular = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 160.w,
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
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                planName,
                style: FontManager.bodyText5.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                price,
                style: FontManager.bodyText5.copyWith(
                  color: AppColors.black1,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
              Text(
                '/ $durationUnit',
                style: FontManager.contSubTitle.copyWith(
                  color: Color(0xff787878),
                  fontSize: 12.sp,
                ),
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
