import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/app_string.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/back_button.dart';
import 'package:parker_touch/core/widget/custom_button.dart';

class ConnectMonitorsSend extends StatelessWidget {
  const ConnectMonitorsSend({super.key, this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
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
              AppSpacing.h26,

              Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 54.r,
                  backgroundImage: AssetImage('assets/images/jhon.png'),
                ),
              ),
              AppSpacing.h16,
              Align(
                child: Text(
                  'John Parker',
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
              CustomButton(
                text: 'Send Request',
                onTap: () {},
                leftIcon: 'assets/icons/send.png',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
