import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/back_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'dart:io';

import 'package:parker_touch/core/widget/custom_textfield.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedImage = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedImage != null) {
        setState(() {
          _selectedImage = File(pickedImage.path);
        });
      }
    } catch (e) {
      // Handle any errors here
      print("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            CustomBackButton(),
            AppSpacing.h12,
            Text("Edit Profile", style: FontManager.connect),
            AppSpacing.h8,
            Align(
              alignment: Alignment.center,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 100.w,
                    height: 100.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: _selectedImage != null
                          ? DecorationImage(
                              image: FileImage(_selectedImage!),
                              fit: BoxFit.cover,
                            )
                          : DecorationImage(
                              image: AssetImage('assets/images/image.png'),
                              fit: BoxFit.cover,
                            ),
                      border: Border.all(color: AppColors.login, width: 4.w),
                    ),
                  ),
                  Positioned(
                    right: -2,
                    bottom: 16.h,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.login,
                        ),
                        child: Image.asset('assets/icons/pan.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.h12,
            // Scrollable content section
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomTextfield(
                      text: 'Full Name',
                      hintText: 'Enola Parker',
                      borderColor: AppColors.textFieldBorderColor,
                      bgColor: AppColors.textFieldBgColor,
                    ),
                    AppSpacing.h4,
                    CustomTextfield(
                      text: 'Email',
                      hintText: 'example@email.com',
                      borderColor: AppColors.textFieldBorderColor,
                      bgColor: AppColors.textFieldBgColor,
                    ),
                    AppSpacing.h4,
                    CustomTextfield(
                      text: 'Age',
                      hintText: '27 years old',
                      borderColor: AppColors.textFieldBorderColor,
                      bgColor: AppColors.textFieldBgColor,
                    ),
                    AppSpacing.h4,
                    CustomTextfield(
                      text: 'Account Type',
                      hintText: 'Monitor',
                      borderColor: AppColors.textFieldBorderColor,
                      bgColor: Color(0xff5E5D5D).withValues(alpha: 0.1),
                      enabled: false,
                    ),
                    AppSpacing.h38,

                    CustomButton(text: 'Save', onTap: () {}),
                    AppSpacing.h16, // Add some spacing at the bottom
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
