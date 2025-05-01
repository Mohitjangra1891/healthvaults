// Edit State Management
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/features/recordsTab/records/controller/recordController.dart';
import 'package:http/http.dart' as http;

import '../../../../common/services/authSharedPrefHelper.dart';
import '../../../../modals/record.dart';

class EditState {
  final bool isLoading;
  final String? error;
  final bool success;

  EditState({required this.isLoading, this.error, required this.success});

  factory EditState.initial() {
    return EditState(isLoading: false, success: false, error: null);
  }

  EditState copyWith({bool? isLoading, String? error, bool? success}) {
    return EditState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      success: success ?? this.success,
    );
  }
}

final EditStateProvider = StateNotifierProvider<EditNotifier, EditState>((ref) {
  return EditNotifier();
});

class EditNotifier extends StateNotifier<EditState> {
  EditNotifier() : super(EditState.initial());

  Future<void> editRecord({required BuildContext context, required WidgetRef ref, required MedicalRecord newRecord}) async {
    state = state.copyWith(isLoading: true);

    try {
      final token = await SharedPrefHelper.getToken();
      final response = await http.post(
        Uri.parse('https://myhealthvaults.com/api/v1/record/modify'),
        body: jsonEncode({
          "recordid": newRecord.id,
          "name": newRecord.name,
          "description": newRecord.description,
          "date": newRecord.date,
          "pid": newRecord.pid,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        log('🎉 [Provider]record Edit successful');

        await ref.read(recordListProvider.notifier).fetchInitial();
        context.pop(); // for go_router

        state = state.copyWith(isLoading: false, success: true);
      } else {
        log('⚠️ [Provider] Edit failed: ${response.reasonPhrase}');

        state = state.copyWith(isLoading: false, error: 'An error occurred. Please try again.');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'An error occurred. Please try again.');
    }
  }
}
