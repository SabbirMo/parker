import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';

class CustomBottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isMonitorView;

  const CustomBottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.isMonitorView = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(22.r),
          topRight: Radius.circular(22.r),
        ),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: isMonitorView
            ? [
                _buildNavItem(0, 'assets/svg/home.svg', 'Home'),
                _buildNavItem(1, 'assets/svg/person.svg', 'Patients'),
                _buildNavItem(
                  2,
                  'assets/svg/notification.svg',
                  'Notifications',
                ),
                _buildNavItem(3, 'assets/svg/setting.svg', 'Settings'),
              ]
            : [
                _buildNavItem(0, 'assets/svg/home.svg', 'Home'),
                _buildNavItem(1, 'assets/svg/medicine.svg', 'Medicines'),
                _buildNavItem(2, 'assets/svg/person.svg', 'Monitors'),
                _buildNavItem(3, 'assets/svg/setting.svg', 'Settings'),
              ],
      ),
    );
  }

  Widget _buildNavItem(int index, String svgPath, String label) {
    final bool isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 4.h),
              decoration: isSelected
                  ? BoxDecoration(
                      color: AppColors.appBottomColor,
                      borderRadius: BorderRadius.circular(16.r),
                    )
                  : null,
              child: SvgPicture.asset(
                svgPath,
                width: 26.sp,
                height: 26.sp,
                colorFilter: ColorFilter.mode(
                  isSelected ? AppColors.appIconColor : AppColors.grey,
                  BlendMode.srcIn,
                ),
              ),
            ),

            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                color: isSelected ? AppColors.black : AppColors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
