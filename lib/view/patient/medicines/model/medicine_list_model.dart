class MedicineListModel {
  final String? name;
  final String? dosage;
  final String? frequency;
  final List<String>? times;
  final String? durationDays;

  MedicineListModel({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.times,
    required this.durationDays,
  });

  factory MedicineListModel.fromJson(Map<String, dynamic> json) {
    return MedicineListModel(
      name: json['name'] ?? '',
      dosage: json['dosage'] ?? '',
      frequency: json['frequency'] ?? '',
      times: json['times'] != null ? List<String>.from(json['times']) : null,
      durationDays: (json['total_days'] ?? json['duration_days'] ?? '')
          .toString(),
    );
  }
}
