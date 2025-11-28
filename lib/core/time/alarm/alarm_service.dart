import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// Top-level callback function for alarm
@pragma('vm:entry-point')
void alarmCallback(int id, Map<String, dynamic> params) async {
  debugPrint("⏰ ALARM TRIGGERED! ID: $id, Medicine: ${params['medicineName']}");

  // Show notification immediately
  final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  await notifications.show(
    id,
    "Medicine Reminder",
    "It's time to take ${params['medicineName']}",
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'medicine_voice_channel',
        'Medicine Voice Reminders',
        channelDescription: 'Voice reminders for medicine time',
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('medicine_reminder'),
        enableVibration: true,
        fullScreenIntent: true,
        autoCancel: false,
        ongoing: false,
        category: AndroidNotificationCategory.alarm,
      ),
    ),
  );

  debugPrint("✅ Notification shown from alarm callback");

  // Speak the alarm message 3 times (only when alarm triggers)
  await AlarmService.speakAlarm(params['medicineName']);
}

class AlarmService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static final FlutterTts _tts = FlutterTts();

  static Future<void> init() async {
    // Initialize Android Alarm Manager
    await AndroidAlarmManager.initialize();

    tz.initializeTimeZones();

    // Use device's local timezone
    final String timeZoneName = DateTime.now().timeZoneName;
    try {
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      // Fallback to Asia/Dhaka if device timezone not found
      tz.setLocalLocation(tz.getLocation('Asia/Dhaka'));
    }

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(
      initSettings,
      // No callback - voice will only play when alarm is triggered, not on tap
    );

    // Request notification permissions for Android 13+
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin != null) {
      final granted = await androidPlugin.requestNotificationsPermission();
      debugPrint("📱 Notification permission granted: $granted");

      final exactAlarmGranted = await androidPlugin
          .requestExactAlarmsPermission();
      debugPrint("⏰ Exact alarm permission granted: $exactAlarmGranted");
    }

    // Configure TTS
    await _tts.setLanguage("en-US");
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);

    debugPrint("🔔 AlarmService initialized");
    debugPrint("   Timezone: ${tz.local.name}");
    debugPrint("   Current time: ${tz.TZDateTime.now(tz.local)}");
    debugPrint("   Device time: ${DateTime.now()}");
  }

  static Future<void> scheduleAlarm({
    required int id,
    required DateTime time,
    required String medicineName,
  }) async {
    try {
      final now = DateTime.now();

      debugPrint("📅 Scheduling alarm:");
      debugPrint("   ID: $id");
      debugPrint("   Target Time: ${time.hour}:${time.minute}");
      debugPrint(
        "   Current Device Time: ${now.hour}:${now.minute}:${now.second}",
      );
      debugPrint("   Medicine: $medicineName");

      // Calculate alarm time
      final alarmTime = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );

      // If the time has passed today, schedule for tomorrow
      final scheduledTime = alarmTime.isBefore(now)
          ? alarmTime.add(const Duration(days: 1))
          : alarmTime;

      debugPrint("   Scheduled for: $scheduledTime");

      // Use AndroidAlarmManager for reliable background alarms
      await AndroidAlarmManager.oneShotAt(
        scheduledTime,
        id,
        alarmCallback,
        exact: true,
        wakeup: true,
        rescheduleOnReboot: true,
        params: {'medicineName': medicineName},
      );

      debugPrint("✅ Alarm scheduled with AndroidAlarmManager");
      debugPrint(
        "⏰ Will trigger at ${scheduledTime.hour}:${scheduledTime.minute}",
      );
    } catch (e) {
      debugPrint("❌ Error scheduling alarm: $e");
      rethrow;
    }
  }

  static Future<void> speakAlarm(String medicineName) async {
    // Configure TTS for slower, clearer speech
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.4); // Slow speed (0.0 to 1.0, default is 0.5)
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);

    // Speak 3 times with pause between each
    for (int i = 0; i < 3; i++) {
      debugPrint("🔊 Speaking alarm message ${i + 1}/3");
      await _tts.speak("It's time to take medicine $medicineName");

      // Wait 4 seconds between each repetition
      await Future.delayed(const Duration(seconds: 4));
    }

    debugPrint("✅ Finished speaking 3 times");
  }

  // Test notification - send immediately
  static Future<void> sendTestNotification() async {
    try {
      debugPrint("🧪 Sending test notification...");

      await _notifications.show(
        999,
        "Test Notification",
        "If you see this, notifications are working!",
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'medicine_voice_channel',
            'Medicine Voice Reminders',
            channelDescription: 'Voice reminders for medicine time',
            importance: Importance.max,
            priority: Priority.max,
            playSound: true,
            sound: RawResourceAndroidNotificationSound('medicine_reminder'),
            enableVibration: true,
          ),
        ),
      );

      debugPrint("✅ Test notification sent");
    } catch (e) {
      debugPrint("❌ Test notification error: $e");
    }
  }
}
