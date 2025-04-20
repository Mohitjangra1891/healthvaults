import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/utils/router.dart';

import '../../../res/appColors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void _getStarted() {
    // Navigate to home or login screen
    print("Get Started clicked");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentPage = index),
              children: [
                _buildPage("Welcome", "This is the first page."),
                _buildPage("Discover", "This is the second page."),
                _buildPage("Get Started", "This is the third page."),
              ],
            ),
          ),
          _buildButtons(),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPage(String title, String description) {
    return Container(
      padding: EdgeInsets.all(24),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Text(description, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    if (_currentPage == 0) {
      return ElevatedButton(
        onPressed: _nextPage,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          "Next",
          style: TextStyle(color: Colors.white),
        ),
      );
    } else if (_currentPage == 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _prevPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              "Back",
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(
            width: 12,
          ),
          ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              "Next",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _prevPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              "Back",
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(
            width: 12,
          ),
          ElevatedButton(
            onPressed: () {
              context.go(routeNames.login);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              "Get Started",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      );
    }
  }
}
