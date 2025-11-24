import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/back_button.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parker_touch/core/widget/snack_bar.dart';
import 'package:parker_touch/provider/auth/upload_prescription/upload_prescrition_provider.dart';
import 'dart:io';

import 'package:parker_touch/view/patient/add_medicine/confirm_medicine.dart';
import 'package:provider/provider.dart';

class UploadPrescription extends StatefulWidget {
  const UploadPrescription({super.key});

  @override
  State<UploadPrescription> createState() => _UploadPrescriptionState();
}

class _UploadPrescriptionState extends State<UploadPrescription> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  bool _isUploadingImage = false;
  bool _isNavigating = false;

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

        final uploadPrescription = Provider.of<UploadPrescriptionProvider>(
          context,
          listen: false,
        );

        bool success = await uploadPrescription.uploadPrescription(
          _selectedImage!,
        );
        setState(() {
          _isUploadingImage = false;
        });
        if (success) {
          CustomSnackBar.showSuccess(context, "Image uploaded successfully");
          debugPrint("Image uploaded successfully");
        } else {
          final errorMsg =
              uploadPrescription.errorMessage ?? "Image upload failed";
          CustomSnackBar.showError(context, errorMsg);
          debugPrint("Image upload failed: $errorMsg");
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomBackButton(),
              AppSpacing.h12,
              Text('Add Medicine', style: FontManager.connect),
              AppSpacing.h26,
              Text(
                'Upload your prescription',
                style: FontManager.contTitle.copyWith(
                  color: Color(0xff303030),
                  fontSize: 16.sp,
                ),
              ),
              AppSpacing.h20,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GestureDetector(
                  onTap: _pickImage,
                  child: DottedBorder(
                    color: AppColors.black1,
                    strokeWidth: 1,
                    dashPattern: [10, 5],
                    borderType: BorderType.RRect,
                    radius: Radius.circular(4),
                    child: Container(
                      width: double.infinity,
                      height: 200.h,
                      decoration: _selectedImage != null
                          ? BoxDecoration(
                              color: AppColors.white,
                              image: DecorationImage(
                                image: FileImage(_selectedImage!),
                                fit: BoxFit.contain,
                              ),
                            )
                          : BoxDecoration(color: AppColors.white),
                      child: _selectedImage != null
                          ? (_isUploadingImage
                                ? Container(
                                    color: Colors.black45,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.white,
                                      ),
                                    ),
                                  )
                                : null)
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 40.h,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset('assets/svg/upload.svg'),
                                  AppSpacing.h16,
                                  Text(
                                    "Drag and drop or browse your Photo",
                                    style: FontManager.bodyText5,
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              AppSpacing.h36,
              Consumer<UploadPrescriptionProvider>(
                builder: (context, uploadProvider, child) {
                  return _isUploadingImage || _isNavigating
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        )
                      : CustomButton(
                          text: "Scan Prescription",
                          onTap: _selectedImage != null
                              ? () async {
                                  if (_isNavigating) return;

                                  debugPrint(
                                    "Scanned medicines count: ${uploadProvider.scannedMedicines?.length ?? 0}",
                                  );

                                  if (uploadProvider.scannedMedicines != null &&
                                      uploadProvider
                                          .scannedMedicines!
                                          .isNotEmpty) {
                                    setState(() {
                                      _isNavigating = true;
                                    });

                                    debugPrint(
                                      "Navigating to ConfirmMedicine with ${uploadProvider.scannedMedicines!.length} medicines",
                                    );

                                    // Give UI time to show loading
                                    await Future.delayed(
                                      Duration(milliseconds: 300),
                                    );

                                    if (!mounted) return;

                                    setState(() {
                                      _isNavigating = false;
                                    });

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ConfirmMedicine(
                                          medicines:
                                              uploadProvider.scannedMedicines,
                                        ),
                                      ),
                                    );
                                  } else {
                                    debugPrint("No scanned medicines found");
                                    CustomSnackBar.showError(
                                      context,
                                      'No medicines found in the prescription. Please try uploading again.',
                                    );
                                  }
                                }
                              : null,
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
