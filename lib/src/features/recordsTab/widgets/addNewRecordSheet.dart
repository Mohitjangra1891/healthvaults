import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/utils/router.dart';

import '../../../res/appColors.dart';

void showCustomBottomSheet(BuildContext context) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  showModalBottomSheet(
    context: context,
    backgroundColor: theme.scaffoldBackgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              height: 5,
              width: 40,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[700] : Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),
            _buildSheetItem(Icons.medical_services, 'Prescription', Colors.teal, context),
            _buildSheetItem(Icons.edit, 'Lab Reports', Colors.purple, context),
            _buildSheetItem(Icons.receipt_long, 'Medical Bill', AppColors.primaryColor, context),
          ],
        ),
      );
    },
  );
}

Widget _buildSheetItem(IconData icon, String title, Color iconColor, BuildContext context) {
  final textColor = Theme.of(context).textTheme.bodyLarge?.color;

  return ListTile(
    leading: CircleAvatar(
      backgroundColor: iconColor.withOpacity(0.15),
      child: Icon(icon, color: iconColor),
    ),
    title: Text(title, style: TextStyle(color: textColor, fontSize: 16)),
    trailing: Icon(Icons.chevron_right, color: textColor),
    onTap: () {
      context.pop();
      context.push("${routeNames.uploadDocument}/${title}");

      // Handle tap
    },
  );
}
