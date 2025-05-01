import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:healthvaults/src/features/recordsTab/records/views/editRecordScreen.dart';
import 'package:intl/intl.dart';

import '../../../features/recordsTab/profiles/controller/profileController.dart';
import '../../../features/recordsTab/records/controller/recordController.dart';
import '../../../features/recordsTab/records/views/recordsDetailScreen.dart';
import '../../../modals/record.dart';
import 'dailogs.dart';

class recordItem extends ConsumerWidget {
  final MedicalRecord record;

  const recordItem(this.record, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = ref.watch(selectedRecordIdsProvider).contains(record.id);
    final isSelectionMode = ref.watch(selectionModeProvider);
    final profilesState = ref.watch(profilesProvider); // <-- watch the profiles

    String profileName = 'Unknown';

    profilesState.whenData((profiles) {
      final profile = profiles.firstWhere(
        (p) => p.id == record.pid,
      );
      profileName = profile.firstName ?? 'Unknown';
    });
    return GestureDetector(
      onLongPress: () {
        ref.read(selectionModeProvider.notifier).state = true;
        ref.read(selectedRecordIdsProvider.notifier).toggle(record.id);
      },
      onTap: () {
        if (isSelectionMode) {
          ref.read(selectedRecordIdsProvider.notifier).toggle(record.id);
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => recordDetailScreen(
                        record: record,
                      )));

          // Navigate to details
        }
      },
      child: Card(
        elevation: 0,
        color: isDark ? Colors.white12 : Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
          side: const BorderSide(color: Colors.black54, width: 0.14),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 12),
          leading: Builder(
            builder: (context) {
              if (record.recordType == 'Prescription') {
                return SvgPicture.asset('assets/svg/prescription.svg', height: 40, width: 40);
              } else if (record.recordType == 'LabReport') {
                return SvgPicture.asset('assets/svg/labReport.svg', height: 40, width: 40);
              } else {
                return SvgPicture.asset('assets/svg/record.svg', height: 40, width: 40);
              }
            },
          ),
          title: Text(record.name),
          subtitle: Text(
            "$profileName   ${record.date}   ${record.recordType}",
            style: TextStyle(color: !isDark ? Colors.black54 : Colors.white60, fontSize: 13),
          ),
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
                  onSelected: (value) async {
                    if (value == 'delete') {
                      showDeleteConfirmationDialog(
                        context: context,
                        onConfirm: () async {
                          await ref.read(recordListProvider.notifier).deleteRecords([record.id]);
                        },
                      );

                      // ref.read(RecordProvider.notifier).deleteRecord(record);
                    } else if (value == 'edit') {
                      // Add your edit logic here, maybe open a dialog
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => editRecordScreen(
                                    record: record,
                                  )));
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
      ),
    );
  }
}

Widget recordTile(BuildContext context, WidgetRef ref, int index, MedicalRecord record, bool isSelected, bool isSelectionMode) {
  // final formattedDate = DateFormat('dd/MM/yyyy').format(record.date);
  final profilesState = ref.watch(profilesProvider); // <-- watch the profiles

  String profileName = 'Unknown';

  profilesState.whenData((profiles) {
    final profile = profiles.firstWhere(
      (p) => p.id == record.pid,
    );
    profileName = profile.firstName ?? 'Unknown';
  });
  return Card(
    elevation: 0,
    color: Colors.white,
    margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0),
      side: const BorderSide(color: Colors.black54, width: 0.14),
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.only(left: 12),
      leading: Builder(
        builder: (context) {
          if (record.recordType == 'Prescription') {
            return SvgPicture.asset('assets/svg/prescription.svg', height: 40, width: 40);
          } else if (record.recordType == 'LabReport') {
            return SvgPicture.asset('assets/svg/labReport.svg', height: 40, width: 40);
          } else {
            return SvgPicture.asset('assets/svg/record.svg', height: 40, width: 40);
          }
        },
      ),
      title: Text(record.name),
      subtitle: Text(
        "$profileName   ${record.date}   ${record.recordType}",
        style: TextStyle(color: Colors.black54, fontSize: 13),
      ),
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
              onSelected: (value) async {
                if (value == 'delete') {
                  showDeleteConfirmationDialog(
                    context: context,
                    onConfirm: () async {
                      await ref.read(recordListProvider.notifier).deleteRecords([record.id]);
                    },
                  );

                  // ref.read(RecordProvider.notifier).deleteRecord(record);
                } else if (value == 'edit') {
                  // Add your edit logic here, maybe open a dialog
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => editRecordScreen(
                                record: record,
                              )));
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

String labelForDate(String dateStr) {
  final today = DateTime.now();
  final date = DateFormat('yyyy-MM-dd').parse(dateStr);
  if (DateUtils.isSameDay(date, today)) return "Today";
  if (DateUtils.isSameDay(date, today.subtract(const Duration(days: 1)))) return "Yesterday";
  return DateFormat('dd MMM yyyy').format(date);
}

Map<String, List<MedicalRecord>> groupByFormattedDate(List<MedicalRecord> records) {
  final sorted = [...records]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  final grouped = <String, List<MedicalRecord>>{};

  for (var record in sorted) {
    final dateKey = DateFormat('yyyy-MM-dd').format(record.createdAt);
    grouped.putIfAbsent(dateKey, () => []).add(record);
  }

  return grouped;
}
