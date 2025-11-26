import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parker_touch/core/widget/custom_bottom_navbar.dart';
import 'package:parker_touch/view/patient/home/home_page.dart';
import 'package:parker_touch/view/patient/medicines/medicines_view.dart';
import 'package:parker_touch/view/patient/monitors/my_monitors.dart';
import 'package:parker_touch/view/patient/settings/potient_setting.dart';

class PatientView extends StatefulWidget {
  const PatientView({super.key});

  @override
  State<PatientView> createState() => _PatientViewState();
}

class _PatientViewState extends State<PatientView> {
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
        contentWidget = const HomePage();
        break;
      case 1:
        contentWidget = const MedicinesView();
        break;
      case 2:
        contentWidget = const MyMonitors();
        break;
      case 3:
        contentWidget = const PotientSetting();
        break;
      default:
        contentWidget = const HomePage();
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        // Exit the app when back button is pressed
        SystemNavigator.pop();
      },
      child: Scaffold(
        body: contentWidget,
        bottomNavigationBar: CustomBottomNavbar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
        ),
      ),
    );
  }
}
