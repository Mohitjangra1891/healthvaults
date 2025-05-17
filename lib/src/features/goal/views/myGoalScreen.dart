import 'package:flutter/material.dart';
import 'package:healthvaults/src/common/views/planScreen.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../modals/WeeklyWorkoutPlan.dart';
import '../../../modals/workoutPlan.dart';

class Mygoalscreen extends StatelessWidget {
  const Mygoalscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(

      appBar: AppBar(title: Text("My Goal"),automaticallyImplyLeading: false,centerTitle: true,),
      body: ValueListenableBuilder(
          valueListenable: Hive.box<WorkoutPlan2>('workoutPlan2').listenable(keys: ['myPlan']),
          builder: (context, Box<WorkoutPlan2> box, _) {
            final savedPlan = box.get('myPlan');

            return SingleChildScrollView(
              child: savedPlan != null
                  ? WorkoutPlanScreen(plan: savedPlan!)
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
            );
          }),
    );
  }
}
