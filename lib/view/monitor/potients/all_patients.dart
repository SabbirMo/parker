import 'package:flutter/material.dart';
import 'package:parker_touch/provider/monitor_provider.dart/post_method/patients_list_provider.dart';
import 'package:parker_touch/view/monitor/home_monitor/home_monitor.dart';
import 'package:provider/provider.dart';

class AllPatients extends StatefulWidget {
  const AllPatients({super.key});

  @override
  State<AllPatients> createState() => _AllPatientsState();
}

class _AllPatientsState extends State<AllPatients> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PatientsListProvider>().fetchAllPatientsSummary();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PatientsListProvider>(
        builder: (context, provider, child) {
          if (provider.isSummaryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.summaryErrorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    provider.summaryErrorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      provider.fetchAllPatientsSummary();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.connectedPatients.isEmpty) {
            return const Center(child: Text('No patients found'));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: provider.connectedPatients.map((patient) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: PatientCard(
                      cricleIcon:
                          patient.profilePhoto ?? 'assets/images/woman.png',
                      name: patient.fullName,
                      age: patient.age.toString(),
                      alertIcon: patient.todayProgress.hasMissedDose
                          ? 'assets/icons/alert.png'
                          : null,
                      completed: patient.todayProgress.taken,
                      total: patient.todayProgress.total,
                      missedMedicines: patient.todayProgress.missedMedicines,
                      lastTakenTime: patient.todayProgress.lastTakenTime,
                      isSelected: patient.todayProgress.hasMissedDose,

                      patientId: patient.id,
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
