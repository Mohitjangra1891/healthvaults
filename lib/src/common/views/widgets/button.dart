import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class button_Primary extends StatelessWidget {

  const button_Primary({super.key, required this.onPressed, required this.title});
  final VoidCallback onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return   ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(screenWidth, screenHeight * 0.06),
        backgroundColor: CupertinoColors.activeBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          title,
          style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
    );
  }
}


