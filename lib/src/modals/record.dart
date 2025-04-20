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
        return "Report";
      case RecordType.bill:
        return "Bill";
    }
  }
}
