import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/back_button.dart';

class MedicinePotient extends StatelessWidget {
  const MedicinePotient({super.key, this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomBackButton(),
              AppSpacing.h12,
              Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 54.r,
                  backgroundImage: AssetImage('assets/images/womanFace.png'),
                ),
              ),
              AppSpacing.h16,
              Align(
                child: Text(
                  'Sarah benwestrith',
                  style: FontManager.contTitle,
                  textAlign: TextAlign.center,
                ),
              ),
              AppSpacing.h4,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    email ?? 'sarah@gmail.com',
                    style: FontManager.contSubTitle,
                  ),
                  Text(' | 72 years old', style: FontManager.contSubTitle),
                ],
              ),
              AppSpacing.h20,
              Text('Patient’s Medicine', style: FontManager.connect),
              AppSpacing.h8,
              const MedicineCart(
                num: '1.',
                medicineName: ' Paracetamol',
                mg: '500mg',
                time: '3 times',
                days: '5 days',
                index: 2,
              ),
              AppSpacing.h14,
              const MedicineCart(
                num: '2.',
                medicineName: ' Omeprazole',
                mg: '500mg',
                time: '3 times',
                days: '5 days',
                index: 3,
              ),
              AppSpacing.h14,
              const MedicineCart(
                num: '3.',
                medicineName: ' Cetirizine',
                mg: '500mg',
                time: '3 times',
                days: '5 days',
                color: AppColors.redOpa,
                index: 1,
              ),
              AppSpacing.h14,
              const MedicineCart(
                num: '4.',
                medicineName: ' Amoxicillin',
                mg: '500mg',
                time: '3 times',
                days: '5 days',
                color: AppColors.white,
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MedicineCart extends StatelessWidget {
  const MedicineCart({
    super.key,
    required this.num,
    required this.medicineName,
    required this.mg,
    required this.time,
    required this.days,
    this.color,
    this.index,
    this.times,
  });

  final String num;
  final String medicineName;
  final String mg;
  final String time;
  final String days;
  final Color? color;
  final int? index;
  final List<String>? times;

  @override
  Widget build(BuildContext context) {
    // Debug print to check times array
    debugPrint('MedicineCart - times: $times');
    debugPrint('MedicineCart - times length: ${times?.length}');

    List<Widget> timeWidgets = [];

    if (times != null && times!.isNotEmpty) {
      // Parse times - handle both array format and space-separated string
      List<String> parsedTimes = [];

      for (var timeStr in times!) {
        // Split by spaces (one or more) and filter empty strings
        var splitTimes = timeStr
            .split(RegExp(r'\s+'))
            .where((t) => t.trim().isNotEmpty)
            .toList();
        parsedTimes.addAll(splitTimes);
      }

      debugPrint('Parsed times: $parsedTimes (${parsedTimes.length} items)');

      for (int i = 0; i < parsedTimes.length; i++) {
        timeWidgets.add(Image.asset('assets/icons/clock.png', width: 20));
        timeWidgets.add(AppSpacing.w4);
        timeWidgets.add(
          Text(parsedTimes[i].trim(), style: FontManager.bodyText5),
        );

        if (i < parsedTimes.length - 1) {
          timeWidgets.add(AppSpacing.w10);
        }
      }
    } else {
      debugPrint('Times is null or empty');
    }

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color ?? AppColors.greenOpca,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(width: 1, color: AppColors.black1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                num,
                style: FontManager.contTitle.copyWith(
                  fontSize: 16.sp,
                  color: AppColors.black1,
                ),
              ),
              Flexible(
                child: Text(
                  medicineName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FontManager.contTitle.copyWith(
                    fontSize: 14.sp,
                    color: AppColors.black1,
                  ),
                ),
              ),
              AppSpacing.w4,
              Text(mg, style: FontManager.bodyText4),
              AppSpacing.w6,
              Image.asset('assets/icons/clock.png', width: 20),
              AppSpacing.w4,
              Flexible(
                child: Text(
                  time,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FontManager.bodyText5,
                ),
              ),
              AppSpacing.w6,
              Image.asset('assets/icons/clender.png'),
              AppSpacing.w4,
              Text(
                '$days days',
                style: FontManager.bodyText5,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),

          if (timeWidgets.isNotEmpty) ...[
            AppSpacing.h12,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: timeWidgets,
            ),
          ],
        ],
      ),
    );
  }
}
