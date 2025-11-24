import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/app_string.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/header_section.dart';
import 'package:parker_touch/core/widget/progress_bar_widget.dart';
import 'package:parker_touch/provider/auth/login_provider/login_provider.dart';
import 'package:parker_touch/view/monitor/connect_potient/medicine_potient.dart';
import 'package:provider/provider.dart';

class HomeMonitor extends StatefulWidget {
  const HomeMonitor({super.key});

  @override
  State<HomeMonitor> createState() => _HomeMonitorState();
}

class _HomeMonitorState extends State<HomeMonitor> {
  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return AppString.goodMorning;
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Consumer(
            builder: (context, LoginProvider loginProvider, Widget? child) =>
                HeaderSection(
                  title: getGreeting(),
                  subtitle: loginProvider.fullName != null
                      ? loginProvider.fullName!
                      : AppString.enolaParker,
                  text: AppString.monitoringPatient,
                ),
          ),

          AppSpacing.h6,
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 16.0,
                  left: 16.0,
                  top: 8.0,
                  bottom: 30.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AlertContainer(),
                    AppSpacing.h18,
                    Text(
                      'Your patients (2)',
                      style: FontManager.loginStyle.copyWith(fontSize: 18.sp),
                    ),
                    AppSpacing.h12,
                    PatientCard(
                      cricleIcon: 'assets/images/woman.png',
                      name: 'Maratha Johnson',
                      alertIcon: 'assets/icons/alert.png',
                    ),
                    AppSpacing.h10,
                    PatientCard(
                      cricleIcon: 'assets/images/oldMan.png',
                      name: 'Peter Johnson',
                      isSelected: false,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PatientCard extends StatelessWidget {
  const PatientCard({
    super.key,
    required this.cricleIcon,
    required this.name,
    this.alertIcon,
    this.isSelected = true,
  });

  final String cricleIcon;
  final String name;
  final String? alertIcon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(16.r),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22.r,
                backgroundImage: AssetImage(cricleIcon),
              ),
              AppSpacing.w12,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: FontManager.loginStyle.copyWith(
                      color: Color(0xf0000000),
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '72 years old',
                    style: FontManager.subtitle.copyWith(
                      color: Color(0xff626262),
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
              Spacer(),
              if (alertIcon != null) Image.asset(alertIcon!),
            ],
          ),
          AppSpacing.h12,
          Text(
            "Today's Summary",
            style: FontManager.loginStyle.copyWith(color: Color(0xff303030)),
          ),
          AppSpacing.h12,
          ProgressBarWidget(),
          AppSpacing.h12,
          isSelected
              ? Row(
                  children: [
                    Image.asset(
                      'assets/icons/alert.png',
                      width: 20,
                      height: 20,
                    ),
                    AppSpacing.w10,
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: 'Missed', style: FontManager.bodyText),

                          TextSpan(
                            text: ' Omeprazole',
                            style: FontManager.bodyText2,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Image.asset(
                      'assets/icons/right.png',
                      width: 20,
                      height: 20,
                      color: AppColors.green,
                    ),
                    AppSpacing.w10,
                    Text(
                      'Last taken medicine at 12.01 PM',
                      style: FontManager.bodyText.copyWith(
                        color: AppColors.green,
                      ),
                    ),
                  ],
                ),
          AppSpacing.h16,
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MedicinePotient()),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "View Details",
                  style: FontManager.loginStyle.copyWith(
                    color: AppColors.optBlue,
                  ),
                ),
                AppSpacing.w12,
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18.sp,
                  color: AppColors.optBlue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AlertContainer extends StatelessWidget {
  const AlertContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(width: 1, color: Colors.red),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset('assets/icons/alert.png', width: 20, height: 20),
              AppSpacing.w10,
              Text(
                'Recent alert',
                style: FontManager.loginStyle.copyWith(
                  color: Color(0xffFB3748),
                ),
              ),
            ],
          ),
          AppSpacing.h2,
          Text('Maratha Johnson missed ', style: FontManager.loginStyle),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "omeprazole 20mg",
                style: FontManager.loginStyle.copyWith(
                  color: Color(0xff4E4E4E),
                  fontSize: 14.sp,
                ),
              ),
              Text(
                "4 hours ago",
                style: FontManager.subtitle.copyWith(
                  fontSize: 14.sp,
                  color: Color(0xff4E4E4E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
