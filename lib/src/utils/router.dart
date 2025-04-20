import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/features/auth/views/loginScreen.dart';
import 'package:healthvaults/src/features/auth/views/otpVerifyScreen.dart';
import 'package:healthvaults/src/homePage.dart';

import '../features/goal/views/myGoalScreen.dart';
import '../features/goal/views/setYourGoalScreen.dart';
import '../features/healthTab/exerciseDetailScreen.dart';
import '../features/home/addNewProfileScreen.dart';
import '../features/home/uploadDocument.dart';
import '../features/myProfile/myProfileScreen.dart';
import '../features/onboarding/views/onboardingScreen.dart';
import '../modals/record.dart';

class routeNames {
  static String splash = '/splash';
  static String home = '/home';
  static String login = '/login';
  static String otpVerify = '/otpVerify';
  static String profile = '/profile';
  static String createProfile = '/createProfile';
  static String uploadDocument = '/uploadDocument';
  static String Mygoalscreen = '/Mygoalscreen';
  static String SetYourGoalScreen = '/SetYourGoalScreen';
  static String demoScreen = '/demoScreen';
}

final GoRouter router = GoRouter(
  initialLocation: routeNames.home,
  routes: [
    GoRoute(
      name: routeNames.splash,
      path: routeNames.splash,
      builder: (BuildContext context, GoRouterState state) {
        return OnboardingScreen();
      },
    ),
    GoRoute(
      name: routeNames.login,
      path: routeNames.login,
      builder: (BuildContext context, GoRouterState state) {
        return LoginScreen();
      },
    ),
    GoRoute(
      name: routeNames.otpVerify,
      path: "${routeNames.otpVerify}/:number",
      builder: (BuildContext context, GoRouterState state) {
        final number = state.pathParameters['number']!;

        return OtpVerificationScreen(phoneNumber: number);
      },
    ),
    GoRoute(
      name: routeNames.home,
      path: routeNames.home,
      builder: (BuildContext context, GoRouterState state) {
        return FloatingNavBarScreen();
      },
    ),GoRoute(
      name: routeNames.profile,
      path: routeNames.profile,
      builder: (BuildContext context, GoRouterState state) {
        return MyProfilePage();
      },
    ),
    GoRoute(
      name: routeNames.createProfile,
      path: routeNames.createProfile,
      builder: (BuildContext context, GoRouterState state) {
        return CreateProfileScreen();
      },
    ),GoRoute(
      name: routeNames.SetYourGoalScreen,
      path: routeNames.SetYourGoalScreen,
      builder: (BuildContext context, GoRouterState state) {
        return SetYourGoalScreen();
      },
    ),GoRoute(
      name: routeNames.Mygoalscreen,
      path: routeNames.Mygoalscreen,
      builder: (BuildContext context, GoRouterState state) {
        return Mygoalscreen();
      },
    ),

    // GoRoute(
    //   name: routeNames.demoScreen,
    //   path: routeNames.demoScreen,
    //   builder: (BuildContext context, GoRouterState state) {
    //     return DemoScreen();
    //   },
    // ),

    GoRoute(
      name: routeNames.uploadDocument,
      path:"${routeNames.uploadDocument}/:type",
      builder: (BuildContext context, GoRouterState state) {
        final type = state.pathParameters['type']!;
        return uploadDocumentScreen(recordType: type);
      },
    ),
  ],
);
