class RecordModel {
  final String name;
  final DateTime createdAt;
  final String type;

  RecordModel({required this.name, required this.createdAt, required this.type});
}

enum RecordType { prescription, report, bill }

extension RecordTypeExtension on RecordType {
  String get displayName {
    switch (this) {
      case RecordType.prescription:
        return "Prescription";
      case RecordType.report:
        return "LabReport";
      case RecordType.bill:
        return "MedicalBill";
    }
  }
}

class MedicalRecord {
  final String id;
  final String pid;
  final String recordType;
  final String name;
  final String description;
  final String date;
  final String link;
  final DateTime createdAt;
  final DateTime updatedAt;

  MedicalRecord({
    required this.id,
    required this.pid,
    required this.recordType,
    required this.name,
    required this.description,
    required this.date,
    required this.link,
    required this.createdAt,
    required this.updatedAt,
  });
  MedicalRecord copyWith({
    String? id,
    String? pid,
    String? recordType,
    String? name,
    String? description,
    String? date,
    String? link,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MedicalRecord(
      id: id ?? this.id,
      pid: pid ?? this.pid,
      recordType: recordType ?? this.recordType,
      name: name ?? this.name,
      description: description ?? this.description,
      date: date ?? this.date,
      link: link ?? this.link,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory MedicalRecord.fromJson(Map<String, dynamic> json) => MedicalRecord(
        id: json['id'],
    pid: json['pid'],
        recordType: json['recordtype'],
        name: json['name'],
        description: json['description'],
        date: json['date'],
        link: json['link'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "pid": pid,
        "recordtype": recordType,
        "name": name,
        "description": description,
        "date": date,
        "link": link,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
      };
}

/// Helper to categorize records
enum RecordGroup { today, yesterday, others }

Map<RecordGroup, List<MedicalRecord>> groupRecordsByDate(List<MedicalRecord> records) {
  final today = DateTime.now();
  final yesterday = today.subtract(Duration(days: 1));

  List<MedicalRecord> todayRecords = [];
  List<MedicalRecord> yesterdayRecords = [];
  List<MedicalRecord> others = [];

  for (var record in records) {
    final createdDate = record.createdAt;

    if (_isSameDay(createdDate, today)) {
      todayRecords.add(record);
    } else if (_isSameDay(createdDate, yesterday)) {
      yesterdayRecords.add(record);
    } else {
      others.add(record);
    }
  }

  others.sort((a, b) => b.createdAt.compareTo(a.createdAt));

  return {
    RecordGroup.today: todayRecords,
    RecordGroup.yesterday: yesterdayRecords,
    RecordGroup.others: others,
  };
}

bool _isSameDay(DateTime d1, DateTime d2) {
  return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
}
