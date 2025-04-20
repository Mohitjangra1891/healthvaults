
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../res/appColors.dart';
import '../../../../utils/router.dart';

class noPlanScreen extends StatelessWidget {
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

