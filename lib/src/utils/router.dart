import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/common/views/SplashScreen.dart';
import 'package:healthvaults/src/features/auth/views/addUserDetailsScreen.dart';
import 'package:healthvaults/src/features/auth/views/loginScreen.dart';
import 'package:healthvaults/src/features/auth/views/otpVerifyScreen.dart';
import 'package:healthvaults/src/homePage.dart';

import '../features/auth/views/onboardingScreen.dart';
import '../features/goal/views/myGoalScreen.dart';
import '../features/goal/views/setYourGoalScreen.dart';

import '../features/healthTab/views/myProfile/myProfileScreen.dart';

import '../features/recordsTab/profiles/views/addNewProfileScreen.dart';
import '../features/recordsTab/records/views/uploadDocument.dart';
import '../modals/record.dart';

class routeNames {
  static String splash = '/splash';
  static String onboarding = '/onboarding';
  static String home = '/home';
  static String login = '/login';
  static String addDetails = '/addDetails';
  static String otpVerify = '/otpVerify';
  static String profile = '/profile';
  static String createProfile = '/createProfile';
  static String uploadDocument = '/uploadDocument';
  static String Mygoalscreen = '/Mygoalscreen';
  static String SetYourGoalScreen = '/SetYourGoalScreen';
  static String demoScreen = '/demoScreen';
}

final GoRouter router = GoRouter(
  initialLocation: routeNames.splash,
  routes: [
    GoRoute(
      name: routeNames.splash,
      path: routeNames.splash,
      builder: (BuildContext context, GoRouterState state) {
        return Splashscreen();
      },
    ),  GoRoute(
      name: routeNames.onboarding,
      path: routeNames.onboarding,
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
    ), GoRoute(
      name: routeNames.addDetails,
      path: "${routeNames.addDetails}/:number",
      builder: (BuildContext context, GoRouterState state) {
        final number = state.pathParameters['number']!;

        return addUserDetailsScreen( number);
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
