import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/time/time_get_greeting.dart';
import 'package:parker_touch/core/widget/header_section.dart';
import 'package:parker_touch/provider/auth/login_provider/login_provider.dart';
import 'package:parker_touch/provider/patient_provider/medicine_list_provider.dart';
import 'package:parker_touch/view/monitor/connect_potient/medicine_potient.dart';
import 'package:parker_touch/view/patient/add_medicine/add_medicine.dart';
import 'package:provider/provider.dart';

class MedicinesView extends StatefulWidget {
  const MedicinesView({super.key});

  @override
  State<MedicinesView> createState() => _MedicinesViewState();
}

class _MedicinesViewState extends State<MedicinesView> {
  @override
  void initState() {
    super.initState();
    // Schedule the fetch for after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      final medicineProvider = Provider.of<MedicineListProvider>(
        context,
        listen: false,
      );

      if (loginProvider.accessToken != null) {
        debugPrint('Access token found, fetching medicines...');
        medicineProvider.fetchMedicines(loginProvider.accessToken!);
      } else {
        debugPrint('No access token found, cannot fetch medicines');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final medicineProvider = Provider.of<MedicineListProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          Consumer(
            builder: (context, LoginProvider loginProvider, Widget? child) =>
                HeaderSection(
                  title: TimeGetGreeting.getGreeting(),
                  subtitle: loginProvider.fullName != null
                      ? loginProvider.fullName!
                      : "Mr. Parker",
                  text: "Stay on track with your medications",
                  image: "assets/images/man.png",
                ),
          ),
          AppSpacing.h14,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("My Medicine", style: FontManager.connect),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddMedicine()),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: AppColors.optBlue,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add,
                        color: AppColors.white,
                        size: 24.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: medicineProvider.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  )
                : medicineProvider.errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: Colors.red),
                        SizedBox(height: 16),
                        Text(
                          medicineProvider.errorMessage!,
                          style: TextStyle(fontSize: 16, color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            final loginProvider = Provider.of<LoginProvider>(
                              context,
                              listen: false,
                            );
                            if (loginProvider.accessToken != null) {
                              medicineProvider.fetchMedicines(
                                loginProvider.accessToken!,
                              );
                            }
                          },
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : medicineProvider.medicines.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.medical_services_outlined,
                          size: 48,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No medicines found',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.only(top: 14.h),
                    itemCount: medicineProvider.medicines.length,
                    itemBuilder: (context, index) {
                      final med = medicineProvider.medicines[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: 14.0,
                          left: 16.0,
                          right: 16.0,
                        ),
                        child: MedicineCart(
                          num: '${index + 1}.',
                          medicineName: med.name ?? 'Unknown Medicine',
                          mg: med.dosage ?? '0mg',
                          time: med.frequency ?? 'N/A',
                          days: med.durationDays ?? 'N/A',
                          index: index,
                          times: med.times,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
