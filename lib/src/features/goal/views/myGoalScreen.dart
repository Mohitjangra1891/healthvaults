import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthvaults/src/common/views/planScreen.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../modals/WeeklyWorkoutPlan.dart';
import '../../../modals/workoutPlan.dart';
import '../../healthTab/controller/planController.dart';

class Mygoalscreen extends ConsumerWidget {
  const Mygoalscreen({super.key});

  @override
  Widget build(BuildContext context ,WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final plan = ref.watch(workoutPlanProvider);

    return Scaffold(

      appBar: AppBar(title: Text("My Goal"),automaticallyImplyLeading: false,centerTitle: true,),

      body: SingleChildScrollView(
              child: plan != null
                  ? WorkoutPlanScreen(plan: plan!)
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Ready to set My First Goal",
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 26),
                        ),
                      ],
                    ),
            )
    );
  }
}
