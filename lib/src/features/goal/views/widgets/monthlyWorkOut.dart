import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthvaults/src/features/goal/views/widgets/monthlyWorkOut.dart';
import 'package:healthvaults/src/features/goal/views/widgets/rowIconText.dart';

import '../../../../res/appImages.dart';
import '../../../../res/const.dart';
class MonthlyWorkoutSection extends StatelessWidget {
  final String title;
  final Map<String, List<Map<String, dynamic>>> monthData;

  const MonthlyWorkoutSection({
    super.key,
    required this.title,
    required this.monthData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        RowIconText(
          image: appImages.calender,
          text: title,
          iconSize: 38,
          textSize: 28,
          isBold: true,
        ),
        const SizedBox(height: 8),
        ...monthData.entries.expand((entry) {
          final workout = entry.key;
          final list = entry.value;

          return [
            RowIconText(
              image: Constants.getIconPath(workout),
              text: workout,
              iconSize: 30,
              textSize: 23,
              isBold: true,
            ),
            ...list.map((item) {
              final exerciseDetail = item.values.firstOrNull?.toString() ?? '';
              final reps = item['reps'];

              return RowIconText(
                icon: Icons.check,
                text: "$exerciseDetail${reps == null ? "" : " - $reps"}",
                iconSize: 18,
                textSize: 18,
                isBold: false,
                padding: const EdgeInsets.only(left: 24),
              );
            }),
          ];
        }),
      ],
    );
  }
}

