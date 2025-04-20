import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthvaults/src/features/goal/views/widgets/monthlyWorkOut.dart';
import 'package:healthvaults/src/features/goal/views/widgets/rowIconText.dart';
import 'package:healthvaults/src/res/appColors.dart';


class RowIconText extends StatelessWidget {
  final IconData? icon;
  final String? image;
  final String text;
  final double iconSize;
  final double textSize;
  final bool isBold;
  final EdgeInsetsGeometry? padding; // Added padding for more flexibility

  const RowIconText({
    Key? key,
     this.icon,
    required this.text,
    required this.iconSize,
    required this.textSize,
    required this.isBold,
    this.padding,  this.image, // Optional padding
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: padding ?? const EdgeInsets.symmetric(vertical: 6.0), // Use provided padding or default
          child: icon == null ? Image.asset(image!, height: iconSize,): Icon(
            icon,
            size: iconSize,
            color: AppColors.primaryColor,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              text,
              style: TextStyle(
                fontSize: textSize,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class WeeklyRow extends StatelessWidget {
  final String day;
  final IconData? icon;
  final String? image;
  final String text;
  final double iconSize;
  final double textSize;
  final bool isBold;
  final EdgeInsetsGeometry? padding;

  const WeeklyRow({
    super.key,
    required this.day,
     this.icon,
    required this.text,
    required this.iconSize,
    required this.textSize,
    required this.isBold,
    this.padding, this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.circle, size: 12),
          SizedBox(width: 12),
          Text(
            "$day - ",
            style: TextStyle(
              fontSize: textSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: RowIconText(
              icon: icon,
              image: image,
              text: text,
              iconSize: iconSize,
              textSize: textSize,
              isBold: isBold,
            ),
          ),
        ],
      ),
    );
  }
}
