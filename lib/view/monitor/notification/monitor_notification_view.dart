import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/font_manager.dart';

class MonitorNotificationView extends StatelessWidget {
  const MonitorNotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacing.h40,
            Text('Notifications', style: FontManager.connect),
            AppSpacing.h4,
            Text(
              'Allow your family to monitor your medicine progress',
              style: FontManager.connectPotient.copyWith(height: 1.2),
            ),
            AppSpacing.h16,
            const NotificationCart(
              imagePath: 'assets/icons/alert.png',
              title: 'Maratha Johnson missed omeprazol',
              time: '8:00 AM',
              hours: '4 hours ago',
              color: AppColors.redOpacity,
              iconColor: AppColors.cColor2,
            ),
            AppSpacing.h16,
            const NotificationCart(
              imagePath: 'assets/icons/right.png',
              title: 'Maratha Johnson missed omeprazol',
              time: '6:00 AM',
              hours: '5 hours ago',
              color: AppColors.greenOpca,
              iconColor: AppColors.green,
            ),
            AppSpacing.h16,
            const NotificationCart(
              imagePath: 'assets/icons/alert.png',
              title: 'Maratha Johnson missed omeprazol',
              time: '2:00 AM',
              hours: '9 hours ago',
              color: AppColors.redOpacity,
              iconColor: AppColors.cColor2,
            ),
            AppSpacing.h16,
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {},
                child: Text(
                  'Clear',
                  style: FontManager.loginStyle.copyWith(
                    fontSize: 16.sp,
                    color: AppColors.optBlue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationCart extends StatelessWidget {
  const NotificationCart({
    super.key,
    required this.imagePath,
    required this.title,
    required this.time,
    required this.hours,
    this.color,
    this.iconColor,
  });

  final String imagePath;
  final String title;
  final String time;
  final String hours;
  final Color? color;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: AppColors.white,
        border: Border.all(width: 1, color: AppColors.optBlue),
        boxShadow: [
          BoxShadow(
            color: AppColors.optBlue.withValues(alpha: 0.4),
            blurRadius: 5,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [],
            ),

            child: Center(
              child: Image.asset(
                imagePath,
                width: 30.w,
                height: 30.h,
                color: iconColor,
              ),
            ),
          ),
          AppSpacing.w16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: FontManager.loginStyle.copyWith(
                    fontSize: 16.sp,
                    color: AppColors.black1,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                AppSpacing.h6,
                Row(
                  children: [
                    Image.asset('assets/icons/time-line.png'),
                    AppSpacing.w8,
                    Text(
                      time,
                      style: FontManager.loginStyle.copyWith(
                        color: Color(0xff464646),
                      ),
                    ),
                    Spacer(),
                    Text(
                      hours,
                      style: FontManager.loginStyle.copyWith(
                        color: Color(0xff464646),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
