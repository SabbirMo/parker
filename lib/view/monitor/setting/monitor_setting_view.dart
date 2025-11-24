import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'package:parker_touch/provider/auth/login_provider/login_provider.dart';
import 'package:parker_touch/view/choose%20user/choose_user.dart';
import 'package:parker_touch/view/monitor/edit_profile/edit_profile.dart';
import 'package:parker_touch/view/monitor/privacy_setting/privacy_setting.dart';
import 'package:parker_touch/view/patient/settings/potient_setting.dart';
import 'package:parker_touch/view/patient/settings/privacy_policy.dart';
import 'package:parker_touch/view/patient/settings/team_condition.dart';
import 'package:provider/provider.dart';

class MonitorSettingView extends StatefulWidget {
  const MonitorSettingView({super.key});

  @override
  State<MonitorSettingView> createState() => _MonitorSettingViewState();
}

class _MonitorSettingViewState extends State<MonitorSettingView> {
  bool pushNotification = true;
  bool voiceNotification = true;

  @override
  void initState() {
    super.initState();
    // Fetch latest user data when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<LoginProvider>(context, listen: false);
      provider.fetchUserProfile();
    });
  }

  Future<void> _navigateToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditProfile()),
    );

    // If profile was updated, refresh the data
    if (result == true && mounted) {
      final provider = Provider.of<LoginProvider>(context, listen: false);
      await provider.fetchUserProfile();
    }
  }

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
                onTap: _navigateToEditProfile,
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
                          Consumer<LoginProvider>(
                            builder: (context, uploadProfile, child) =>
                                ClipOval(
                                  child: Container(
                                    width: 50.w,
                                    height: 50.h,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withValues(alpha: 0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: uploadProfile.profilePicture != null
                                        ? Image.network(
                                            uploadProfile.profilePicture!,
                                            fit: BoxFit.cover,
                                          )
                                        : Padding(
                                            padding: EdgeInsets.all(12),
                                            child: Image.asset(
                                              'assets/icons/person.png',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                  ),
                                ),
                          ),
                          AppSpacing.w20,
                          Expanded(
                            child: Consumer<LoginProvider>(
                              builder: (context, loginProvider, child) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      loginProvider.fullName ?? "Enola Parker",
                                      style: FontManager.loginStyle.copyWith(
                                        fontSize: 20.sp,
                                        color: AppColors.black1,
                                      ),
                                    ),
                                    Text(
                                      loginProvider.email ?? 'enola@gmail.com',
                                      style: FontManager.contSubTitle,
                                    ),
                                  ],
                                );
                              },
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
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Logout', textAlign: TextAlign.center),
                        content: Text(
                          'Are you sure you want to logout?',
                          textAlign: TextAlign.center,
                        ),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  side: BorderSide(
                                    color: AppColors.primaryColor,
                                    width: 1,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(color: AppColors.back),
                                ),
                              ),
                              FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  side: BorderSide(
                                    color: AppColors.primaryColor,
                                    width: 1,
                                  ),
                                ),
                                onPressed: () async {
                                  final provider = Provider.of<LoginProvider>(
                                    context,
                                    listen: false,
                                  );
                                  provider.logout();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ChooseUser(),
                                    ),
                                  );
                                },
                                child: Text('Logout'),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
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

// class RowWidgetCart extends StatelessWidget {
//   const RowWidgetCart({
//     super.key,
//     required this.title,
//     this.color,
//     this.icon,
//     this.iconColor,
//     this.isSelected = true,
//   });

//   final String title;
//   final Color? color;
//   final IconData? icon;
//   final Color? iconColor;
//   final bool isSelected;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title,
//           style: FontManager.loginStyle.copyWith(
//             color: color ?? AppColors.optBlue,
//           ),
//         ),
//         if (isSelected != false)
//           Icon(Icons.arrow_forward_ios, color: iconColor ?? AppColors.optBlue),
//       ],
//     );
//   }
// }
