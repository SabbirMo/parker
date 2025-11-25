import 'package:flutter/material.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/app_string.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/back_button.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'package:parker_touch/core/widget/custom_textfield.dart';
import 'package:parker_touch/core/widget/snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:parker_touch/provider/monitor_provider.dart/post_method/patient_connect_provider.dart';
import 'package:parker_touch/view/monitor/connect_potient/conntext_potient_send.dart';

class ConnectPotient extends StatefulWidget {
  const ConnectPotient({super.key});

  @override
  State<ConnectPotient> createState() => _ConnectPotientState();
}

class _ConnectPotientState extends State<ConnectPotient> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final patientConnectProvider = Provider.of<PatientConnectProvider>(context);
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
            AppSpacing.h24,

            CustomTextfield(
              text: 'Patient’s Email or User name',
              hintText: 'user name or email',
              isSelected: false,
              controller: controller,
              borderColor: AppColors.textFieldBorderColor,
              bgColor: AppColors.textFieldBgColor,
            ),
            AppSpacing.h24,

            patientConnectProvider.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  )
                : CustomButton(
                    text: 'Search',
                    onTap: () async {
                      final email = controller.text.trim();

                      if (email.isEmpty) {
                        CustomSnackBar.showError(
                          context,
                          'Please enter email or username',
                        );
                        return;
                      }

                      final result = await patientConnectProvider
                          .searchToPatient(email);

                      if (result) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConntextPotientSend(
                              patientId:
                                  patientConnectProvider.patientData?['id'],
                              fullName: patientConnectProvider
                                  .patientData?['full_name'],
                              email:
                                  patientConnectProvider.patientData?['email'],
                              username: patientConnectProvider
                                  .patientData?['username'],
                              imageUrl: patientConnectProvider
                                  .patientData?['profile_image'],
                            ),
                          ),
                        );
                      } else {
                        CustomSnackBar.showError(
                          context,
                          patientConnectProvider.errorMessage ??
                              'Patient not found',
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
