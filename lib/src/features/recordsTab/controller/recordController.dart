import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../modals/record.dart';

final RecordProvider = StateNotifierProvider<RecordNotifier, List<RecordModel>>((ref) {
  return RecordNotifier();
});

class RecordNotifier extends StateNotifier<List<RecordModel>> {
  RecordNotifier()
      : super([
          RecordModel(name: "Mohit J", createdAt: DateTime(2025, 4, 10), type: "Prescription"),
          RecordModel(name: "Mohit J", createdAt: DateTime(2025, 4, 10), type: "Prescription"),
          RecordModel(name: "Mohit J", createdAt: DateTime(2025, 4, 10), type: "Prescription"),
          RecordModel(name: "Znn B", createdAt: DateTime(2025, 4, 5), type: "Report"),
          RecordModel(name: "Mohit J", createdAt: DateTime(2025, 4, 10), type: "Prescription"),
          RecordModel(name: "Znn B", createdAt: DateTime(2025, 4, 5), type: "Report"),
          RecordModel(name: "Mohit J", createdAt: DateTime(2025, 4, 10), type: "Prescription"),
          RecordModel(name: "Znn B", createdAt: DateTime(2025, 4, 5), type: "Report"),
          RecordModel(name: "Mohit J", createdAt: DateTime(2025, 4, 10), type: "Prescription"),
          RecordModel(name: "Znn B", createdAt: DateTime(2025, 4, 5), type: "Report"),
          RecordModel(name: "Mohit J", createdAt: DateTime(2025, 4, 10), type: "Prescription"),
          RecordModel(name: "Znn B", createdAt: DateTime(2025, 4, 5), type: "Report"),
          RecordModel(name: "Mohit J", createdAt: DateTime(2025, 4, 10), type: "Prescription"),
          RecordModel(name: "Znn B", createdAt: DateTime(2025, 4, 5), type: "Report"),
        ]);

  void addRecord(RecordModel RecordModel) {
    state = [...state, RecordModel];
  }

  void deleteRecord(RecordModel RecordModel) {
    state = state.where((r) => r != RecordModel).toList();
  }

  void updateRecord(int index, RecordModel updatedRecordModel) {
    final list = [...state];
    list[index] = updatedRecordModel;
    state = list;
  }
}
final selectionModeProvider = StateProvider<bool>((ref) => false);

final selectedRecordIndexesProvider = StateNotifierProvider<SelectedRecordsNotifier, Set<int>>(
  (ref) => SelectedRecordsNotifier(),
);

class SelectedRecordsNotifier extends StateNotifier<Set<int>> {
  SelectedRecordsNotifier() : super({});

  void toggle(int index) {
    if (state.contains(index)) {
      state = {...state}..remove(index);
    } else {
      state = {...state, index};
    }
  }

  void clear() => state = {};
}
