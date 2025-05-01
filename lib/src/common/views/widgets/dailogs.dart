import 'package:flutter/material.dart';

void showDeleteConfirmationDialog({
  required BuildContext context,
  required VoidCallback onConfirm,
  VoidCallback? onCancel,
  String title = 'Confirm Delete',
  String content = "Records can't be recovered once deleted.",
  String confirmText = 'Delete',
  String cancelText = 'Cancel',
  Color confirmTextColor = Colors.lightBlueAccent,
}) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(ctx);
            if (onCancel != null) onCancel();
          },
          child: Text(cancelText ,style: TextStyle(color: confirmTextColor)),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            onConfirm();
          },
          child: Text(confirmText, style: TextStyle(color: confirmTextColor)),
        ),
      ],
    ),
  );
}
