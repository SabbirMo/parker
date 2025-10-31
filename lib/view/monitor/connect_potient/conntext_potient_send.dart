import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/app_string.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/back_button.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'package:parker_touch/view/monitor/connect_potient/medicine_potient.dart';

class ConntextPotientSend extends StatelessWidget {
  const ConntextPotientSend({super.key, this.email});

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
              Text(AppString.connectAPotient, style: FontManager.connect),
              AppSpacing.h4,
              Text(
                AppString.connectAPotientSubtitle,
                style: FontManager.connectPotient,
              ),
              AppSpacing.h26,

              Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 54.r,
                  backgroundImage: AssetImage('assets/images/womanFace.png'),
                ),
              ),
              AppSpacing.h16,
              Align(
                child: Text(
                  'Sarah benwestrith',
                  style: FontManager.contTitle,
                  textAlign: TextAlign.center,
                ),
              ),
              AppSpacing.h4,
              Align(
                child: Text(
                  email ?? 'sarah@gmail.com',
                  style: FontManager.contSubTitle,
                ),
              ),

              AppSpacing.h32,
              CustomButton(
                text: 'Send Request',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MedicinePotient(email: email),
                    ),
                  );
                },
                leftIcon: 'assets/icons/send.png',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
