import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/app_string.dart';
import 'package:parker_touch/core/constants/assets_manager.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/back_button.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'package:parker_touch/core/widget/custom_textfield.dart';
import 'package:parker_touch/core/widget/snack_bar.dart';
import 'package:parker_touch/provider/auth/signup_provider/patient_provider.dart';
import 'package:parker_touch/view/auth/login/login_view.dart';
import 'package:parker_touch/view/auth/otp/otp_verification.dart';
import 'package:provider/provider.dart';

class PatientSignUp extends StatefulWidget {
  const PatientSignUp({super.key});

  @override
  State<PatientSignUp> createState() => _PatientSignUpState();
}

class _PatientSignUpState extends State<PatientSignUp> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    ageController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PatientProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: SvgPicture.asset(
              SvgAssets.top,
              fit: BoxFit.contain,
              width: MediaQuery.of(context).size.width * 0.4,
            ),
          ),

          Positioned(top: 50, left: 20, child: CustomBackButton()),
          Positioned(
            bottom: 0,
            child: SvgPicture.asset(SvgAssets.bottom, fit: BoxFit.contain),
          ),

          Positioned(
            top: 98.h,
            bottom: 0,
            left: 0,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.92,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.loginCont.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xffd6d9dd)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.createAccount,
                      style: FontManager.titleStyle,
                    ),
                    Text(
                      AppString.singUp,
                      style: FontManager.subtitle.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    AppSpacing.h12,
                    Column(
                      children: [
                        CustomTextfield(
                          controller: nameController,
                          text: AppString.fullName,
                          hintText: AppString.hintFullName,
                        ),
                        CustomTextfield(
                          controller: emailController,
                          text: AppString.email,
                          hintText: AppString.hintEmailAddress,
                        ),
                        CustomTextfield(
                          controller: ageController,
                          text: AppString.age,
                          hintText: 'Enter your age',
                          keyboardType: TextInputType.number,
                        ),
                        CustomTextfield(
                          controller: passwordController,
                          text: AppString.password,
                          hintText: AppString.hintPassword,
                          icon: provider.password
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          onIconPressed: provider.togglePassword,
                          obscureText: provider.password,
                        ),
                        CustomTextfield(
                          controller: confirmPasswordController,
                          text: AppString.confirmPassword,
                          hintText: AppString.hintPassword,
                          icon: provider.confirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          onIconPressed: provider.toggleConfirmPassword,
                          obscureText: provider.confirmPassword,
                        ),
                        AppSpacing.h10,
                        provider.isloading
                            ? CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              )
                            : CustomButton(
                                text: "Sign Up",
                                onTap: () async {
                                  final name = nameController.text.trim();
                                  final email = emailController.text.trim();
                                  final password = passwordController.text
                                      .trim();
                                  final confirmPassword =
                                      confirmPasswordController.text.trim();
                                  final age = int.tryParse(
                                    ageController.text.trim(),
                                  );

                                  // Validate fields
                                  if (name.isEmpty ||
                                      email.isEmpty ||
                                      age == 0 ||
                                      password.isEmpty ||
                                      confirmPassword.isEmpty) {
                                    CustomSnackBar.showError(
                                      context,
                                      'Please fill in all fields correctly',
                                    );
                                    return;
                                  }

                                  // Validate password match
                                  if (password != confirmPassword) {
                                    CustomSnackBar.showError(
                                      context,
                                      'Passwords do not match',
                                    );
                                    return;
                                  }

                                  final otpToken = await provider.signupPatient(
                                    name,
                                    email,
                                    age ?? 0,
                                    password,
                                    confirmPassword,
                                  );

                                  if (otpToken != null) {
                                    // Navigate to OTP verification screen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => OtpVerification(
                                          otpToken: otpToken,
                                          source: OtpSource.signup,
                                          email: email,
                                        ),
                                      ),
                                    );
                                  } else {
                                    CustomSnackBar.showError(
                                      context,
                                      'Signup failed. Email already exists. Please try again.',
                                    );
                                  }
                                },
                              ),
                      ],
                    ),
                    AppSpacing.h10,
                    Align(
                      child: Text(
                        AppString.patient,
                        style: FontManager.loginStyle.copyWith(
                          color: AppColors.patient,
                          fontSize: 14.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Align(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginView(),
                            ),
                          );
                        },
                        child: Text(
                          AppString.loginHere,
                          style: FontManager.loginStyle.copyWith(
                            color: AppColors.login,
                          ),
                        ),
                      ),
                    ),
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
