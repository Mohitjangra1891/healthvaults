import 'package:flutter/material.dart';

import '../../res/appColors.dart';

final ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  brightness: Brightness.light,
  primaryColor: AppColors.primaryColor,
  textTheme: TextTheme(
    titleLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
  ),  hintColor: Colors.blueAccent,
  // Define additional light theme properties here
);
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.white10,
  primaryColor: Colors.grey[900],
  hintColor: Colors.blueAccent,
  // Define additional dark theme properties here
);
