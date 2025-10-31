import 'package:flutter/material.dart';
import 'package:parker_touch/core/widget/custom_bottom_navbar.dart';
import 'package:parker_touch/view/monitor/home_monitor/home_monitor.dart';
import 'package:parker_touch/view/monitor/notification/monitor_notification_view.dart';
import 'package:parker_touch/view/monitor/potients/monitor_potients_view.dart';
import 'package:parker_touch/view/monitor/setting/monitor_setting_view.dart';

class MonitorView extends StatefulWidget {
  const MonitorView({super.key});

  @override
  State<MonitorView> createState() => _MonitorViewState();
}

class _MonitorViewState extends State<MonitorView> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget contentWidget;
    switch (_currentIndex) {
      case 0:
        contentWidget = const HomeMonitor();
        break;
      case 1:
        contentWidget = const MonitorPotientsView();
        break;
      case 2:
        contentWidget = const MonitorNotificationView();
        break;
      case 3:
        contentWidget = const MonitorSettingView();
        break;
      default:
        contentWidget = const HomeMonitor();
    }

    return Scaffold(
      body: contentWidget,
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        isMonitorView: true,
      ),
    );
  }
}
