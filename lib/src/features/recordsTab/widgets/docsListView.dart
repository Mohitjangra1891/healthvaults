import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/modals/record.dart';
import 'package:healthvaults/src/utils/router.dart';
import 'package:intl/intl.dart';

import '../controller/recordController.dart';

class docsListWidget extends ConsumerWidget {
  const docsListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndexes = ref.watch(selectedRecordIndexesProvider);
    final isSelectionMode = ref.watch(selectionModeProvider);
    final records = ref.watch(RecordProvider);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    debugPrint('🔄 Widget rebuilt: ${context.widget.runtimeType}');

    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        // physics: NeverScrollableScrollPhysics(),
        itemCount: records.length,
        itemBuilder: (context, index) {
          final record = records[index];
          final isSelected = selectedIndexes.contains(index);

          return GestureDetector(
              onLongPress: () {
                ref.read(selectionModeProvider.notifier).state = true;

                ref.read(selectedRecordIndexesProvider.notifier).toggle(index);
              },
              onTap: () {
                if (isSelectionMode) {
                  ref.read(selectedRecordIndexesProvider.notifier).toggle(index);
                } else {
                  // Navigate to detail page
                  // context.pushNamed("recordDetail", extra: record);
                }
              },
              child: recordTile(context, ref, index, record, isSelected, isSelectionMode));
        },
      ),
    );
  }
}

Widget recordTile(BuildContext context, WidgetRef ref, int index, RecordModel record, bool isSelected, bool isSelectionMode) {
  final formattedDate = DateFormat('dd/MM/yyyy').format(record.createdAt);

  return Card(
    elevation: 0,
    margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0),
      side: const BorderSide(color: Colors.black54, width: 0.2),
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.only(left: 12),
      leading: const CircleAvatar(
        backgroundColor: Colors.teal,
        child: Icon(Icons.medical_services, color: Colors.white),
      ),
      title: Text(record.name),
      subtitle: Text("${record.name}   $formattedDate   ${record.type}"),
      trailing: isSelectionMode
          ? Checkbox(
        value: isSelected,
        onChanged: (_) {},
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        activeColor: Colors.teal,
      )
          : PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        position: PopupMenuPosition.under,
        onSelected: (value) {
          if (value == 'delete') {
            ref.read(RecordProvider.notifier).deleteRecord(record);
          } else if (value == 'edit') {
            // Add your edit logic here, maybe open a dialog
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'share',
            child: Text('Share'),
          ),
          const PopupMenuItem<String>(
            value: 'delete',
            child: Text('Delete'),
          ),
          const PopupMenuItem<String>(
            value: 'edit',
            child: Text('Edit Record'),
          ),
        ],
      ),
    ),
  );
}
