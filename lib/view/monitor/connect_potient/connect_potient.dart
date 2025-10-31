import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/app_string.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/back_button.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'package:parker_touch/core/widget/custom_textfield.dart';
import 'package:parker_touch/view/monitor/connect_potient/conntext_potient_send.dart';

class ConnectPotient extends StatelessWidget {
  const ConnectPotient({super.key});

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
              Text(AppString.connectAPotient, style: FontManager.connect),
              AppSpacing.h4,
              Text(
                AppString.connectAPotientSubtitle,
                style: FontManager.connectPotient,
              ),
              AppSpacing.h24,

              CustomTextfield(
                text: 'Patient’s Email or User name',
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
                      builder: (context) => ConntextPotientSend(),
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
