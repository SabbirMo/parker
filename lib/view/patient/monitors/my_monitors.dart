import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/header_section.dart';
import 'package:parker_touch/view/monitor/potients/request.dart';
import 'package:parker_touch/view/patient/monitors/connect_monitors.dart';

class MyMonitors extends StatelessWidget {
  const MyMonitors({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderSection(
            title: "Good Morning",
            subtitle: "Mr. Parker",
            text: "Stay on track with your medications",
            image: "assets/images/man.png",
          ),
          AppSpacing.h14,
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("My Monitor", style: FontManager.connect),

                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ConnectMonitors(),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: AppColors.optBlue,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.add,
                                color: AppColors.white,
                                size: 24.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.h14,
                    RequestCard(
                      title: "Peter Johnson",
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
          ),
        ],
      ),
    );
  }
}
