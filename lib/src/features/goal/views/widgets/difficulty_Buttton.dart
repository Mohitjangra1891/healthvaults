import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class difficulty_Buttton extends StatelessWidget {
  const difficulty_Buttton({super.key, required this.onPressed, required this.title, required this.image, required this.color});

  final VoidCallback onPressed;
  final String title;
  final String image;
  final Color color;


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: CupertinoColors.activeBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              image,
              height: 24,
              width: 24,
              colorFilter:  ColorFilter.mode(color, BlendMode.srcATop), // Apply dark green color filter
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(width: 6),

          ],
        ),
      ),
    );
  }
}
