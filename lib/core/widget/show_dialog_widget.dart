import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'package:parker_touch/core/widget/snack_bar.dart';
import 'package:parker_touch/provider/auth/login_provider/login_provider.dart';
import 'package:parker_touch/provider/home_provider/home_provider.dart';
import 'package:parker_touch/provider/voice_reminder/voice_reminder_provider.dart';
import 'package:parker_touch/view/patient/home/model/patient_home_model.dart';
import 'package:provider/provider.dart';

class ShowDialogWidget extends StatefulWidget {
  final NextMedicine? nextMedicine;

  const ShowDialogWidget({super.key, this.nextMedicine});

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
          builder: (context) => MedicineVerifyScreen(
            imagePath: photo.path,
            nextMedicine: widget.nextMedicine,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      final userName = loginProvider.fullName ?? 'Parker';
      final medicineName = widget.nextMedicine?.name.toLowerCase() ?? 'aspirin';

      final message =
          'Hey $userName, It\'s time to take your medicine, $medicineName!';

      speak(message);
    });
  }

  final FlutterTts flutterTts = FlutterTts();

  Future<void> speak(String text) async {
    final voiceReminderProvider = Provider.of<VoiceReminderProvider>(
      context,
      listen: false,
    );
    if (!voiceReminderProvider.voiceReminder) return;

    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        padding: EdgeInsets.all(22.r),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
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
            Text(
              widget.nextMedicine?.name ?? 'Aspirin',
              style: FontManager.titleStyle,
            ),
            AppSpacing.h6,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.nextMedicine?.dosage ?? '50 mg',
                  style: FontManager.loginStyle.copyWith(
                    fontSize: 12.sp,
                    color: AppColors.text,
                  ),
                ),
                AppSpacing.w10,
                Text(
                  widget.nextMedicine?.time ?? '8:30 PM',
                  style: FontManager.loginStyle.copyWith(
                    fontSize: 12.sp,
                    color: AppColors.login,
                  ),
                ),
              ],
            ),
            AppSpacing.h10,
            Consumer<LoginProvider>(
              builder: (context, loginProvider, _) {
                final userName = loginProvider.fullName ?? 'Parker';
                return Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: AppColors.cColor,
                    border: Border.all(width: 1, color: AppColors.borderColor),
                    borderRadius: BorderRadius.circular(13.r),
                  ),
                  child: Text(
                    'Hey $userName, It\'s time to take your medicine, ${widget.nextMedicine?.name.toLowerCase() ?? 'aspirin'}!',
                    style: FontManager.loginStyle.copyWith(
                      fontSize: 14.sp,
                      color: AppColors.black1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
            AppSpacing.h16,
            Consumer<HomeProvider>(
              builder: (context, value, _) => CustomButton(
                text: "TAKEN MEDICINE",
                onTap: () async {
                  if (widget.nextMedicine != null) {
                    await value.takeNowMedicine(
                      widget.nextMedicine!.medicineId,
                      widget.nextMedicine!.time,
                    );
                    // Refresh today's summary
                    await value.todaySummaryProgressBar();
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                bgColor: AppColors.green,
                leftIcon: 'assets/icons/right.png',
                isBoxShadow: false,
              ),
            ),
            AppSpacing.h10,
            CustomButton(
              text: "MATCH MEDICINE",
              onTap: _openCamera,
              leftIcon: 'assets/icons/camera.png',
              isBoxShadow: false,
            ),
            AppSpacing.h18,
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

class MedicineVerifyScreen extends StatefulWidget {
  final String imagePath;
  final NextMedicine? nextMedicine;

  const MedicineVerifyScreen({
    super.key,
    required this.imagePath,
    this.nextMedicine,
  });

  @override
  State<MedicineVerifyScreen> createState() => _MedicineVerifyScreenState();
}

class _MedicineVerifyScreenState extends State<MedicineVerifyScreen> {
  bool? isMatched;
  bool isVerifying = true;

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to avoid calling during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _verifyMedicine();
    });
  }

  Future<void> _verifyMedicine() async {
    if (widget.nextMedicine == null) return;

    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    bool result = await homeProvider.verifyMedicineImage(
      widget.imagePath,
      widget.nextMedicine!.medicineId,
    );

    if (mounted) {
      setState(() {
        isMatched = result;
        isVerifying = false;
      });
    }
  }

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
                width: 250.w,
                height: 300.h,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white24, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(File(widget.imagePath), fit: BoxFit.cover),
                ),
              ),

              SizedBox(height: 20.h),

              // Match Info
              if (isVerifying)
                Column(
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 8.h),
                    Text(
                      "Verifying...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    Icon(
                      isMatched == true ? Icons.check_circle : Icons.cancel,
                      color: isMatched == true ? Colors.green : Colors.red,
                      size: 40.sp,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      isMatched == true ? "Perfect match!" : "No match!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      isMatched == true
                          ? "That is correct medicine!"
                          : "This is not the correct medicine!",
                      style: TextStyle(color: Colors.white70, fontSize: 13.sp),
                    ),
                  ],
                ),

              SizedBox(height: 20.h),

              Text(
                'Verifying : ${widget.nextMedicine?.name ?? "Aspirin"} (${widget.nextMedicine?.dosage ?? "50 mg"})',
                style: TextStyle(color: Colors.white70, fontSize: 13.sp),
              ),

              SizedBox(height: 25.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Consumer<HomeProvider>(
                  builder: (context, homeProvider, _) {
                    return homeProvider.isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColors.green,
                            ),
                          )
                        : CustomButton(
                            text: isMatched == true
                                ? "CONFIRM & TAKEN MEDICINE"
                                : "TRY AGAIN",
                            bgColor: isMatched == true
                                ? AppColors.green
                                : Colors.orange,
                            onTap: () async {
                              if (isMatched != true) {
                                // Try again - go back to take another photo
                                Navigator.pop(context);
                                return;
                              }

                              if (widget.nextMedicine != null) {
                                bool result = await homeProvider
                                    .confirmTakenMedicine(
                                      widget.nextMedicine!.medicineId,
                                      widget.nextMedicine!.time,
                                    );

                                if (result) {
                                  // Refresh today's summary
                                  await homeProvider.todaySummaryProgressBar();

                                  if (context.mounted) {
                                    // Close verify screen
                                    Navigator.pop(context);
                                    // Close dialog
                                    Navigator.pop(context);

                                    CustomSnackBar.showSuccess(
                                      context,
                                      'Medicine taken successfully',
                                    );
                                  }
                                } else {
                                  if (context.mounted) {
                                    CustomSnackBar.showError(
                                      context,
                                      homeProvider.errorMessage ??
                                          'Failed to confirm medicine',
                                    );
                                  }
                                }
                              }
                            },
                            isBoxShadow: false,
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
