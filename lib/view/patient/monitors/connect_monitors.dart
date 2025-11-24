import 'package:flutter/material.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/app_string.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/back_button.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'package:parker_touch/core/widget/custom_textfield.dart';
import 'package:parker_touch/core/widget/snack_bar.dart';
import 'package:parker_touch/provider/patient_provider/connect_monitor_provider/connect_monitor_provider.dart';
import 'package:parker_touch/view/patient/monitors/connect_monitors_send.dart';
import 'package:provider/provider.dart';

class ConnectMonitors extends StatefulWidget {
  const ConnectMonitors({super.key});

  @override
  State<ConnectMonitors> createState() => _ConnectMonitorsState();
}

class _ConnectMonitorsState extends State<ConnectMonitors> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ConnectMonitorProvider>(context);
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
            AppSpacing.h24,

            CustomTextfield(
              text: 'Monitor’s Email or User name',
              hintText: 'user name or email',
              isSelected: false,
              controller: controller,
              borderColor: AppColors.textFieldBorderColor,
              bgColor: AppColors.textFieldBgColor,
            ),

            AppSpacing.h24,

            provider.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  )
                : CustomButton(
                    text: 'Search',
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      final emailOrUsername = controller.text.trim();

                      bool result = await provider.connectMonitor(
                        emailOrUsername,
                      );
                      if (result == true) {
                        // Navigate to ConnectMonitorsSend with monitor data
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConnectMonitorsSend(
                              monitorId: provider.monitorData?['id'],
                              fullName: provider.monitorData?['full_name'],
                              email: provider.monitorData?['email'],
                              username: provider.monitorData?['username'],
                              imageUrl: provider.monitorData?['profile_image'],
                            ),
                          ),
                        );
                      } else {
                        CustomSnackBar.showError(
                          context,
                          provider.errorMessage ?? 'Monitor not found',
                        );
                      }
                    },
                    leftIcon: 'assets/icons/search.png',
                  ),
          ],
        ),
      ),
    );
  }
}
