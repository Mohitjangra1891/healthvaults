import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/res/appImages.dart';
import 'package:healthvaults/src/utils/router.dart';

Drawer buildDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(top: 48,),
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
        ),  ListTile(
          leading: const Icon(Icons.calendar_today_outlined),
          title: const Text('My Goals'),
          onTap: () {
            context.pushNamed(routeNames.Mygoalscreen);
            // Navigator.of(context).pushNamed(AppRouter.settingsRoute);
          },
        ), ListTile(
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
