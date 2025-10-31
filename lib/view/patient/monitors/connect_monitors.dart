import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/app_string.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/back_button.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'package:parker_touch/core/widget/custom_textfield.dart';
import 'package:parker_touch/view/patient/monitors/connect_monitors_send.dart';

class ConnectMonitors extends StatelessWidget {
  const ConnectMonitors({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                controller: _controller,
                borderColor: AppColors.textFieldBorderColor,
                bgColor: AppColors.textFieldBgColor,
              ),
              AppSpacing.h24,

              Align(
                child: _controller.text.isNotEmpty
                    ? Text(
                        'User Not Found! search again',
                        style: FontManager.bodyText.copyWith(fontSize: 16.sp),
                      )
                    : Container(),
              ),

              AppSpacing.h24,

              CustomButton(
                text: 'Search',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConnectMonitorsSend(),
                    ),
                  );
                },
                leftIcon: 'assets/icons/search.png',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
