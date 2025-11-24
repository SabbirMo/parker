import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/header_section.dart';
import 'package:parker_touch/provider/patient_provider/connect_monitor_provider/connect_monitor_provider.dart';
import 'package:parker_touch/view/monitor/potients/request.dart';
import 'package:parker_touch/view/patient/monitors/connect_monitors.dart';
import 'package:provider/provider.dart';

class MyMonitors extends StatefulWidget {
  const MyMonitors({super.key});

  @override
  State<MyMonitors> createState() => _MyMonitorsState();
}

class _MyMonitorsState extends State<MyMonitors> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ConnectMonitorProvider>(
        context,
        listen: false,
      );
      provider.fetchPatientMonitors();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ConnectMonitorProvider>(context);

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

                    // Show loading indicator
                    if (provider.isLoading)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      )
                    // Show error message
                    else if (provider.errorMessage != null)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            provider.errorMessage!,
                            style: FontManager.bodyText,
                          ),
                        ),
                      )
                    // Show monitors list
                    else if (provider.monitorsList.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            'No monitors found',
                            style: FontManager.bodyText,
                          ),
                        ),
                      )
                    else
                      ...provider.monitorsList.map((monitor) {
                        String statusText = '';
                        Color? statusBgColor;
                        Color? statusTextColor;
                        String? pendingText;
                        Color? pendingBgColor;
                        Color? pendingTextColor;

                        if (monitor.status == 'accepted') {
                          statusText = 'Connected';
                          statusBgColor = AppColors.greenOpca;
                          statusTextColor = AppColors.greenOp;
                        } else if (monitor.status == 'pending' &&
                            monitor.isOutgoing) {
                          pendingText = 'Pending';
                          pendingBgColor = AppColors.yellow;
                          pendingTextColor = AppColors.yellow2;
                        } else if (monitor.status == 'pending' &&
                            !monitor.isOutgoing) {
                          pendingText = 'Decline';
                          pendingBgColor = AppColors.redOpacity;
                          pendingTextColor = AppColors.textRed;
                          statusText = 'Accept';
                          statusBgColor = AppColors.greenOpca;
                          statusTextColor = AppColors.greenOp;
                        } else if (monitor.status == 'rejected') {
                          pendingText = 'Declined';
                          pendingBgColor = AppColors.redOpacity;
                          pendingTextColor = AppColors.textRed;
                        }

                        return Column(
                          children: [
                            RequestCard(
                              title: monitor.fullName,
                              subtitle: monitor.email,
                              status: statusText.isNotEmpty ? statusText : null,
                              color: statusBgColor,
                              textColor: statusTextColor,
                              panding: pendingText,
                              declineColor: pendingBgColor,
                              textColors: pendingTextColor,
                            ),
                            AppSpacing.h14,
                          ],
                        );
                      }).toList(),
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
