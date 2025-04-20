import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/features/healthTab/views/demoExercise/exerciseDetailScreen.dart';
import 'package:healthvaults/src/features/healthTab/controller/todayExcerciseController.dart';
import 'package:healthvaults/src/features/healthTab/views/widgets/exerciseCard.dart';
import 'package:healthvaults/src/features/healthTab/views/widgets/progressCard.dart';
import 'package:healthvaults/src/res/const.dart';
import 'package:healthvaults/src/utils/router.dart';

import '../../../modals/workoutPlan.dart';
import '../../../res/appImages.dart';
import '../../../utils/utils.dart';
import '../../goal/views/widgets/rowIconText.dart';

class WorkoutTodayScreen extends ConsumerWidget {
  final WorkoutPlan workoutPlan;

  const WorkoutTodayScreen({super.key, required this.workoutPlan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ProgressCard(),
          const SizedBox(height: 12),

          InkWell(
            onTap: () {
              context.pushNamed(routeNames.Mygoalscreen);
            },
            child: Container(
              child: Row(
                children: [
                  Image.asset(
                    appImages.pin,
                    height: 30,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        workoutPlan.planName,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 28,
                  )
                ],
              ),
            ),
          ),
          WeeklyRow(
            day: getTodayDayName(),
            image: Constants.getIconPath(workoutPlan.weeklySchedule[getTodayDayName()]!),
            text: workoutPlan.weeklySchedule[getTodayDayName()]!,
            iconSize: 30,
            textSize: 18,
            isBold: false,
          ),

          const SizedBox(height: 12),
          excercise_ListView(),
          // ...exercises.map((exercise) => WorkoutSection(exercise: exercise)).toList(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
  //
  // String _calculateTotalDuration(List<Map<String, String>> exercises) {
  //   int totalMinutes = 0;
  //
  //   for (var ex in exercises) {
  //     final durationStr = ex['duration'];
  //     if (durationStr != null) {
  //       final match = RegExp(r'(\d+)\s*min').firstMatch(durationStr);
  //       if (match != null) {
  //         totalMinutes += int.tryParse(match.group(1) ?? '0') ?? 0;
  //       }
  //     }
  //   }
  //   return '$totalMinutes min';
  // }
}

class excercise_ListView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncExercises = ref.watch(todaysWorkoutProvider);
    debugPrint('🔄 Widget rebuilt: ${context.widget.runtimeType}');

    return asyncExercises.when(
      data: (exercises) => exercises.isEmpty
          ? const Center(child: Text('No workout today'))
          : Column(
              children: [
                MasonryGridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  // Prevent inner scroll
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 10,
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    final ex = exercises[index];

                    return ExerciseCard(exercise: ex);
                  },
                ),
                // ...exercises.map((exercise) => WorkoutSection(exercise: exercise)).toList(),
              ],
            ), // your exercise widgets
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
