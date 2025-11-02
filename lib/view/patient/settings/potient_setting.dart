import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'package:parker_touch/core/widget/free_trial_container.dart';
import 'package:parker_touch/view/choose%20user/choose_user.dart';
import 'package:parker_touch/view/monitor/edit_profile/edit_profile.dart';
import 'package:parker_touch/view/monitor/privacy_setting/privacy_setting.dart';
import 'package:parker_touch/view/patient/settings/privacy_policy.dart';
import 'package:parker_touch/view/patient/settings/team_condition.dart';

class PotientSetting extends StatefulWidget {
  const PotientSetting({super.key});

  @override
  State<PotientSetting> createState() => _PotientSettingState();
}

class _PotientSettingState extends State<PotientSetting> {
  bool pushNotification = true;
  bool voiceNotification = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpacing.h40,
              Text('Settings', style: FontManager.connect),
              AppSpacing.h10,
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfile()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(width: 1, color: AppColors.borderColor),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Image.asset('assets/icons/person.png'),
                            ),
                          ),
                          AppSpacing.w20,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Enola Parker",
                                  style: FontManager.loginStyle.copyWith(
                                    fontSize: 20.sp,
                                    color: AppColors.black1,
                                  ),
                                ),
                                Text(
                                  'enola@gmail.com',
                                  style: FontManager.contSubTitle,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.h14,
                      RowWidgetCart(title: "Edit Profile"),
                    ],
                  ),
                ),
              ),

              AppSpacing.h14,
              ContainerRowButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PrivacySetting()),
                  );
                },
                child: RowWidgetCart(
                  title: "Privacy Setting",
                  color: AppColors.black1,
                  isSelected: false,
                ),
              ),
              AppSpacing.h14,
              const FreeTrialContainer(),
              AppSpacing.h14,
              ContainerRowButton(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/icons/notification.png'),
                        AppSpacing.w8,
                        Text(
                          'Notifications',
                          style: FontManager.loginStyle.copyWith(
                            fontSize: 20.sp,
                            color: AppColors.black1,
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.h10,
                    switchNotification(
                      'Push notification',
                      'Receive medication reminder',
                      pushNotification,
                      (value) => setState(() => pushNotification = value),
                    ),
                    AppSpacing.h6,
                    Divider(),
                    AppSpacing.h6,
                    switchNotification(
                      'Voice reminder',
                      'AI voice notification',
                      voiceNotification,
                      (value) => setState(() => voiceNotification = value),
                    ),
                  ],
                ),
              ),
              AppSpacing.h14,
              ContainerRowButton(
                child: Column(
                  children: [
                    RowWidgetCart(
                      title: "Privacy policy",
                      color: AppColors.black1,
                      iconColor: AppColors.black1,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PrivacyPolicy(),
                          ),
                        );
                      },
                    ),
                    AppSpacing.h6,
                    Divider(),
                    AppSpacing.h6,
                    RowWidgetCart(
                      title: 'Terms of service',
                      color: AppColors.black1,
                      iconColor: AppColors.black1,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TeamCondition(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              AppSpacing.h32,
              CustomButton(
                text: "LogOut",
                leftIcon: 'assets/icons/logout.png',
                bgColor: Color(0xfffec3c9),
                textColor: AppColors.cColor2,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => ChooseUser()),
                  );
                },
              ),
              AppSpacing.h18,
            ],
          ),
        ),
      ),
    );
  }

  Widget switchNotification(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onTap,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: FontManager.bodyText3.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(subtitle, style: FontManager.bodyText4),
          ],
        ),
        CustomSwitch(
          value: value,
          onChanged: (value) {
            setState(() {
              onTap(value);
            });
          },
        ),
      ],
    );
  }
}

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 50,
        height: 28,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: value ? Colors.blue : Colors.grey.shade400,
        ),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContainerRowButton extends StatelessWidget {
  const ContainerRowButton({super.key, required this.child, this.onTap});

  final Widget child;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(width: 1, color: AppColors.borderColor),
        ),
        child: child,
      ),
    );
  }
}

class RowWidgetCart extends StatelessWidget {
  const RowWidgetCart({
    super.key,
    required this.title,
    this.color,
    this.icon,
    this.iconColor,
    this.isSelected = true,
    this.onTap,
  });

  final String title;
  final Color? color;
  final IconData? icon;
  final Color? iconColor;
  final bool isSelected;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: AppColors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: FontManager.loginStyle.copyWith(
                color: color ?? AppColors.optBlue,
              ),
            ),
            if (isSelected != false)
              Icon(
                Icons.arrow_forward_ios,
                color: iconColor ?? AppColors.optBlue,
              ),
          ],
        ),
      ),
    );
  }
}
