import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../modals/workoutModel2.dart';
import '../../../modals/workoutPlan.dart';
import '../../../res/const.dart';

class PlanNotifier extends StateNotifier<AsyncValue<WorkoutPlan?>> {
  // PlanNotifier() : super(const AsyncValue.loading());

  PlanNotifier() : super(const AsyncValue.data(null)); // Default state set to null

  late final ChatSession _chat;

  // Initialize Gemini chat session
  void initChatSession() {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: gemini_Api_key,
    );
    _chat = model.startChat();
  }

  Future<void> fetchPlan({required String prompt}) async {
    state = const AsyncValue.loading();
    try {
      // final result = await fetchWorkoutPlan(prompt: prompt);
      final response = await _chat.sendMessage(Content.text(prompt));
      final rawText = response.text ?? 'No response.';
      // print("rawtext---$rawText");
      final cleanedJson = rawText.replaceAll(RegExp(r'```json'), '').replaceAll(RegExp(r'```'), '').trim();
      final jsonData = json.decode(cleanedJson);
      log(jsonData.toString());
      final plan = WorkoutPlan.fromJson(jsonData);
      state = AsyncValue.data(plan);
    } catch (e, st) {
      print("Error in fetchWorkoutPlan: $e");

      state = AsyncValue.error(e, st);
    }
  }
}

final planProvider = StateNotifierProvider<PlanNotifier, AsyncValue<WorkoutPlan?>>(
  (ref) => PlanNotifier(),
);

// Future<WorkoutPlan> fetchWorkoutPlan({required String prompt}) async {
//   final model = GenerativeModel(
//     model: 'gemini-1.5-flash-latest',
//     apiKey: gemini_Api_key,
//   );
//
//   final content = [Content.text(prompt)];
//
//   try {
//     final response = await model.generateContent(content);
//
//     // log(response.text ?? "no response");
//     final jsonData = json.decode(response.text ?? 'No response.');
//     // print(jsonData);
//     // log(jsonData);
//     return WorkoutPlan.fromJson(jsonData);
//   } catch (e) {
//     print("Error in fetchWorkoutPlan: $e");
//     throw Exception('Failed to load plan');
//   }
// }
//
