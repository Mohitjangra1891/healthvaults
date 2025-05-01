import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthvaults/src/common/services/recordSharedPrefHelper.dart';
import 'package:http/http.dart' as http;

import '../../../../common/services/authSharedPrefHelper.dart';
import '../../../../modals/record.dart';

final selectionModeProvider = StateProvider<bool>((ref) => false);

final selectedRecordIdsProvider = StateNotifierProvider<SelectedRecordIdsNotifier, Set<String>>((ref) {
  return SelectedRecordIdsNotifier();
});

class SelectedRecordIdsNotifier extends StateNotifier<Set<String>> {
  SelectedRecordIdsNotifier() : super({});

  void toggle(String id) {
    if (state.contains(id)) {
      state = {...state}..remove(id);
    } else {
      state = {...state}..add(id);
    }
  }

  void clear() => state = {};
}

final filteredRecordListProvider = Provider.family<List<MedicalRecord>, String>((ref, profileId) {
  final asyncRecords = ref.watch(recordListProvider);

  return asyncRecords.maybeWhen(
    data: (records) => records.where((r) => r.pid == profileId).toList(),
    orElse: () => [],
  );
});

final searchQueryProvider = StateProvider<String>((ref) => '');
final profileRecordsSearchQueryProvider = StateProvider<String>((ref) => '');


final recordListProvider = StateNotifierProvider<RecordNotifier, AsyncValue<List<MedicalRecord>>>(
  (ref) => RecordNotifier()..loadRecordFromCache(),
);

class RecordNotifier extends StateNotifier<AsyncValue<List<MedicalRecord>>> {
  RecordNotifier() : super(const AsyncLoading());

  Future<void> loadRecordFromCache() async {
    final cached = await recordStorageHelper.loadrecords();
    // log("saved records" + cached.toString(), name: "RecordController / loadFromcache");

    state = AsyncData(cached);
  }

  int _currentPage = 1;
  final int _pageSize = 20;
  final List<MedicalRecord> _allRecords = [];

  Future<void> fetchInitial() async {
    try {
      state = AsyncLoading();

      final token = await SharedPrefHelper.getToken();

      final response = await http.get(
        Uri.parse('https://myhealthvaults.com/api/v1/record/list?page=$_currentPage&pagesize=$_pageSize'),
        // body: jsonEncode({"page": _currentPage, "pagesize": _pageSize}),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
      );

      // Debug log
      debugPrint('GET records/List → Status: ${response.statusCode}');
      // log('Response : ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        // final data = decoded['data']['owned'] as List;
        // final records = data.map((e) => MedicalRecord.fromJson(e)).toList();
        final owned = (decoded['data'] as List).map((e) {
          log('RECORD-- type : ${e['recordtype']} + record name : ${e['name']}');
          log('');

          return MedicalRecord.fromJson(e);
        }).toList();
        _allRecords.clear();
        _allRecords.addAll(owned);
        state = AsyncData(_allRecords);
        await recordStorageHelper.saverecords(_allRecords);
      } else {
        throw Exception("API error");
      }
    } catch (e, st) {
      debugPrint('GET  failed: $e');
      debugPrintStack(stackTrace: st);

      state = AsyncError(e, st);
    }
  }

  // Future<void> fetchMore() async {
  //   _currentPage++;
  //   try {
  //     state = AsyncLoading();
  //
  //     final token = await SharedPrefHelper.getToken();
  //
  //     final response = await http.get(
  //       Uri.parse('https://myhealthvaults.com/api/v1/record/list?page=$_currentPage&pagesize=$_pageSize'),
  //       // body: jsonEncode({"page": _currentPage, "pagesize": _pageSize}),
  //       headers: {
  //         "Content-Type": "application/json",
  //         'Authorization': 'Bearer $token',
  //       },
  //     );
  //     if (response.statusCode == 200) {
  //       final decoded = jsonDecode(response.body);
  //       final data = decoded['data'] as List;
  //       final records = data.map((e) => MedicalRecord.fromJson(e)).toList();
  //
  //       _allRecords.addAll(records);
  //       state = AsyncData(_allRecords);
  //       // final cached = await recordStorageHelper.loadrecords();
  //       await recordStorageHelper.saverecords(_allRecords);
  //     }
  //   } catch (e, st) {
  //     debugPrint('GET  failed: $e');
  //     debugPrintStack(stackTrace: st);
  //
  //     state = AsyncError(e, st);
  //   }
  // }

  Future<void> deleteRecords(List<String> ids) async {
    try {
      final token = await SharedPrefHelper.getToken();

      print(ids);
      final response = await http.post(
        Uri.parse("https://myhealthvaults.com/api/v1/record/delete"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"ids": ids}),
      );

      // Debug log
      debugPrint('DELETE records/List → Status: ${response.statusCode}');
      log('Response body: ${response.body}');
      if (response.statusCode == 200) {
        // Update provider state
        final updatedRecords = state.whenData(
          (records) => records.where((record) => !ids.contains(record.id)).toList(),
        );

        state = updatedRecords;

        // ✅ Also update SharedPreferences
        if (updatedRecords.hasValue) {
          await recordStorageHelper.saverecords(updatedRecords.value!);
        }
      }

    } catch (e, st) {
      debugPrint('Delete record  failed: $e');
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }
}
