import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/features/healthTab/views/widgets/exerciseCard.dart';
import 'package:healthvaults/src/features/healthTab/views/widgets/progressCard.dart';
import 'package:healthvaults/src/modals/WeeklyWorkoutPlan.dart';
import 'package:healthvaults/src/utils/router.dart';
import 'package:intl/intl.dart';

import '../../../common/views/planScreen.dart';
import '../../../common/views/widgets/logoWithTextNAme.dart';
import '../../../res/appImages.dart';
import '../../../res/const.dart';
import 'demoExercise/exerciseDetailScreen.dart';

class TodaysTaskScreen extends ConsumerWidget {
  final WorkoutPlan2 workoutPlan;

//
  const TodaysTaskScreen({super.key, required this.workoutPlan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Otherwise, show today’s progress + list
    final total = workoutPlan.todayTotalExercises;
    final done = workoutPlan.todayCompletedExercises;
    final todayKey = DateFormat('EEEE').format(DateTime.now());
    final todayWorkout = workoutPlan.todayWorkout;

    // final todaysTasksAsync = ref.watch(todayTaskProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final today = DateFormat('EEEE').format(DateTime.now());

    // String? todayKey;
    // WorkoutDay? todayWorkout;

    // for (var entry in workoutPlan.workouts.entries) {
    //   if (entry.key.toLowerCase() == today.toLowerCase()) {
    //     todayKey = entry.key;
    //     todayWorkout = entry.value;
    //     break;
    //   }
    // }


    // If week one is completed:
    if (workoutPlan.isWeekOneCompleted) {
      return Center(
        child: Text(
          "Week One Completed 🎉",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            (todayWorkout == null || todayWorkout.routine.isEmpty)
                ? Column(
                    children: [
                      NoTAskProgressCard(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          textAlign: TextAlign.center,
                          'No exercises for today, you can take a walk or do light stretching for active recover!',
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      )
                    ],
                  )
                : Column(
                    spacing: 12,
                    children: [
                      ProgressCard(
                        totalTask: total,
                        completed: done,
                      ),
                      InkWell(
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

                      // WeeklyRow(
                      //   day: getTodayDayName(),
                      //   image: Constants.getIconPath(workoutPlan.weeklySchedule[getTodayDayName()]!),
                      //   text: workoutPlan.weeklySchedule[getTodayDayName()]!,
                      //   iconSize: 30,
                      //   textSize: 18,
                      //   isBold: false,
                      // ),
                      Text(todayWorkout?.theme ?? " ", style: Theme.of(context).textTheme.headlineSmall?.copyWith()),

                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          // Prevent inner scroll
                          shrinkWrap: true,
                          itemCount: todayWorkout.routine.length,
                          itemBuilder: (context, index) {
                            final ex = todayWorkout.routine[index];
                            // log(ex.toJson().toString());

                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              child: ExerciseCard4(
                                exercise: ex,
                                onStart: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DemoScreen(
                                        exercises: todayWorkout.routine,
                                        currentIndex: index,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                      tipCards(
                        todayWorkout: todayWorkout,
                      ),
                      AskYourselfCard(
                        reflectionQuestions: workoutPlan.reflectionQuestions,
                      ),

                      ExpandableText(
                        text: DISCLAIMER,
                        style: TextStyle(fontWeight: FontWeight.w400),
                        maxLines: 5,
                      ),
                      const SizedBox(height: 12),

                      logoWithTextName(),
                      const SizedBox(height: 120),
                    ],
                  ),

            // todaysTasksAsync.when(
            //   data: (tasks) {
            //     if (tasks.isEmpty) {}
            //     return Column(
            //       spacing: 16,
            //       children: [
            //         ListView.builder(
            //             physics: const NeverScrollableScrollPhysics(),
            //             // Prevent inner scroll
            //             shrinkWrap: true,
            //             itemCount: tasks.length,
            //             itemBuilder: (context, index) {
            //               final ex = tasks[index];
            //               // log(ex.toJson().toString());
            //
            //               return Padding(
            //                 padding: EdgeInsets.symmetric(vertical: 12.0),
            //                 child: ExerciseCard3(
            //                   exercise: ex,
            //                   onStart: () {
            //                     Navigator.push(
            //                       context,
            //                       MaterialPageRoute(
            //                         builder: (context) => DemoScreen(
            //                           exercises: tasks,
            //                           currentIndex: index,
            //                         ),
            //                       ),
            //                     );
            //                   },
            //                 ),
            //               );
            //             }),
            //         // MasonryGridView.count(
            //         //   physics: const NeverScrollableScrollPhysics(),
            //         //   // Prevent inner scroll
            //         //   shrinkWrap: true,
            //         //   crossAxisCount: 2,
            //         //   mainAxisSpacing: 5,
            //         //   crossAxisSpacing: 10,
            //         //   itemCount: tasks.length,
            //         //   itemBuilder: (context, index) {
            //         //     final ex = tasks[index];
            //         //     // log(ex.toJson().toString());
            //         //
            //         //     return ExerciseCard2(
            //         //       exercise: ex,
            //         //       onStart: () {
            //         //         Navigator.push(
            //         //           context,
            //         //           MaterialPageRoute(
            //         //             builder: (context) => DemoScreen(
            //         //               exercises: tasks,
            //         //               currentIndex: index,
            //         //             ),
            //         //           ),
            //         //         );
            //         //       },
            //         //     );
            //         //   },
            //         // ),
            //         // ...exercises.map((exercise) => WorkoutSection(exercise: exercise)).toList(),
            //         Builder(builder: (context) {
            //           if (todayWorkout != null) {
            //             return tipCards(
            //               todayWorkout: todayWorkout,
            //             );
            //           } else {
            //             return SizedBox.shrink();
            //           }
            //         }),
            //
            //         AskYourselfCard(
            //           reflectionQuestions: workoutPlan.reflectionQuestions,
            //         ),
            //
            //         ExpandableText(
            //           text: DISCLAIMER,
            //           style: TextStyle(fontWeight: FontWeight.w400),
            //           maxLines: 5,
            //         ),
            //         const SizedBox(height: 12),
            //
            //         logoWithTextName(),
            //         const SizedBox(height: 120),
            //       ],
            //     );
            //   },
            //   loading: () => Center(child: CircularProgressIndicator()),
            //   error: (err, stack) => Center(child: Text('Error: $err')),
            // ),
          ],
        ),
      ),
    );
  }
}

class tipCards extends StatelessWidget {
  const tipCards({super.key, required this.todayWorkout});

  final WorkoutDay todayWorkout;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // final today = DateFormat('EEEE').format(DateTime.now());
    // String? todayKey;
    // WorkoutDay? todayWorkout;
    //
    // for (var entry in plan.workouts.entries) {
    //   if (entry.key.toLowerCase() == today.toLowerCase()) {
    //     todayKey = entry.key;
    //     todayWorkout = entry.value;
    //     break;
    //   }
    // }

    return Column(
      spacing: 14,
      children: [
        card(screenWidth, context, "Alternative", todayWorkout.alternative, appImages.alternateExercise),
        card(screenWidth, context, "Common Mistakes", todayWorkout.commonMistake, appImages.commonMistake),
        card(screenWidth, context, "Coach Tips", todayWorkout.coachTip, appImages.coachTip),
      ],
    );
  }

  Material card(double screenWidth, BuildContext context, String title, String subt, String img) {
    return Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.14,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch, // important to stretch both child heights equally

            children: [
              Container(
                alignment: Alignment.center,
                width: screenWidth * 0.3,
                decoration: BoxDecoration(
                  color: Colors.cyan[100],
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                ),
                child: Center(
                    child: SvgPicture.asset(
                  img,
                )),
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
