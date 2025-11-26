// ignore_for_file: override_on_non_overriding_member

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/app_string.dart';
import 'package:parker_touch/core/constants/assets_manager.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/view/monitor/monitor_view.dart';
import 'package:parker_touch/view/onboarding/onboarding.dart';
import 'package:parker_touch/view/patient/patient_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  int activeDot = 0;

  @override
  late Timer _dotTimer;
  late Timer _navigationTimer;

  @override
  void initState() {
    super.initState();
    _dotTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        activeDot = (activeDot + 1) % 3;
      });
    });

    _navigationTimer = Timer(const Duration(seconds: 3), () {
      _checkLoginStatus();
    });
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    final role = prefs.getString('role');

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      // User is logged in, navigate to appropriate page based on role
      if (role == 'patient') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PatientView()),
        );
      } else if (role == 'monitor') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MonitorView()),
        );
      } else {
        // Unknown role, go to onboarding
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingPage()),
        );
      }
    } else {
      // User is not logged in, go to onboarding
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingPage()),
      );
    }
  }

  @override
  void dispose() {
    _dotTimer.cancel();
    _navigationTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [AppColors.linerColorStart, AppColors.linerColorEnd],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(IconAssets.splashLogo, width: 130.w, height: 130.h),
            AppSpacing.h22,
            Text(
              AppString.appName,
              style: FontManager.titleStyle.copyWith(
                fontSize: 26.sp,
                color: AppColors.white,
              ),
            ),

            Text(
              AppString.splashSubtitle,
              style: FontManager.subtitle.copyWith(color: AppColors.white),
            ),
            AppSpacing.h36,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    color: activeDot == index
                        ? AppColors.white.withValues(alpha: 0.1)
                        : AppColors.white,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
