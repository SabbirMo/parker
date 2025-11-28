import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/widget/back_button.dart';
import 'package:parker_touch/provider/monitor_provider.dart/patient_details/patient_details.dart';
import 'package:provider/provider.dart';

class MedicinePotient extends StatefulWidget {
  const MedicinePotient({
    super.key,
    this.patientId,
    this.patientName,
    this.email,
  });
  final int? patientId;
  final String? patientName;
  final String? email;

  @override
  State<MedicinePotient> createState() => _MedicinePotientState();
}

class _MedicinePotientState extends State<MedicinePotient> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<PatientDetailsProvider>(
        context,
        listen: false,
      );
      provider.fetchPatientMedicines(widget.patientId ?? 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PatientDetailsProvider>(context);

    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor),
      );
    }

    if (provider.error != null) {
      return Center(
        child: Text(
          provider.error ?? 'An error occurred',
          style: FontManager.contTitle,
        ),
      );
    }

    final patient = provider.patientMedicines?.patient;
    final medicines = provider.patientMedicines?.medicines;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            CustomBackButton(),
            AppSpacing.h12,
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 54.r,
                backgroundImage:
                    patient != null && patient.profilePhoto.isNotEmpty
                    ? NetworkImage(patient.profilePhoto)
                    : const AssetImage('assets/images/patient1.png')
                          as ImageProvider,
              ),
            ),
            AppSpacing.h16,
            Align(
              child: Text(
                '${patient?.fullName}',
                style: FontManager.contTitle,
                textAlign: TextAlign.center,
              ),
            ),
            AppSpacing.h4,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${patient?.email ?? ''}  |',
                  style: FontManager.contSubTitle,
                ),
                AppSpacing.w8,
                Text(
                  '${patient?.age ?? ''} years old',
                  style: FontManager.contSubTitle,
                ),
              ],
            ),
            AppSpacing.h20,
            Text('Patient’s Medicine', style: FontManager.connect),
            AppSpacing.h8,
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(medicines?.length ?? 0, (index) {
                    final med = medicines![index];

                    return Column(
                      children: [
                        MedicineCart(
                          num: "${index + 1}.",
                          medicineName: med.name,
                          mg: med.dosage,
                          time: "${med.times.length} times",
                          days: "${med.totalDays}",
                          times: med.times,
                          index: med.times.length,
                        ),
                        AppSpacing.h14,
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
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
