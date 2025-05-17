import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthvaults/src/features/goal/views/widgets/monthlyWorkOut.dart';
import 'package:healthvaults/src/features/goal/views/widgets/rowIconText.dart';
import 'package:healthvaults/src/res/appImages.dart';

import '../../modals/WeeklyWorkoutPlan.dart';
import '../../modals/workoutPlan.dart';
import '../../res/const.dart';

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

class WorkoutPlanScreen extends StatelessWidget {
  final WorkoutPlan2 plan;

  const WorkoutPlanScreen({Key? key, required this.plan}) : super(key: key);

  static const _dayOrder = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  @override
  Widget build(BuildContext context) {
    // Build an ordered list of entries from the map
    final entries = <MapEntry<String, WorkoutDay>>[];
    for (var day in _dayOrder) {
      if (plan.workouts.containsKey(day)) {
        entries.add(MapEntry(day, plan.workouts[day]!));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header: Week Title
        Container(
          color: Colors.green[100],
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Text(
            plan.planName,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),

        // Workouts Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Text('Workouts', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: entries
                .map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ExerciseCard(dayKey: e.key, day: e.value),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 24),

        // Coach Remarks + Achievement
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.cyan[100],
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                IntrinsicHeight (
                  child: Row(
                    children: [
                      Expanded(child: _CoachCard(title: 'Remark 1', text: plan.remark1)),
                      const SizedBox(width: 12),
                      Expanded(child: _CoachCard(title: 'Remark 2', text: plan.remark2)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _AchievementCard(text: plan.achievement),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Reflection Questions
        AskYourselfCard(reflectionQuestions: plan.reflectionQuestions),
        const SizedBox(height: 24),
      ],
    );
  }
}

class AskYourselfCard extends StatelessWidget {
  const AskYourselfCard({
    super.key,
    required this.reflectionQuestions,
  });

  final List<String> reflectionQuestions;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(12 ),
        child: Container(
          height: 160,
            // color: Colors.cyan[100],

          padding: const EdgeInsets.symmetric(vertical: 16),
          // padding: EdgeInsets.symmetric(horizontal: 12,vertical: 18),
          decoration: BoxDecoration(
            color: Colors.cyan[100],
            borderRadius: BorderRadius.circular(12),
            // boxShadow: [
            //   BoxShadow(
            //     color: isDark ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.2),
            //     spreadRadius: 1,
            //     blurRadius: 5,
            //     offset: Offset(0, 0), // Shadow on all sides
            //   ),
            // ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Ask to yourself',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: reflectionQuestions.length,
                  itemBuilder: (context, i) => Container(

                    width: screenWidth*0.40,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      reflectionQuestions[i],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CoachCard extends StatelessWidget {
  final String title;
  final String text;

  const _CoachCard({required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            alignment: Alignment.center,
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final String text;

  const _AchievementCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Achievement',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ExerciseCard extends StatefulWidget {
  final String dayKey;
  final WorkoutDay day;

  const ExerciseCard({Key? key, required this.dayKey, required this.day}) : super(key: key);

  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 700),
        curve: Curves.elasticOut,
        child: _isExpanded ? _buildExpanded() : _buildCollapsed(),
      ),
    );
  }

  Widget _buildExpanded() {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 100,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.cyan[200],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.dayKey.substring(0,3), style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(widget.day.theme, style: const TextStyle(fontSize: 12)),
                    const SizedBox(height: 8),
                    const Icon(Icons.fitness_center, size: 32),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.day.routine
                        .map((r) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    r.reps != null || r.duration != null ? Icons.check : Icons.circle_outlined,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(r.instruction)),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsed() {
    return Material(
      elevation: 8,
        borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(color: Colors.cyan[200], borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Text(widget.dayKey.substring(0,3), style: const TextStyle(fontWeight: FontWeight.bold ,fontSize: 20)),
            const SizedBox(width: 16),
            Expanded(child: Text("${widget.day.theme} ${widget.dayKey}")),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black)),
              child: const Icon(Icons.fitness_center, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
