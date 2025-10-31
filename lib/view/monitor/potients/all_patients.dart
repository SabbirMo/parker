import 'package:flutter/material.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/view/monitor/home_monitor/home_monitor.dart';

class AllPatients extends StatelessWidget {
  const AllPatients({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              PatientCard(
                cricleIcon: 'assets/images/woman.png',
                name: 'Maratha Johnson',
                alertIcon: 'assets/icons/alert.png',
              ),
              AppSpacing.h10,
              PatientCard(
                cricleIcon: 'assets/images/oldMan.png',
                name: 'Peter Johnson',
                isSelected: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
