import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/services/firebase_notification_service.dart';
import 'package:parker_touch/core/time/alarm/alarm_service.dart';
import 'package:parker_touch/provider/auth/change_password/change_password_provider.dart';
import 'package:parker_touch/provider/auth/change_password/new_password_provider.dart';
import 'package:parker_touch/provider/auth/forgot_provider/forgot_password_provider.dart';
import 'package:parker_touch/provider/auth/login_provider/login_provider.dart';
import 'package:parker_touch/provider/auth/signup_provider/monitor_provider.dart';
import 'package:parker_touch/provider/auth/signup_provider/patient_provider.dart';
import 'package:parker_touch/provider/auth/upload_prescription/save_scan_prescription_provider.dart';
import 'package:parker_touch/provider/auth/upload_prescription/upload_prescrition_provider.dart';
import 'package:parker_touch/provider/home_provider/home_provider.dart';
import 'package:parker_touch/provider/monitor_provider.dart/patient_details/patient_details.dart';
import 'package:parker_touch/provider/monitor_provider.dart/post_method/patient_connect_provider.dart';
import 'package:parker_touch/provider/monitor_provider.dart/post_method/patients_list_provider.dart';
import 'package:parker_touch/provider/notification_provider/notification_model.dart';
import 'package:parker_touch/provider/notification_provider/toggle_notification.dart';
import 'package:parker_touch/provider/patient_provider/add_medicine_manually_provider.dart';
import 'package:parker_touch/provider/patient_provider/connect_monitor_provider/connect_monitor_provider.dart';
import 'package:parker_touch/provider/patient_provider/connect_monitor_provider/send_request_monitor_provider.dart';
import 'package:parker_touch/provider/patient_provider/medicine_list_provider.dart';
import 'package:parker_touch/provider/subscription_provider/subscription_status_provider.dart';
import 'package:parker_touch/provider/voice_reminder/voice_reminder_provider.dart';
import 'package:parker_touch/view/splash/splash_view.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AlarmService.init();

  final loginProvider = LoginProvider();
  await loginProvider.initialize();

  final notificationProvider = NotificationProvider();
  final toggleNotification = ToggleNotification();
  await toggleNotification.initialize();

  final firebaseNotificationService = FirebaseNotificationService();

  // Initialize Firebase Messaging
  await firebaseNotificationService.initialize();

  // Set up notification callbacks
  firebaseNotificationService.onMessageReceived = (message) {
    notificationProvider.addNotificationFromRemoteMessage(message);
  };

  firebaseNotificationService.onMessageOpenedApp = (message) {
    notificationProvider.addNotificationFromRemoteMessage(message);
  };

  FirebaseMessaging.instance.getToken().then((token) {
    debugPrint('Firebase Messaging Token: $token');
  });

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => PatientProvider()),
          ChangeNotifierProvider(create: (_) => MonitorProvider()),
          ChangeNotifierProvider(create: (_) => LoginProvider()),
          ChangeNotifierProvider(create: (_) => ForgotPasswordProvider()),
          ChangeNotifierProvider(create: (_) => ChangePasswordProvider()),
          ChangeNotifierProvider(create: (_) => AddMedicineManuallyProvider()),
          ChangeNotifierProvider(create: (_) => MedicineListProvider()),
          ChangeNotifierProvider(create: (_) => NewPasswordProvider()),
          ChangeNotifierProvider(create: (_) => UploadPrescriptionProvider()),
          ChangeNotifierProvider(create: (_) => ConnectMonitorProvider()),
          ChangeNotifierProvider(create: (_) => SendRequestMonitorProvider()),
          ChangeNotifierProvider(create: (_) => HomeProvider()),
          ChangeNotifierProvider(create: (_) => SaveScanPrescriptionProvider()),
          ChangeNotifierProvider(create: (_) => PatientsListProvider()),
          ChangeNotifierProvider(create: (_) => PatientConnectProvider()),
          ChangeNotifierProvider(create: (_) => VoiceReminderProvider()),
          ChangeNotifierProvider.value(value: notificationProvider),
          ChangeNotifierProvider(create: (_) => SubscriptionStatusProvider()),
          ChangeNotifierProvider.value(value: toggleNotification),
          ChangeNotifierProvider(create: (_) => PatientDetailsProvider()),
        ],
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      ensureScreenSize: true,
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.white,
          useMaterial3: true,
        ),
        home: const FullScreenWrapper(child: SplashView()),
      ),
    );
  }
}

class FullScreenWrapper extends StatefulWidget {
  final Widget child;

  const FullScreenWrapper({super.key, required this.child});

  @override
  State<FullScreenWrapper> createState() => _FullScreenWrapperState();
}

class _FullScreenWrapperState extends State<FullScreenWrapper>
    with WidgetsBindingObserver {
  bool _isImmersiveModeEnabled = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _enableImmersiveMode();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_isImmersiveModeEnabled) {
        _enableImmersiveMode();
      }
    }
  }

  void _enableImmersiveMode() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [],
    );
  }

  void _disableImmersiveMode() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: SystemUiOverlay.values,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        // Detect upward scroll from bottom
        if (details.delta.dy < -8) {
          if (_isImmersiveModeEnabled) {
            setState(() {
              _isImmersiveModeEnabled = false;
            });
            _disableImmersiveMode();

            // Re-enable immersive mode after delay
            Future.delayed(const Duration(seconds: 3), () {
              if (mounted && !_isImmersiveModeEnabled) {
                setState(() {
                  _isImmersiveModeEnabled = true;
                });
                _enableImmersiveMode();
              }
            });
          }
        }
      },
      child: widget.child,
    );
  }
}
