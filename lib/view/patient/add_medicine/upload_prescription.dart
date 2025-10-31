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
import 'dart:io';

import 'package:parker_touch/view/patient/add_medicine/confirm_medicine.dart';

class UploadPrescription extends StatefulWidget {
  const UploadPrescription({super.key});

  @override
  State<UploadPrescription> createState() => _UploadPrescriptionState();
}

class _UploadPrescriptionState extends State<UploadPrescription> {
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _pickedImage = image;
        });
      }
    } catch (e) {
      // Handle error
      print("Error picking image: $e");
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 40.h,
                      ),
                      decoration: BoxDecoration(color: AppColors.white),
                      child: Column(
                        children: [
                          _pickedImage != null
                              ? Image.file(
                                  File(_pickedImage!.path),
                                  height: 100.h,
                                  width: 100.w,
                                  fit: BoxFit.cover,
                                )
                              : SvgPicture.asset('assets/svg/upload.svg'),
                          AppSpacing.h16,
                          Text(
                            _pickedImage != null
                                ? "Image Selected"
                                : "Drag and drop or browse your Photo",
                            style: FontManager.bodyText5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              AppSpacing.h36,
              CustomButton(
                text: "Scan Prescription",
                // onTap: _pickedImage != null
                //     ? () {
                //         // Handle scan prescription logic here
                //       }
                //     : null,
                // bgColor: _pickedImage != null
                //     ? AppColors.primaryColor
                //     : AppColors.grey, // Gray color when disabled
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ConfirmMedicine()),
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
