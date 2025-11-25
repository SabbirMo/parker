import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/app_string.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/back_button.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'package:parker_touch/core/widget/snack_bar.dart';
import 'package:parker_touch/provider/monitor_provider.dart/post_method/patient_connect_provider.dart';
import 'package:provider/provider.dart';

class ConntextPotientSend extends StatelessWidget {
  const ConntextPotientSend({
    super.key,
    this.patientId,
    this.fullName,
    this.email,
    this.username,
    this.imageUrl,
  });

  final int? patientId;
  final String? fullName;
  final String? email;
  final String? username;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PatientConnectProvider>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
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
                backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
                    ? NetworkImage(imageUrl!)
                    : AssetImage('assets/images/womanFace.png')
                          as ImageProvider,
              ),
            ),
            AppSpacing.h16,
            Align(
              child: Text(
                fullName ?? 'Sarah benwestrith',
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
            provider.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  )
                : CustomButton(
                    text: 'Send Request',
                    onTap: () async {
                      if (patientId == null) {
                        CustomSnackBar.showError(
                          context,
                          'Monitor ID not found',
                        );
                        return;
                      }

                      bool result = await provider.sendPatientRequest(
                        patientId!,
                      );

                      if (result) {
                        CustomSnackBar.showSuccess(
                          context,
                          'Request sent successfully',
                        );
                        Navigator.pop(context);
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
