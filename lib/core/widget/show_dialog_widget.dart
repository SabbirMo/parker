import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'package:parker_touch/view/patient/add_medicine/add_medicine.dart';

class ShowDialogWidget extends StatefulWidget {
  const ShowDialogWidget({super.key});

  @override
  _ShowDialogWidgetState createState() => _ShowDialogWidgetState();
}

class _ShowDialogWidgetState extends State<ShowDialogWidget> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _openCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MedicineVerifyScreen(imagePath: photo.path),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        height: size.height * 0.65,
        padding: EdgeInsets.all(22.r),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 22.r,
              backgroundColor: AppColors.appBottomColor,
              child: Image.asset('assets/icons/music.png'),
            ),
            AppSpacing.h16,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/icons/sound.png'),
                AppSpacing.w10,
                Text(
                  "Ai Voice Active",
                  style: FontManager.loginStyle.copyWith(
                    color: AppColors.vColor,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
            AppSpacing.h10,
            Text(
              "It's time for your medicine!",
              style: FontManager.contTitle.copyWith(
                fontSize: 22.sp,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.h10,
            Text(
              "Mdecine",
              style: FontManager.loginStyle.copyWith(
                fontSize: 14.sp,
                color: AppColors.text,
              ),
            ),
            AppSpacing.h4,
            Text('Aspirin', style: FontManager.titleStyle),
            AppSpacing.h6,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '50 mg',
                  style: FontManager.loginStyle.copyWith(
                    fontSize: 12.sp,
                    color: AppColors.text,
                  ),
                ),
                AppSpacing.w10,
                Text(
                  '8:30 PM',
                  style: FontManager.loginStyle.copyWith(
                    fontSize: 12.sp,
                    color: AppColors.login,
                  ),
                ),
              ],
            ),
            AppSpacing.h10,
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: AppColors.cColor,
                border: Border.all(width: 1, color: AppColors.borderColor),
                borderRadius: BorderRadius.circular(13.r),
              ),
              child: Text(
                'Hey Parker, Its time to take your aspirin!',
                style: FontManager.loginStyle.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.black1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            AppSpacing.h16,
            CustomButton(
              text: "TAKEN MEDICINE",
              onTap: () {},
              bgColor: AppColors.green,
              leftIcon: 'assets/icons/right.png',
              isBoxShadow: false,
            ),
            AppSpacing.h10,
            CustomButton(
              text: "MATCH MEDICINE",
              onTap: _openCamera,
              leftIcon: 'assets/icons/camera.png',
              isBoxShadow: false,
            ),
            AppSpacing.h20,
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Remind me later",
                style: FontManager.loginStyle.copyWith(
                  fontSize: 14.sp,
                  color: Color(0xff6C6C6C),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MedicineVerifyScreen extends StatelessWidget {
  final String imagePath;
  const MedicineVerifyScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF072B4E),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Header Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Verify Your Medicine",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white70),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Image Preview Box
              Container(
                width: 250,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white24, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(File(imagePath), fit: BoxFit.cover),
                ),
              ),

              const SizedBox(height: 20),

              // Match Info
              Column(
                children: const [
                  Icon(Icons.check_circle, color: Colors.green, size: 40),
                  SizedBox(height: 8),
                  Text(
                    "Perfect match!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "That is correct medicine!",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                "Verifying : Aspirin (50 mg)",
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),

              const SizedBox(height: 25),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomButton(
                  text: "CONFIRM & TAKEN MEDICINE",
                  bgColor: AppColors.green,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddMedicine()),
                    );
                  },
                  isBoxShadow: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
