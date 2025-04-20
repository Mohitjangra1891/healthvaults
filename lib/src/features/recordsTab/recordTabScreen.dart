import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthvaults/src/features/recordsTab/widgets/docsListView.dart';
import 'package:healthvaults/src/features/recordsTab/widgets/profileListView.dart';

import 'controller/recordController.dart';

class RecordsTabScreen extends ConsumerStatefulWidget {
  const RecordsTabScreen({super.key});

  @override
  ConsumerState<RecordsTabScreen> createState() => _healthTabScreenState();
}

class _healthTabScreenState extends  ConsumerState<RecordsTabScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // 🛡️ This keeps your tab alive

  @override
  Widget build(BuildContext context) {
    super.build(context); // IMPORTANT for keep alive!

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
                      IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
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
              // _topSection(context),
              profileListView(),
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

  // Widget _topSection(BuildContext context) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //
  //     ],
  //   );
  // }
}
