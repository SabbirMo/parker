import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/app_string.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/back_button.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'package:parker_touch/core/widget/snack_bar.dart';
import 'package:parker_touch/provider/patient_provider/connect_monitor_provider/connect_monitor_provider.dart';
import 'package:parker_touch/provider/patient_provider/connect_monitor_provider/send_request_monitor_provider.dart';
import 'package:provider/provider.dart';

class ConnectMonitorsSend extends StatelessWidget {
  const ConnectMonitorsSend({
    super.key,
    this.monitorId,
    this.fullName,
    this.email,
    this.username,
    this.imageUrl,
  });

  final int? monitorId;
  final String? fullName;
  final String? email;
  final String? username;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SendRequestMonitorProvider>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            CustomBackButton(),
            AppSpacing.h16,
            Text(AppString.connectAMonitor, style: FontManager.connect),
            AppSpacing.h4,
            Text(
              AppString.connectAMonitorSubtitle,
              style: FontManager.connectPotient,
            ),
            AppSpacing.h26,

            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 54.r,
                backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
                    ? NetworkImage(imageUrl!)
                    : AssetImage('assets/images/jhon.png') as ImageProvider,
              ),
            ),
            AppSpacing.h16,
            Align(
              child: Text(
                fullName ?? 'John Parker',
                style: FontManager.contTitle,
                textAlign: TextAlign.center,
              ),
            ),
            AppSpacing.h4,
            Align(
              child: Text(
                email ?? 'John@gmail.com',
                style: FontManager.contSubTitle,
              ),
            ),

            AppSpacing.h32,
            provider.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  )
                : CustomButton(
                    text: 'Send Request',
                    onTap: () async {
                      if (monitorId == null) {
                        CustomSnackBar.showError(
                          context,
                          'Monitor ID not found',
                        );
                        return;
                      }

                      bool result = await provider.sendMonitorRequest(
                        monitorId!,
                      );
                      if (result) {
                        CustomSnackBar.showSuccess(
                          context,
                          'Request sent successfully',
                        );
                        // Refresh the monitors list before going back
                        final connectProvider =
                            Provider.of<ConnectMonitorProvider>(
                              context,
                              listen: false,
                            );
                        await connectProvider.fetchPatientMonitors();
                        Navigator.pop(context, true);
                      } else {
                        CustomSnackBar.showError(
                          context,
                          provider.errorMessage ?? 'Failed to send request',
                        );
                      }
                    },
                    leftIcon: 'assets/icons/send.png',
                  ),
          ],
        ),
      ),
    );
  }
}
