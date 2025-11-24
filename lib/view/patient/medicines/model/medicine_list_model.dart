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

// Monitor Item Model
class MonitorItem {
  final int id;
  final String fullName;
  final String email;
  final String status;
  final bool isOutgoing;
  final int requestId;

  MonitorItem({
    required this.id,
    required this.fullName,
    required this.email,
    required this.status,
    required this.isOutgoing,
    required this.requestId,
  });

  factory MonitorItem.fromJson(Map<String, dynamic> json) {
    return MonitorItem(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      status: json['status'] ?? '',
      isOutgoing: json['is_outgoing'] ?? false,
      requestId: json['request_id'] ?? 0,
    );
  }
}
