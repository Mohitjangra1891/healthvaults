import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/features/goal/repo/taskRepo.dart';
import 'package:healthvaults/src/modals/TaskEntity.dart';

import '../../../../res/appColors.dart';
import '../../../../utils/router.dart';
import '../../controller/todayExcerciseController.dart';
import '../demoExercise/exerciseDetailScreen.dart';

// class ExerciseCard extends StatelessWidget {
//   final Map<String, String> exercise;
//
//   const ExerciseCard({super.key, required this.exercise});
//
//   @override
//   Widget build(BuildContext context) {
//     final keys = exercise.keys.toList();
//     final key = keys.isNotEmpty ? keys.first : 'exercise';
//     final title = key.replaceAll('_', ' ').toUpperCase();
//
//     final value = exercise[key]?.replaceAll(RegExp(r'\s*\(.*?\)'), '');
//
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     // 🐞 Debug print inside widget:
//     debugPrint('Building Card → type: $title, title: $value, subtitle: ${exercise['duration'] ?? ""}, reps: ${exercise['reps'] ?? " np repa"}');
//
//     return Stack(
//       children: [
//         GestureDetector(
//           onTap: () {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => DemoScreen(
//                       type: title,
//                       excercise: exercise[key]!,
//                       duration: exercise['reps'] ?? exercise['duration'] ?? "",
//                     )));
//             // context.pushNamed(routeNames.demoScreen);
//           },
//           child: Container(
//             width: screenWidth * 0.50,
//             decoration: BoxDecoration(
//               color: Colors.blue.shade600,
//               borderRadius: BorderRadius.circular(16),
//             ),
//             padding: const EdgeInsets.all(16),
//             margin: const EdgeInsets.only(right: 0, top: 10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   value ?? 'No description',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   exercise['reps'] ?? exercise['duration'] ?? "",
//                   style: TextStyle(
//                     color: Colors.white60,
//                     fontSize: 14,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 // if (completed)
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.greenAccent),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: const [
//                       Icon(Icons.check_circle, color: Colors.greenAccent, size: 20),
//                       SizedBox(width: 6),
//                       Text(
//                         "Completed",
//                         style: TextStyle(
//                           color: Colors.greenAccent,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Positioned(
//           top: 0,
//           right: 0,
//           child: Container(
//             padding: EdgeInsets.all(4),
//             decoration: BoxDecoration(
//               color: Colors.greenAccent,
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.white, width: 4.5),
//             ),
//             child: Icon(
//               Icons.fitness_center,
//               color: Colors.blue.shade700,
//               size: 28,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
class ExerciseCard2 extends ConsumerWidget {
  final TaskEntity exercise;
  final VoidCallback onStart;

  const ExerciseCard2({super.key, required this.exercise,required this.onStart,});

  @override
  Widget build(BuildContext context ,WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // 🐞 Debug print inside widget:
    // debugPrint('Building Card → type: $title, title: $value, subtitle: ${exercise['duration'] ?? ""}, reps: ${exercise['reps'] ?? " np repa"}');

    return Stack(
      children: [
        GestureDetector(
          onTap: onStart,
          // onTap: () {
          //   Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => DemoScreen(
          //                 type: exercise.title,
          //                 excercise: exercise.value,
          //                 duration: exercise.description,
          //               )));
          //   // context.pushNamed(routeNames.demoScreen);
          // },
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
                  exercise.title,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                ExpandableText(text: exercise.value,),
                // Text(
                //   exercise.value,
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontSize: 18,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                const SizedBox(height: 4),
                Text(
                  exercise.description,
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                // if (completed)
                InkWell(
                  onTap: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Complete Task"),
                        content: const Text("Mark this task as done?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text("Done"),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      final updatedTask = exercise..isCompleted = true;
                      await TaskService.updateTask(updatedTask);
                      ref.invalidate(todayTaskProvider); // Rebuild with updated data
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.greenAccent),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children:  [
                        Icon(exercise.isCompleted?Icons.check_circle : CupertinoIcons.circle, color: Colors.greenAccent, size: 20),
                        SizedBox(width: 6),
                        Text(
                        exercise.isCompleted?  "Completed" : "Start",
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.bold,
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

class ExpandableText extends StatefulWidget {
  final String text;

  const ExpandableText({super.key, required this.text});

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
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),        maxLines: _isExpanded ? null : 2,
        overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
      ),
    );
  }
}
