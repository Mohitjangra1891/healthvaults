import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/features/drawer/drawerScreen.dart';
import 'package:healthvaults/src/features/healthTab/todayExcerciseScreen.dart';
import 'package:healthvaults/src/utils/router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../modals/workoutPlan.dart';
import '../../res/appColors.dart';

class healthTabScreen extends StatefulWidget {
  const healthTabScreen({super.key});

  @override
  State<healthTabScreen> createState() => _healthTabScreenState();
}

class _healthTabScreenState extends State<healthTabScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // 🛡️ This keeps your tab alive

  @override
  Widget build(BuildContext context) {
    super.build(context); // IMPORTANT for keep alive!

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: Builder(
            builder: (context) => Padding(
              padding: const EdgeInsets.only(top: 0, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Profile + Drawer
                  GestureDetector(
                    onTap: () => Scaffold.of(context).openDrawer(),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white),
                          ),
                          child: Text('M', style: TextStyle(color: Colors.white, fontSize: 24)),
                        ),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Welcome back",
                                style: TextStyle(
                                  fontSize: 16,
                                )),
                            Text("mohit jangra",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Right icons
                  Row(
                    children: [
                      _circleIcon(context, Icons.bar_chart),
                      SizedBox(width: 8),
                      _circleIcon(context, Icons.notifications_none),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: ValueListenableBuilder(
            valueListenable: Hive.box<WorkoutPlan>('workoutPlans').listenable(keys: ['myPlan']),
            builder: (context, Box<WorkoutPlan> box, _) {
              final savedPlan = box.get('myPlan');

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
                child: savedPlan != null
                    ? WorkoutTodayScreen(
                        workoutPlan: savedPlan,
                      )
                    : noGoalScreen(),
              );
            }),

        // body : WorkoutTodayScreen(),
        drawer: buildDrawer(context),
      ),
    );
  }

  Widget _circleIcon(BuildContext context, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? Colors.white : AppColors.primaryColor;

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        // color: isDark ? Colors.white : AppColors.primaryColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Icon(icon, color: borderColor, size: 26),
    );
  }
}

class noGoalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? Colors.white : AppColors.primaryColor;
    return Column(
      children: [
        // Top Welcome Container
        Container(
          width: double.infinity,
          height: screenHeight * 0.16,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.blue.shade600,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Welcome to HealthVaults',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Let's start your health journey today!",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.30),

        Text(
          "Ready to set Your First Health Goal.",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
        ),
        SizedBox(height: 12),

        OutlinedButton(
          onPressed: () {
            context.pushNamed(routeNames.SetYourGoalScreen);
          },
          style: OutlinedButton.styleFrom(
            minimumSize: Size(screenWidth, screenHeight * 0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            side: BorderSide(color: borderColor, width: 1.8),
            // minimumSize: Size(double.infinity, 50),
          ),
          child: Text("Set My First Goal", style: TextStyle(color: borderColor, fontWeight: FontWeight.w500, fontSize: 20)),
        ),
      ],
    );
  }
}
