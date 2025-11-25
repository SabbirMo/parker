import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/app_string.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/time/time_get_greeting.dart';
import 'package:parker_touch/core/widget/header_section.dart';
import 'package:parker_touch/provider/auth/login_provider/login_provider.dart';
import 'package:parker_touch/view/monitor/connect_potient/connect_potient.dart';
import 'package:parker_touch/view/monitor/potients/all_patients.dart';
import 'package:parker_touch/view/monitor/potients/request.dart';
import 'package:provider/provider.dart';

class MonitorPotientsView extends StatefulWidget {
  const MonitorPotientsView({super.key});

  @override
  State<MonitorPotientsView> createState() => _MonitorPotientsViewState();
}

class _MonitorPotientsViewState extends State<MonitorPotientsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Consumer(
            builder: (context, LoginProvider loginProvider, Widget? child) =>
                HeaderSection(
                  title: TimeGetGreeting.getGreeting(),
                  subtitle: loginProvider.fullName != null
                      ? loginProvider.fullName!
                      : AppString.enolaParker,
                  text: AppString.monitoringPatient,
                ),
          ),

          AppSpacing.h12,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 46.h,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: AppColors.borderColor,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      unselectedLabelStyle: FontManager.bodyText3,
                      labelStyle: FontManager.bodyText3.copyWith(
                        color: AppColors.white,
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerHeight: 0,
                      splashFactory: NoSplash.splashFactory,
                      physics: const NeverScrollableScrollPhysics(),
                      enableFeedback: false,
                      tabs: [
                        Tab(text: "All Patients"),
                        Tab(text: "Request"),
                      ],
                    ),
                  ),
                ),
                AppSpacing.w18,
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ConnectPotient()),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: AppColors.optBlue,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add,
                        color: AppColors.white,
                        size: 26.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [AllPatients(), Request()],
            ),
          ),
        ],
      ),
    );
  }
}
