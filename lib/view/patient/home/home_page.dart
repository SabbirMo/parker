import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/constants/font_manager.dart';
import 'package:parker_touch/core/time/time_get_greeting.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'package:parker_touch/core/widget/free_trial_container.dart';
import 'package:parker_touch/core/widget/header_section.dart';
import 'package:parker_touch/core/widget/medicine_container.dart';
import 'package:parker_touch/core/widget/progress_bar_widget.dart';
import 'package:parker_touch/view/patient/add_medicine/add_manually_screen.dart';
import 'package:provider/provider.dart';
import 'package:parker_touch/provider/auth/login_provider/login_provider.dart';
import 'package:parker_touch/provider/home_provider/home_provider.dart';
import 'package:parker_touch/provider/patient_provider/medicine_list_provider.dart';
import 'package:parker_touch/core/base_url/base_url.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      final medicineProvider = Provider.of<MedicineListProvider>(
        context,
        listen: false,
      );
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);

      if (loginProvider.accessToken != null) {
        debugPrint('=== HomePage API Calls ===');
        debugPrint('Base URL: $baseUrl');
        debugPrint(
          'Access Token: ${loginProvider.accessToken?.substring(0, 20)}...',
        );
        debugPrint('Full Name: ${loginProvider.fullName}');
        debugPrint('Role: ${loginProvider.role}');

        debugPrint('Calling getNextMedicine API from HomePage');
        debugPrint('Endpoint: $baseUrl/api/medicine/home-summary/');

        medicineProvider.getNextMedicine(loginProvider.accessToken!).then((_) {
          if (medicineProvider.nextMedicine != null) {
            debugPrint(
              'Next Medicine Data: ${medicineProvider.nextMedicine?.name}',
            );
          } else {
            debugPrint('No next medicine found or API error');
            if (medicineProvider.errorMessage != null) {
              debugPrint('Error: ${medicineProvider.errorMessage}');
            }
          }
        });

        // Call today summary API
        debugPrint('Calling todaySummaryProgressBar API from HomePage');
        debugPrint('Endpoint: $baseUrl/api/medicine/today-summary/');

        homeProvider.todaySummaryProgressBar().then((success) {
          if (!success) {
            debugPrint('Failed to load today summary');
            if (homeProvider.errorMessage != null) {
              debugPrint('Error: ${homeProvider.errorMessage}');
            }
          }
        });
      } else {
        debugPrint('No access token available in HomePage');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final medicineProvider = Provider.of<MedicineListProvider>(context);
    final homeProvider = Provider.of<HomeProvider>(context);
    return Column(
      children: [
        // Fixed header section
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
        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppSpacing.h10,
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    children: [
                      const FreeTrialContainer(),
                      AppSpacing.h16,
                      medicineProvider.isLoading
                          ? Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  width: 1,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            )
                          : medicineProvider.errorMessage != null
                          ? Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(width: 1, color: Colors.red),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 48,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Unable to load medicine data',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Please check your connection and try again',
                                    style: TextStyle(fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          : MedicineContainer(
                              nextMedicine: medicineProvider.nextMedicine,
                            ),

                      AppSpacing.h16,
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            width: 1,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Today's Summary",
                              style: FontManager.contTitle,
                            ),
                            homeProvider.isLoading
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  )
                                : homeProvider.errorMessage != null
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Unable to load summary',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  )
                                : ProgressBarWidget(
                                    completed: homeProvider.taken,
                                    total: homeProvider.total,
                                  ),
                          ],
                        ),
                      ),

                      AppSpacing.h16,

                      CustomButton(
                        text: "ADD MEDICINE",
                        textColor: AppColors.login,
                        bgColor: Color(0xffedf5fe),
                        border: Border.all(width: 1, color: AppColors.login),
                        rightIcon: Icons.add,
                        iconColor: AppColors.login,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddManuallyScreen(),
                            ),
                          );
                        },
                      ),
                      AppSpacing.h16,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
