import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/features/healthTab/views/todayExcerciseScreen.dart';
import 'package:healthvaults/src/features/healthTab/views/widgets/noPlanScreen.dart';
import 'package:healthvaults/src/utils/router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../common/controller/userController.dart';
import '../../../common/views/widgets/imagwWidget.dart';
import '../../../modals/workoutPlan.dart';
import '../../../res/appColors.dart';
import '../../../res/appImages.dart';

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
    debugPrint('🔄 Widget rebuilt: ${context.widget.runtimeType}');

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
                        // Container(
                        //   padding: EdgeInsets.all(18),
                        //   decoration: BoxDecoration(
                        //     color: AppColors.primaryColor,
                        //     shape: BoxShape.circle,
                        //     border: Border.all(color: Colors.white),
                        //   ),
                        //   child: Text('M', style: TextStyle(color: Colors.white, fontSize: 24)),
                        // ),
                        UserProfileDpScreen(),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Welcome back",
                                style: TextStyle(
                                  fontSize: 16,
                                )),
                            Consumer(
                              builder: (context, ref, _) {
                                final userName = ref.watch(userNameProvider);

                                return Text(userName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ));
                              },
                            ),
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
                    ? TodaysTaskScreen(
                        workoutPlan: savedPlan,
                      )
                    // ?WorkoutTodayScreen(
                    //         workoutPlan: savedPlan,
                    //       )
                    : noPlanScreen(),
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

Drawer buildDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(
            top: 48,
          ),
          child: Row(
            children: [
              Hero(
                tag: 'logo',
                child: Image.asset(
                  appImages.appLogo,
                  height: 64,
                  width: 64,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              const Text(
                'HealthVault',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.grey.withOpacity(0.4),
          indent: 16,
          endIndent: 16,
        ),
        // themes
        ListTile(
          leading: const Icon(Icons.account_circle_outlined),
          title: const Text('My Profile'),
          onTap: () {
            context.pushNamed(routeNames.profile);
            // Navigator.of(context).pushNamed(AppRouter.themesRoute);
          },
        ),
        // settings
        ListTile(
          leading: const Icon(Icons.analytics_outlined),
          title: const Text('My Progression'),
          onTap: () {
            // Navigator.of(context).pushNamed(AppRouter.settingsRoute);
          },
        ),
        ListTile(
          leading: const Icon(Icons.calendar_today_outlined),
          title: const Text('My Goals'),
          onTap: () {
            context.pushNamed(routeNames.Mygoalscreen);
            // Navigator.of(context).pushNamed(AppRouter.settingsRoute);
          },
        ),
        ListTile(
          leading: const Icon(Icons.privacy_tip_outlined),
          title: const Text('Change Goal'),
          onTap: () {
            context.pushNamed(routeNames.SetYourGoalScreen);

            // Navigator.of(context).pushNamed(AppRouter.settingsRoute);
          },
        ),
      ],
    ),
  );
}
