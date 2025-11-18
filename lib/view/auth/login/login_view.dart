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
import 'package:parker_touch/provider/auth/login_provider/login_provider.dart';
import 'package:parker_touch/view/auth/forgot/forgot_password.dart';
import 'package:parker_touch/view/choose%20user/choose_user.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: SvgPicture.asset(
                  SvgAssets.top,
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context).size.width * 0.4,
                ),
              ),
              Positioned(top: 50, left: 20, child: CustomBackButton()),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
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
                        Text(AppString.login, style: FontManager.titleStyle),
                        Text(
                          AppString.account,
                          style: FontManager.subtitle.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                        AppSpacing.h12,
                        CustomTextfield(
                          text: AppString.email,
                          hintText: AppString.hintEmailAddress,
                          controller: _emailController,
                        ),
                        CustomTextfield(
                          text: AppString.password,
                          hintText: AppString.hintPassword,
                          icon: provider.password
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          onIconPressed: () {
                            provider.togglePassword();
                          },
                          obscureText: provider.password,
                          controller: _passwordController,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ForgotPassword(),
                              ),
                            );
                          },
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              AppString.forgot,
                              style: FontManager.subtitle.copyWith(
                                color: AppColors.grey,
                              ),
                            ),
                          ),
                        ),
                        AppSpacing.h10,
                        provider.isloading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                ),
                              )
                            : CustomButton(
                                text: "Login",
                                onTap: () async {
                                  final email = _emailController.text.trim();
                                  final password = _passwordController.text
                                      .trim();

                                  if (email.isEmpty || password.isEmpty) {
                                    CustomSnackBar.showError(
                                      context,
                                      'Please fill in all fields',
                                    );
                                    return;
                                  }

                                  final result = await provider.loginUser(
                                    email,
                                    password,
                                  );
                                  if (result != null) {
                                    CustomSnackBar.showSuccess(
                                      context,
                                      'Login successful',
                                    );

                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (_) => PatientView(),
                                    //   ),
                                    // );
                                    // Navigate to the next screen or perform other actions
                                  } else {
                                    CustomSnackBar.showError(
                                      context,
                                      'Login failed. Please check your credentials.',
                                    );
                                  }
                                },
                              ),
                        AppSpacing.h10,
                        Align(
                          child: Text(
                            AppString.dontHave,
                            style: FontManager.loginStyle.copyWith(
                              color: AppColors.patient,
                              fontSize: 14.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        AppSpacing.h2,
                        Align(
                          child: InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => ChooseUser()),
                              );
                            },
                            child: Text(
                              AppString.create,
                              style: FontManager.loginStyle.copyWith(
                                color: AppColors.login,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: SvgPicture.asset(SvgAssets.bottom, fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }
}
