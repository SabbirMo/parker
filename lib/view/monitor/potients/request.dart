import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/font_manager.dart';

class Request extends StatelessWidget {
  const Request({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            children: [
              RequestCard(
                title: "Peter Johnson",
                subtitle: "sarah@gmail.com",
                status: 'Connected',
              ),
              AppSpacing.h14,
              RequestCard(
                title: "Maratha Johnson",
                subtitle: "sarah@gmail.com",
                status: 'Connected',
              ),
              AppSpacing.h14,
              RequestCard(
                title: "John parker",
                subtitle: "sarah@gmail.com",
                panding: 'Pending',
              ),
              AppSpacing.h14,
              RequestCard(
                title: "John parker",
                subtitle: "sarah@gmail.com",
                panding: "Decline",
                textColors: AppColors.textRed,
                textColor: AppColors.black1,
                declineColor: AppColors.redOpacity,
                status: "Accept",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RequestCard extends StatelessWidget {
  const RequestCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.status,
    this.color,
    this.textColor,
    this.isSelected = false,
    this.panding,
    this.declineColor,
    this.textColors,
  });

  final String title;
  final String subtitle;
  final String? status;
  final Color? color;
  final Color? textColor;
  final bool isSelected;
  final String? panding;
  final Color? declineColor;
  final Color? textColors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: FontManager.loginStyle.copyWith(color: AppColors.black1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (status != null)
                Container(
                  width: 100.w,
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color ?? AppColors.greenOpca,
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: Center(
                    child: Text(
                      status ?? '',
                      style: FontManager.bodyText.copyWith(
                        color: textColor ?? AppColors.greenOp,
                      ),
                    ),
                  ),
                ),

              AppSpacing.w10,
              if (panding != null)
                Container(
                  width: 100.w,
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: declineColor ?? AppColors.yellow,
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: Center(
                    child: Text(
                      panding ?? '',
                      style: FontManager.bodyText.copyWith(
                        color: textColors ?? AppColors.yellow2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Text(
            subtitle,
            style: FontManager.subtitle.copyWith(
              color: AppColors.black1,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
