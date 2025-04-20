import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthvaults/src/features/goal/views/widgets/monthlyWorkOut.dart';
import 'package:healthvaults/src/features/goal/views/widgets/rowIconText.dart';
import 'package:healthvaults/src/res/appImages.dart';

import '../../modals/workoutPlan.dart';
import '../../res/const.dart';
import '../../features/goal/controller/workoutPlanController.dart';

class planScreen extends ConsumerWidget {
  final WorkoutPlan workoutPlan;

  const planScreen({super.key, required this.workoutPlan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final workoutPlan = ref.watch(workoutProvider); // Assuming you have a FutureProvider

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // return workoutPlan.when(
    //   data: (data) {
        final dayWorkout = workoutPlan?.weeklySchedule.entries.toList();
        final month1 = workoutPlan!.workouts.month1;
        final month2 = workoutPlan!.workouts.month2;
        final month3 = workoutPlan!.workouts.month3;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              RowIconText(
                image: appImages.pin,
                text: workoutPlan!.planName,
                iconSize: 30,
                textSize: 26,
                isBold: false,
              ),
              const SizedBox(height: 16),
              RowIconText(
                image: appImages.star,
                text: workoutPlan.achievement,
                iconSize: 30,
                textSize: 20,
                isBold: false,
              ),
              const SizedBox(height: 16),
              RowIconText(
                image: appImages.calender,
                text: "Weekly schedule",
                iconSize: 38,
                textSize: 28,
                isBold: true,
              ),
              ...dayWorkout!.map((day) => WeeklyRow(
                    day: day.key,
                    image: Constants.getIconPath(day.value),
                    text: day.value,
                    iconSize: 30,
                    textSize: 18,
                    isBold: false,
                    padding: const EdgeInsets.only(left: 8),
                  )),
              MonthlyWorkoutSection(
                title: "Month 1: Foundation Phase",
                monthData: month1,
              ),
              MonthlyWorkoutSection(
                title: "Month 2: Strength Phase",
                monthData: month2,
              ),
              MonthlyWorkoutSection(
                title: "Month 3: Peak Phase",
                monthData: month3,
              ),
            ],
          ),
        );
      // };
      // loading: () => const Center(child: CircularProgressIndicator()),
      // error: (e, _) => Center(child: Text('Error: $e')),
    // );
  }
}
