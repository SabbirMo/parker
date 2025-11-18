import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/app_string.dart';
import 'package:parker_touch/core/constants/assets_manager.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/view/auth/Sing_up/monitor_sign_up.dart';
import 'package:parker_touch/view/auth/Sing_up/patient_sign_up.dart';
import 'package:parker_touch/view/auth/login/login_view.dart';

class ChooseUser extends StatelessWidget {
  const ChooseUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppString.chooseUserTitle,
              style: FontManager.titleStyle,
              textAlign: TextAlign.center,
            ),
            AppSpacing.h8,
            Text(
              AppString.chooseUserSubTitle,
              style: FontManager.subtitle.copyWith(color: AppColors.grey),
            ),
            AppSpacing.h32,

            CustomContainer(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PatientSignUp(),
                  ),
                );
              },
              title: AppString.title,
              subTitle: AppString.subTitle,
              subTitle2: AppString.subTitle2,
              svgPath: SvgAssets.person,
              bgColor: AppColors.contLeadingBg,
            ),
            AppSpacing.h16,
            CustomContainer(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MonitorSignUp(),
                  ),
                );
              },
              title: AppString.title1,
              subTitle: AppString.subTitle,
              subTitle2: AppString.subTitle2,
              svgPath: SvgAssets.heart,
              bgColor: AppColors.contLeadingBgs,
            ),
            AppSpacing.h56,
            Text(
              AppString.patient,
              style: FontManager.loginStyle.copyWith(
                color: AppColors.patient,
                fontSize: 14.sp,
              ),
            ),
            AppSpacing.h2,
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginView()),
                );
              },
              child: Text(
                AppString.loginHere,
                style: FontManager.loginStyle.copyWith(color: AppColors.login),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    required this.title,
    required this.subTitle,
    required this.subTitle2,
    required this.svgPath,
    required this.bgColor,
    this.onTap,
  });

  final String title;
  final String subTitle;
  final String subTitle2;
  final String svgPath;
  final Color bgColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.borderColor),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withValues(alpha: 0.4),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 1.w),
          leading: CircleAvatar(
            radius: 38,
            backgroundColor: bgColor,
            child: SvgPicture.asset(svgPath),
          ),
          title: Text(title, style: FontManager.contTitle),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subTitle,
                style: FontManager.subtitle.copyWith(
                  color: AppColors.grey,
                  fontSize: 14.sp,
                  height: 2,
                ),
              ),
              Text(
                subTitle2,
                style: FontManager.subtitle.copyWith(
                  color: AppColors.grey,
                  fontSize: 14.sp,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
