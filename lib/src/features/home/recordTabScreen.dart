import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/modals/record.dart';
import 'package:healthvaults/src/utils/router.dart';
import 'package:intl/intl.dart';

import '../../res/appColors.dart';
import 'controller/profileController.dart';
import 'controller/recordController.dart';

class RecordsScreen extends ConsumerWidget {
  const RecordsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndexes = ref.watch(selectedRecordIndexesProvider);
    final isSelectionMode = ref.watch(selectionModeProvider);

    return SafeArea(
      child: Scaffold(
        appBar: isSelectionMode
            ? PreferredSize(
                preferredSize: Size.fromHeight(70),
                child: Builder(
                  builder: (context) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BackButton(
                        onPressed: () {
                          ref.read(selectionModeProvider.notifier).state = false;

                          ref.read(selectedRecordIndexesProvider.notifier).clear();
                        },
                      ),
                      Text(
                        'Selected${selectedIndexes.length} items',
                        style: TextStyle(fontSize: 22),
                      ),
                      Spacer(),
                      IconButton(icon: Icon(Icons.delete), onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Delete Selected Records'),
                            content: Text('Are you sure you want to delete the selected records?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(false),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(true),
                                child: Text('Delete', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          final selectedIndexes = ref.read(selectedRecordIndexesProvider);
                          final allRecords = ref.read(RecordProvider);
                          final selectedRecords = selectedIndexes.map((i) => allRecords[i]).toList();

                          for (final record in selectedRecords) {
                            ref.read(RecordProvider.notifier).deleteRecord(record);
                          }

                          ref.read(selectedRecordIndexesProvider.notifier).clear();
                          ref.read(selectionModeProvider.notifier).state = false;
                        }

                      }),
                      IconButton(icon: Icon(Icons.share), onPressed: () {}),
                    ],
                  ),
                ),
              )
            : PreferredSize(
                preferredSize: Size.fromHeight(70),
                child: Builder(
                  builder: (context) => Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'My Records',
                          style: TextStyle(fontSize: 22),
                        ),
                        Spacer(),
                        PopupMenuButton<String>(
                          position: PopupMenuPosition.under,
                          onSelected: (value) {
                            if (value == 'select') {
                              // ref.read(selectedRecordIndexesProvider.notifier).toggle();
                              ref.read(selectionModeProvider.notifier).state = true;

                            }
                          },
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'select',
                              child: Text('Select Items'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
        body: Padding(
          padding: EdgeInsets.only(left: 18, right: 18, top: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topSection(context),

              // "Today"
              Text(
                "Today",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              docsListWidget()
            ],
          ),
        ),
      ),
    );
  }

  Widget _topSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 80,
          child: Consumer(
            builder: (context, ref, _) {
              final profiles = ref.watch(profileListProvider);

              return ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...profiles.map((p) => _profileCircle(p.letter, p.name)),
                  _addProfileButton(context),
                ],
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Search",
              hintStyle: TextStyle(fontSize: 12),
              prefixIcon: Icon(
                CupertinoIcons.search,
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
          ),
        ),
      ],
    );
  }

  Widget _profileCircle(String letter, String name) {
    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: Container(
        width: 60,
        height: 60,
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white),
              ),
              child: Center(child: Text(letter, style: TextStyle(color: Colors.white, fontSize: 22))),
            ),
            const SizedBox(height: 4),
            Text(name,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                )),
          ],
        ),
      ),
    );
  }

  Widget _addProfileButton(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        InkWell(
          onTap: () {
            context.pushNamed(routeNames.createProfile);
          },
          child: Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            shape: CircleBorder(side: BorderSide(color: Colors.black54, width: 0.2)),
            child: Container(
                width: 60,
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  // color: isDark ? Colors.black45 : Colors.black12,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white),
                ),
                child: Icon(Icons.add_circle_outline_rounded, color: isDark ? Colors.white : AppColors.primaryColor)),
          ),
        ),
        const SizedBox(height: 4),
        const Text("Add Profile",
            style: TextStyle(
              fontSize: 12,
            )),
      ],
    );
  }
}

class docsListWidget extends ConsumerWidget {
  const docsListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndexes = ref.watch(selectedRecordIndexesProvider);
    final isSelectionMode = ref.watch(selectionModeProvider);
    final records = ref.watch(RecordProvider);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    Widget _recordTile(BuildContext context, WidgetRef ref, int index, RecordModel record, bool isSelected, bool isSelectionMode) {
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
              child: _recordTile(context, ref, index, record, isSelected, isSelectionMode));
        },
      ),
    );
  }
}
