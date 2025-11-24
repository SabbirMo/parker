import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'package:parker_touch/core/widget/show_dialog_widget.dart';
import 'package:parker_touch/core/widget/snack_bar.dart';
import 'package:parker_touch/provider/home_provider/home_provider.dart';
import 'package:parker_touch/view/patient/home/model/patient_home_model.dart';
import 'package:provider/provider.dart';

class MedicineContainer extends StatefulWidget {
  final NextMedicine? nextMedicine;

  const MedicineContainer({super.key, this.nextMedicine});

  @override
  State<MedicineContainer> createState() => _MedicineContainerState();
}

class _MedicineContainerState extends State<MedicineContainer> {
  bool _medicineTaken = false;

  Future<void> _takeMedicine() async {
    if (widget.nextMedicine == null) {
      CustomSnackBar.showError(context, 'No medicine available');
      return;
    }

    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    bool result = await homeProvider.takeNowMedicine(
      widget.nextMedicine!.medicineId,
      widget.nextMedicine!.time,
    );

    if (result) {
      CustomSnackBar.showSuccess(context, 'Medicine taken successfully');
      // Refresh today's summary
      await homeProvider.todaySummaryProgressBar();
    } else {
      CustomSnackBar.showError(
        context,
        homeProvider.errorMessage ?? 'Failed to take medicine',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_medicineTaken) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 13, vertical: 24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(width: 1, color: AppColors.primaryColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/svg/right.svg', width: 30.w),
            AppSpacing.h10,
            Text(
              'Well Done!',
              style: FontManager.contTitle.copyWith(
                color: AppColors.black1,
                fontSize: 24.sp,
              ),
            ),
            Text(
              "You've taken all your medicine today",
              style: FontManager.bodyText5.copyWith(
                color: Color(0xff4B4B4B),
                fontSize: 18.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(width: 1, color: AppColors.primaryColor),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Next medicine", style: FontManager.loginStyle),
                  Text(
                    widget.nextMedicine?.name ?? "No medicine",
                    style: FontManager.titleStyle,
                  ),
                  Text(
                    widget.nextMedicine?.dosage ?? "0mg",
                    style: FontManager.loginStyle,
                  ),
                ],
              ),
              CircleAvatar(
                radius: 22.r,
                backgroundColor: AppColors.appBottomColor,
                child: Image.asset('assets/icons/clock.png'),
              ),
            ],
          ),
          AppSpacing.h8,
          Row(
            children: [
              Image.asset('assets/icons/clock.png', width: 18.w),
              AppSpacing.w10,
              Text(
                widget.nextMedicine?.time ?? "--:--",
                style: FontManager.loginStyle.copyWith(color: AppColors.login),
              ),
            ],
          ),
          AppSpacing.h10,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomButton(
                text: "MATCH",
                textColor: AppColors.login,
                bgColor: Color(0xffedf5fe),
                border: Border.all(width: 1, color: AppColors.login),
                width: 140.w,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return ShowDialogWidget(
                        nextMedicine: widget.nextMedicine,
                      );
                    },
                  );
                },
              ),
              CustomButton(
                text: "TAKE NOW",
                width: 140.w,
                onTap: _takeMedicine,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
