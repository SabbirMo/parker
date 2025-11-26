import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/provider/notification_provider/notification_model.dart';
import 'package:provider/provider.dart';

class MonitorNotificationView extends StatefulWidget {
  const MonitorNotificationView({super.key});

  @override
  State<MonitorNotificationView> createState() =>
      _MonitorNotificationViewState();
}

class _MonitorNotificationViewState extends State<MonitorNotificationView> {
  @override
  void initState() {
    super.initState();
    // Fetch notifications from backend when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().fetchNotifications();
    });
  }

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
            Expanded(
              child: Consumer<NotificationProvider>(
                builder: (context, notificationProvider, child) {
                  // Show loading indicator
                  if (notificationProvider.isLoading &&
                      notificationProvider.notifications.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.optBlue,
                      ),
                    );
                  }

                  final notifications = notificationProvider.notifications;

                  if (notifications.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_none,
                            size: 80.sp,
                            color: AppColors.optBlue.withValues(alpha: 0.5),
                          ),
                          AppSpacing.h16,
                          Text(
                            'No notifications yet',
                            style: FontManager.loginStyle.copyWith(
                              fontSize: 18.sp,
                              color: AppColors.black1.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => notificationProvider.fetchNotifications(),
                    color: AppColors.optBlue,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: notifications.length,
                      separatorBuilder: (context, index) => AppSpacing.h16,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        final isTaken =
                            notification.type == NotificationType.taken;

                        return NotificationCart(
                          imagePath: isTaken
                              ? 'assets/icons/right.png'
                              : 'assets/icons/alert.png',
                          title: notification.title,
                          body: notification.body,
                          time: notification.getFormattedTime(),
                          hours: notification.getTimeAgo(),
                          color: isTaken
                              ? AppColors.greenOpca
                              : AppColors.redOpacity,
                          iconColor: isTaken
                              ? AppColors.green
                              : AppColors.cColor2,
                          isRead: notification.isRead,
                          onTap: () {
                            if (!notification.isRead) {
                              notificationProvider.markAsRead(notification.id);
                            }
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            AppSpacing.h16,
            Consumer<NotificationProvider>(
              builder: (context, notificationProvider, child) {
                if (notificationProvider.notifications.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      // Show confirmation dialog
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Clear Notifications'),
                          content: Text(
                            'Are you sure you want to clear all notifications?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                notificationProvider.clearAll();
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Clear',
                                style: TextStyle(color: AppColors.cColor2),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text(
                      'Clear',
                      style: FontManager.loginStyle.copyWith(
                        fontSize: 16.sp,
                        color: AppColors.optBlue,
                      ),
                    ),
                  ),
                );
              },
            ),
            AppSpacing.h16,
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
    this.body,
    required this.time,
    required this.hours,
    this.color,
    this.iconColor,
    this.isRead = false,
    this.onTap,
  });

  final String imagePath;
  final String title;
  final String? body;
  final String time;
  final String hours;
  final Color? color;
  final Color? iconColor;
  final bool isRead;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: isRead
              ? AppColors.white.withValues(alpha: 0.7)
              : AppColors.white,
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
                      fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (body != null && body!.isNotEmpty) ...[
                    AppSpacing.h4,
                    Text(
                      body!,
                      style: FontManager.loginStyle.copyWith(
                        fontSize: 14.sp,
                        color: Color(0xff666666),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
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
      ),
    );
  }
}
