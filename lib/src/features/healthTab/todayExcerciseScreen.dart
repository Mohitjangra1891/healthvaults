import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/features/healthTab/exerciseDetailScreen.dart';
import 'package:healthvaults/src/features/healthTab/todayExcerciseController.dart';
import 'package:healthvaults/src/res/const.dart';
import 'package:healthvaults/src/utils/router.dart';

import '../../modals/workoutPlan.dart';
import '../../res/appImages.dart';
import '../../utils/utils.dart';
import '../goal/views/widgets/rowIconText.dart';

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

  String _calculateTotalDuration(List<Map<String, String>> exercises) {
    int totalMinutes = 0;

    for (var ex in exercises) {
      final durationStr = ex['duration'];
      if (durationStr != null) {
        final match = RegExp(r'(\d+)\s*min').firstMatch(durationStr);
        if (match != null) {
          totalMinutes += int.tryParse(match.group(1) ?? '0') ?? 0;
        }
      }
    }
    return '$totalMinutes min';
  }
}

class excercise_ListView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncExercises = ref.watch(todaysWorkoutProvider);

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

class ExerciseCard extends StatelessWidget {
  final Map<String, String> exercise;

  const ExerciseCard({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    final keys = exercise.keys.toList();
    final key = keys.isNotEmpty ? keys.first : 'exercise';
    final title = key.replaceAll('_', ' ').toUpperCase();

    final value = exercise[key]?.replaceAll(RegExp(r'\s*\(.*?\)'), '');

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    debugPrint('🔄 Widget rebuilt: ${context.widget.runtimeType}');

    // 🐞 Debug print inside widget:
    // debugPrint('Building Card → type: $title, title: $value, subtitle: ${exercise['duration'] ?? ""}, reps: ${exercise['reps'] ?? " np repa"}');

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DemoScreen(
                          type: title,
                          excercise: exercise[key]!,
                          duration: exercise['reps'] ?? exercise['duration'] ?? "",
                        )));
            // context.pushNamed(routeNames.demoScreen);
          },
          child: Container(
            width: screenWidth * 0.50,
            decoration: BoxDecoration(
              color: Colors.blue.shade600,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(right: 0, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value ?? 'No description',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  exercise['reps'] ?? exercise['duration'] ?? "",
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                // if (completed)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.greenAccent),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.check_circle, color: Colors.greenAccent, size: 20),
                      SizedBox(width: 6),
                      Text(
                        "Completed",
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.greenAccent,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4.5),
            ),
            child: Icon(
              Icons.fitness_center,
              color: Colors.blue.shade700,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }
}

class ProgressCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      height: screenHeight * 0.16,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blue.shade600,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Today\'s Progress',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "0/6 exercises completed",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          Spacer(),
          SizedBox(
            width: 70.0,
            height: 70.0,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: 0.6,
                  strokeWidth: 8.0,
                  backgroundColor: Colors.white30,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                Center(
                  child: Text(
                    '${(0.0 * 100).toInt()}%',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
