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
import 'package:parker_touch/core/widget/snack_bar.dart';
import 'package:parker_touch/provider/auth/login_provider/login_provider.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      _emailController.text = loginProvider.email ?? '';
      _roleController.text = loginProvider.role ?? '';
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  bool _isUploadingImage = false;

  Future<void> _pickImage() async {
    try {
      final XFile? pickedImage = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedImage != null) {
        setState(() {
          _selectedImage = File(pickedImage.path);
          _isUploadingImage = true;
        });

        // PROVIDER CALL HERE
        final loginProvider = Provider.of<LoginProvider>(
          context,
          listen: false,
        );

        bool success = await loginProvider.uploadProfilePicture(
          _selectedImage!,
        );

        setState(() {
          _isUploadingImage = false;
        });

        if (success) {
          CustomSnackBar.showSuccess(context, "Image uploaded successfully");
          debugPrint("Image uploaded successfully");
        } else {
          CustomSnackBar.showError(context, "Image upload failed");
          debugPrint("Image upload failed");
        }
      }
    } catch (e) {
      setState(() {
        _isUploadingImage = false;
      });
      debugPrint("Error picking image: $e");
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
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
                              image: AssetImage('assets/icons/person.png'),
                            ),
                      border: Border.all(color: AppColors.login, width: 4.w),
                    ),
                    child: _isUploadingImage
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          )
                        : null,
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
                      controller: _fullNameController,
                      borderColor: AppColors.textFieldBorderColor,
                      bgColor: AppColors.textFieldBgColor,
                    ),
                    AppSpacing.h4,
                    CustomTextfield(
                      text: 'Email',
                      hintText: '',
                      controller: _emailController,
                      borderColor: AppColors.textFieldBorderColor,
                      bgColor: Color(0xff5E5D5D).withValues(alpha: 0.1),
                      enabled: false,
                    ),
                    AppSpacing.h4,
                    CustomTextfield(
                      text: 'Age',
                      hintText: '27 years old',
                      controller: _ageController,
                      borderColor: AppColors.textFieldBorderColor,
                      bgColor: AppColors.textFieldBgColor,
                    ),
                    AppSpacing.h4,
                    CustomTextfield(
                      text: 'Account Type',
                      hintText: '',
                      controller: _roleController,
                      borderColor: AppColors.textFieldBorderColor,
                      bgColor: Color(0xff5E5D5D).withValues(alpha: 0.1),
                      enabled: false,
                    ),
                    AppSpacing.h38,

                    Consumer<LoginProvider>(
                      builder: (context, editProfile, child) =>
                          editProfile.isLoading
                          ? CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            )
                          : CustomButton(
                              text: 'Save',
                              onTap: () async {
                                final fullName = _fullNameController.text
                                    .trim();
                                final age = int.parse(
                                  _ageController.text.trim(),
                                );

                                final success = await editProfile.editProfile(
                                  fullName,
                                  age,
                                );
                                if (success) {
                                  CustomSnackBar.showSuccess(
                                    context,
                                    'Profile updated successfully',
                                  );
                                } else {
                                  CustomSnackBar.showError(
                                    context,
                                    'Failed to update profile',
                                  );
                                }
                              },
                            ),
                    ),
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
