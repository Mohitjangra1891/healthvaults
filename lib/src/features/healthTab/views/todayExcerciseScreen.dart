import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/features/healthTab/controller/todayExcerciseController.dart';
import 'package:healthvaults/src/features/healthTab/views/demoExercise/exerciseDetailScreen.dart';
import 'package:healthvaults/src/features/healthTab/views/widgets/exerciseCard.dart';
import 'package:healthvaults/src/features/healthTab/views/widgets/progressCard.dart';
import 'package:healthvaults/src/modals/WeeklyWorkoutPlan.dart';
import 'package:healthvaults/src/utils/router.dart';
import 'package:intl/intl.dart';

import '../../../common/views/planScreen.dart';
import '../../../res/appImages.dart';

class TodaysTaskScreen extends ConsumerWidget {
  final WorkoutPlan2 workoutPlan;

//
  const TodaysTaskScreen({super.key, required this.workoutPlan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todaysTasksAsync = ref.watch(todayTaskProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final today = DateFormat('EEEE').format(DateTime.now()); // Gets 'Monday', 'Tuesday', etc.

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: todaysTasksAsync.when(
              data: (tasks) {
                final completedTasks = tasks.where((t) => t.isCompleted).toList();

                if (tasks.isEmpty) {
                  return Center(child: Text('No tasks for today.'));
                }
                return ProgressCard(
                  totalTask: tasks.length,
                  completed: completedTasks.length,
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),

          const SizedBox(height: 12),
          //

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: InkWell(
              onTap: () {
                context.pushNamed(routeNames.Mygoalscreen);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                decoration: BoxDecoration(
                  color: isDark ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 0), // Shadow on all sides
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Image.asset(
                      appImages.pin,
                      height: 26,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          workoutPlan.planName,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 24,
                    )
                  ],
                ),
              ),
            ),
          ),
          // WeeklyRow(
          //   day: getTodayDayName(),
          //   image: Constants.getIconPath(workoutPlan.weeklySchedule[getTodayDayName()]!),
          //   text: workoutPlan.weeklySchedule[getTodayDayName()]!,
          //   iconSize: 30,
          //   textSize: 18,
          //   isBold: false,
          // ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: todaysTasksAsync.when(
              data: (tasks) {
                if (tasks.isEmpty) {
                  return Center(child: Text('No tasks for today.'));
                }
                return Column(
                  children: [
                    MasonryGridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      // Prevent inner scroll
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 10,
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final ex = tasks[index];
                        // log(ex.toJson().toString());

                        return ExerciseCard2(exercise: ex, onStart: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DemoScreen(
                                exercises: tasks,
                                currentIndex: index,
                              ),
                            ),
                          );

                        },);
                      },
                    ),
                    // ...exercises.map((exercise) => WorkoutSection(exercise: exercise)).toList(),
                  ],
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),

          const SizedBox(height: 12),
          tipCards(
            plan: workoutPlan,
          ),
          const SizedBox(height: 12),

          AskYourselfCard(
            reflectionQuestions: workoutPlan.reflectionQuestions,
          )
        ],
      ),
    );
  }
}

class tipCards extends StatelessWidget {
  const tipCards({super.key, required this.plan});

  final WorkoutPlan2 plan;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final today = DateFormat('EEEE').format(DateTime.now());
    String? todayKey;
    WorkoutDay? todayWorkout;

    for (var entry in plan.workouts.entries) {
      if (entry.key.toLowerCase() == today.toLowerCase()) {
        todayKey = entry.key;
        todayWorkout = entry.value;
        break;
      }
    }
     if (todayWorkout != null) {
       return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          spacing: 14,
          children: [
            card(screenWidth, context, "Alternative", todayWorkout.alternative),
            card(screenWidth, context, "Common Mistakes", todayWorkout.commonMistake),
            card(screenWidth, context, "Coach Tips", todayWorkout.coachTip),
          ],
        ),
      );
     }
     else{
       return SizedBox.shrink();
     }
  }

  Material card(double screenWidth, BuildContext context, String title, String subt) {
    return Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.14,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch, // important to stretch both child heights equally

            children: [
              Container(
                width: screenWidth * 0.3,
                decoration: BoxDecoration(
                  color: Colors.cyan[100],
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                ),
                child: Icon(
                  Icons.fitness_center,
                  size: 32,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith()),
                      Text(subt),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
// class WorkoutTodayScreen extends ConsumerWidget {
//   final WorkoutPlan workoutPlan;
//
//   const WorkoutTodayScreen({super.key, required this.workoutPlan});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           ProgressCard(),
//           const SizedBox(height: 12),
//
//           InkWell(
//             onTap: () {
//               context.pushNamed(routeNames.Mygoalscreen);
//             },
//             child: Container(
//               child: Row(
//                 children: [
//                   Image.asset(
//                     appImages.pin,
//                     height: 30,
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 8.0),
//                       child: Text(
//                         workoutPlan.planName,
//                         maxLines: 2,
//                         style: TextStyle(
//                           fontSize: 26,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Icon(
//                     Icons.arrow_forward_ios_rounded,
//                     size: 28,
//                   )
//                 ],
//               ),
//             ),
//           ),
//           WeeklyRow(
//             day: getTodayDayName(),
//             image: Constants.getIconPath(workoutPlan.weeklySchedule[getTodayDayName()]!),
//             text: workoutPlan.weeklySchedule[getTodayDayName()]!,
//             iconSize: 30,
//             textSize: 18,
//             isBold: false,
//           ),
//
//           const SizedBox(height: 12),
//           excercise_ListView(),
//           // ...exercises.map((exercise) => WorkoutSection(exercise: exercise)).toList(),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
//   //
//   // String _calculateTotalDuration(List<Map<String, String>> exercises) {
//   //   int totalMinutes = 0;
//   //
//   //   for (var ex in exercises) {
//   //     final durationStr = ex['duration'];
//   //     if (durationStr != null) {
//   //       final match = RegExp(r'(\d+)\s*min').firstMatch(durationStr);
//   //       if (match != null) {
//   //         totalMinutes += int.tryParse(match.group(1) ?? '0') ?? 0;
//   //       }
//   //     }
//   //   }
//   //   return '$totalMinutes min';
//   // }
// }
//
// class excercise_ListView extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final asyncExercises = ref.watch(todaysWorkoutProvider);
//     debugPrint('🔄 Widget rebuilt: ${context.widget.runtimeType}');
//
//     return asyncExercises.when(
//       data: (exercises) => exercises.isEmpty
//           ? const Center(child: Text('No workout today'))
//           : Column(
//               children: [
//                 MasonryGridView.count(
//                   physics: const NeverScrollableScrollPhysics(),
//                   // Prevent inner scroll
//                   shrinkWrap: true,
//                   crossAxisCount: 2,
//                   mainAxisSpacing: 5,
//                   crossAxisSpacing: 10,
//                   itemCount: exercises.length,
//                   itemBuilder: (context, index) {
//                     final ex = exercises[index];;
//
//                     return ExerciseCard(exercise: ex);
//                   },
//                 ),
//                 // ...exercises.map((exercise) => WorkoutSection(exercise: exercise)).toList(),
//               ],
//             ), // your exercise widgets
//       loading: () => const Center(child: CircularProgressIndicator()),
//       error: (err, stack) => Center(child: Text('Error: $err')),
//     );
//   }
// }
