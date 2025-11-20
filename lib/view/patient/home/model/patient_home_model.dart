class NextMedicine {
  final String name;
  final String dosage;
  final String time;
  final String whenToTake;
  final int medicineId;
  final bool isTomorrow;

  NextMedicine({
    required this.name,
    required this.dosage,
    required this.time,
    required this.whenToTake,
    required this.medicineId,
    required this.isTomorrow,
  });

  factory NextMedicine.fromJson(Map<String, dynamic> json) {
    return NextMedicine(
      name: json['name'] ?? '',
      dosage: json['dosage'] ?? '',
      time: json['time'] ?? '',
      whenToTake: json['when_to_take'] ?? '',
      medicineId: json['medicine_id'] ?? 0,
      isTomorrow: json['is_tomorrow'] ?? false,
    );
  }
}
