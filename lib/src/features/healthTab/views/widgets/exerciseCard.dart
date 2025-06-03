import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthvaults/src/features/goal/repo/taskRepo.dart';
import 'package:healthvaults/src/modals/TaskEntity.dart';
import 'package:healthvaults/src/res/appColors.dart';

import '../../../../modals/WeeklyWorkoutPlan.dart';
import '../../../../res/const.dart';
import '../../controller/todayExcerciseController.dart';
import '../demoExercise/exerciseDetailScreen.dart';


class ExerciseCard4 extends ConsumerWidget {
  final RoutineItem exercise;
  final VoidCallback onStart;

  const ExerciseCard4({
    super.key,
    required this.exercise,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // 🐞 Debug print inside widget:
    // debugPrint('Building Card → type: $title, title: $value, subtitle: ${exercise['duration'] ?? ""}, reps: ${exercise['reps'] ?? " np repa"}');

    return Material(
      color: Colors.white,
      elevation: 12,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: screenWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          exercise.type,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      ExpandableText(
                        text: exercise.name.split('(').first.trim(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        exercise.reps ?? exercise.duration ?? " ",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                      const SizedBox(height: 16),
                      Spacer(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(CupertinoIcons.stopwatch_fill),
                            Text(
                              " ${exercise.completedIN}s",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ],
                        ),
                      ),
                      // if (completed)
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.40, // or 0.30 for 30%

                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.cyan[200],
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 12,
                    children: [
                      Image.asset(
                        Constants.getTaskIcon(exercise.type),
                        color: Colors.black,
                      ),
                      InkWell(
                        onTap: () async {
                                            onStart();
                          // final confirmed = await showDialog<bool>(
                          //   context: context,
                          //   builder: (_) => AlertDialog(
                          //     title: const Text("Complete Task"),
                          //     content: const Text("Mark this task as done?"),
                          //     actions: [
                          //       TextButton(
                          //         onPressed: () => Navigator.pop(context, false),
                          //         child: const Text("Cancel"),
                          //       ),
                          //       TextButton(
                          //         onPressed: () => Navigator.pop(context, true),
                          //         child: const Text("Done"),
                          //       ),
                          //     ],
                          //   ),
                          // );
                          //
                          // if (confirmed == true) {
                          //   final updatedTask = exercise..isCompleted = true;
                          //   await TaskService.updateTask(updatedTask);
                          //   ref.invalidate(todayTaskProvider); // Rebuild with updated data
                          // }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12 ),
                          decoration: BoxDecoration(
                            color: exercise.isCompleted ? CupertinoColors.systemGreen : AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(exercise.isCompleted ? Icons.check_circle : CupertinoIcons.play_circle, color: Colors.white, size: 20),
                              SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  exercise.isCompleted ? "Completed" : "Start",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}class ExerciseCard3 extends ConsumerWidget {
  final TaskEntity exercise;
  final VoidCallback onStart;

  const ExerciseCard3({
    super.key,
    required this.exercise,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // 🐞 Debug print inside widget:
    // debugPrint('Building Card → type: $title, title: $value, subtitle: ${exercise['duration'] ?? ""}, reps: ${exercise['reps'] ?? " np repa"}');

    return Material(
      color: Colors.white,
      elevation: 12,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: screenWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          exercise.title,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      ExpandableText(
                        text: exercise.value.split('(').first.trim(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        exercise.description,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                      const SizedBox(height: 16),
                      Spacer(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(CupertinoIcons.stopwatch_fill),
                            Text(
                              " ${exercise.completedIN}s",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ],
                        ),
                      ),
                      // if (completed)
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.40, // or 0.30 for 30%

                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.cyan[200],
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 12,
                    children: [
                      Image.asset(
                        Constants.getTaskIcon(exercise.title),
                        color: Colors.black,
                      ),
                      InkWell(
                        onTap: () async {
                                            onStart();
                          // final confirmed = await showDialog<bool>(
                          //   context: context,
                          //   builder: (_) => AlertDialog(
                          //     title: const Text("Complete Task"),
                          //     content: const Text("Mark this task as done?"),
                          //     actions: [
                          //       TextButton(
                          //         onPressed: () => Navigator.pop(context, false),
                          //         child: const Text("Cancel"),
                          //       ),
                          //       TextButton(
                          //         onPressed: () => Navigator.pop(context, true),
                          //         child: const Text("Done"),
                          //       ),
                          //     ],
                          //   ),
                          // );
                          //
                          // if (confirmed == true) {
                          //   final updatedTask = exercise..isCompleted = true;
                          //   await TaskService.updateTask(updatedTask);
                          //   ref.invalidate(todayTaskProvider); // Rebuild with updated data
                          // }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12 ),
                          decoration: BoxDecoration(
                            color: exercise.isCompleted ? CupertinoColors.systemGreen : AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(exercise.isCompleted ? Icons.check_circle : CupertinoIcons.play_circle, color: Colors.white, size: 20),
                              SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  exercise.isCompleted ? "Completed" : "Start",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;

  final TextStyle style;

  const ExpandableText({
    super.key,
    required this.text,
    required this.style,
    this.maxLines = 2,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Text(
        widget.text,
        style: widget.style,
        maxLines: _isExpanded ? null : widget.maxLines,
        overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
      ),
    );
  }
}
