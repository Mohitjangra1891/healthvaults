import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/utils/router.dart';

void add_New_RECORD_BottomSheet(BuildContext context) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  showModalBottomSheet(
    context: context,
    backgroundColor:  isDark ? Colors.black : Colors.white,
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
            _buildSheetItem('assets/svg/prescription.svg', 'Prescription', context),
            _buildSheetItem('assets/svg/labReport.svg', 'LabReport', context),
            _buildSheetItem('assets/svg/record.svg', 'MedicalBill', context),
          ],
        ),
      );
    },
  );
}

Widget _buildSheetItem(String image, String type, BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Card(
    elevation: 0,
    color: isDark ? Colors.white12 : Colors.white,
    margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0),
      side: const BorderSide(color: Colors.black54, width: 0.14),
    ),
    child: ListTile(
      leading: CircleAvatar(
        // backgroundColor: iconColor.withOpacity(0.15),
        // child: Image.asset(image),
        child: SvgPicture.asset(
          image,
          // height: 24,
          // width: 24,
          // colorFilter:  ColorFilter.mode(color, BlendMode.srcATop), // Apply dark green color filter
        ),
      ),
      title: Text(type, style: TextStyle( fontSize: 16)),
      trailing: Icon(Icons.chevron_right,),
      onTap: () {
        context.pop();
        context.push("${routeNames.uploadDocument}/${type}");

        // Handle tap
      },
    ),
  );
}
