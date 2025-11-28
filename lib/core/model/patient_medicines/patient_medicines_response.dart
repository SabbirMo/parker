class Patient {
  final int id;
  final String fullName;
  final int age;
  final String profilePhoto;

  Patient({
    required this.id,
    required this.fullName,
    required this.age,
    required this.profilePhoto,
  });

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
    id: json['id'],
    fullName: json['full_name'] ?? '',
    age: json['age'],
    profilePhoto: json['profile_photo'] ?? '',
  );
}

class TodaySummary {
  final String date;
  final int totalDoses;
  final int taken;
  final int missed;
  final int pending;
  final double progressPercentage;

  TodaySummary({
    required this.date,
    required this.totalDoses,
    required this.taken,
    required this.missed,
    required this.pending,
    required this.progressPercentage,
  });

  factory TodaySummary.fromJson(Map<String, dynamic> json) => TodaySummary(
    date: json['date'],
    totalDoses: json['total_doses'],
    taken: json['taken'],
    missed: json['missed'],
    pending: json['pending'],
    progressPercentage: (json['progress_percentage'] as num).toDouble(),
  );
}

class TimeWithStatus {
  final String time;
  final String status;
  final String? takenAt;

  TimeWithStatus({required this.time, required this.status, this.takenAt});

  factory TimeWithStatus.fromJson(Map<String, dynamic> json) => TimeWithStatus(
    time: json['time'],
    status: json['status'],
    takenAt: json['taken_at'],
  );
}

class Medicine {
  final int id;
  final String name;
  final String dosage;
  final List<String> times;
  final List<TimeWithStatus> timesWithStatus;

  Medicine({
    required this.id,
    required this.name,
    required this.dosage,
    required this.times,
    required this.timesWithStatus,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) => Medicine(
    id: json['id'],
    name: json['name'],
    dosage: json['dosage'],
    times: List<String>.from(json['times'] ?? []),
    timesWithStatus: (json['times_with_status'] as List)
        .map((e) => TimeWithStatus.fromJson(e))
        .toList(),
  );
}

class PatientMedicinesResponse {
  final Patient patient;
  final TodaySummary todaySummary;
  final List<Medicine> medicines;

  PatientMedicinesResponse({
    required this.patient,
    required this.todaySummary,
    required this.medicines,
  });

  factory PatientMedicinesResponse.fromJson(Map<String, dynamic> json) =>
      PatientMedicinesResponse(
        patient: Patient.fromJson(json['patient']),
        todaySummary: TodaySummary.fromJson(json['today_summary']),
        medicines: (json['medicines'] as List)
            .map((e) => Medicine.fromJson(e))
            .toList(),
      );
}
