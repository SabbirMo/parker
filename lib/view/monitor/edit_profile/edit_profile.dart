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

  bool get _isMonitor {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    return loginProvider.role == 'monitor';
  }

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
                    // Hide Age field if user is a monitor
                    if (!_isMonitor) ...[
                      CustomTextfield(
                        text: 'Age',
                        hintText: '27 years old',
                        controller: _ageController,
                        borderColor: AppColors.textFieldBorderColor,
                        bgColor: AppColors.textFieldBgColor,
                      ),
                      AppSpacing.h4,
                    ],
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

                                if (fullName.isEmpty) {
                                  CustomSnackBar.showError(
                                    context,
                                    'Please enter your full name',
                                  );
                                  return;
                                }

                                // Only get age if not monitor
                                int age;
                                if (!_isMonitor) {
                                  final ageText = _ageController.text.trim();
                                  if (ageText.isEmpty) {
                                    CustomSnackBar.showError(
                                      context,
                                      'Please enter your age',
                                    );
                                    return;
                                  }
                                  age = int.tryParse(ageText) ?? 0;
                                  if (age == 0) {
                                    CustomSnackBar.showError(
                                      context,
                                      'Please enter a valid age',
                                    );
                                    return;
                                  }
                                } else {
                                  // For monitor, use age 1 (backend might reject 0)
                                  age = 1;
                                }

                                debugPrint(
                                  'Updating profile: fullName=$fullName, age=$age, isMonitor=$_isMonitor',
                                );

                                final success = await editProfile.editProfile(
                                  fullName,
                                  age,
                                );

                                debugPrint('Profile update result: $success');

                                if (success) {
                                  CustomSnackBar.showSuccess(
                                    context,
                                    'Profile updated successfully',
                                  );
                                  // Navigate back after successful update
                                  await Future.delayed(
                                    Duration(milliseconds: 500),
                                  );
                                  if (context.mounted) {
                                    Navigator.pop(
                                      context,
                                      true,
                                    ); // Return true to indicate success
                                  }
                                } else {
                                  final errorMsg =
                                      editProfile.errorMessage ??
                                      'Failed to update profile';
                                  debugPrint('Error message: $errorMsg');
                                  CustomSnackBar.showError(context, errorMsg);
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
