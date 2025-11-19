import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/back_button.dart';
import 'package:parker_touch/view/patient/add_medicine/add_manually_screen.dart';
import 'package:parker_touch/view/patient/add_medicine/upload_prescription.dart';

class AddMedicine extends StatelessWidget {
  const AddMedicine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            CustomBackButton(),
            AppSpacing.h12,
            Text('Add Medicine', style: FontManager.connect),
            AppSpacing.h12,
            AddMedicineContainer(
              text: "Upload Prescription",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadPrescription()),
                );
              },
            ),
            AppSpacing.h12,
            AddMedicineContainer(
              text: "Add Manually",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddManuallyScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AddMedicineContainer extends StatelessWidget {
  const AddMedicineContainer({
    super.key,
    required this.onTap,
    required this.text,
  });

  final VoidCallback onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 22),
        decoration: BoxDecoration(
          color: AppColors.login,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: FontManager.contTitle.copyWith(
                fontSize: 18.sp,
                color: AppColors.white,
              ),
            ),
            Icon(Icons.arrow_forward, size: 26.sp, color: AppColors.white),
          ],
        ),
      ),
    );
  }
}
