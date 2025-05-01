import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/views/widgets/recordItem.dart';
import '../../../../res/appColors.dart';
import '../../records/controller/recordController.dart';

class RecordListScreen extends ConsumerStatefulWidget {
  const RecordListScreen({super.key});

  @override
  ConsumerState<RecordListScreen> createState() => _RecordListScreenState();
}

class _RecordListScreenState extends ConsumerState<RecordListScreen> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final recordAsync = ref.watch(recordListProvider);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    debugPrint('🔄 Widget rebuilt: ${context.widget.runtimeType}');

    return Expanded(
      child: Column(
        children: [
          Consumer(
            builder: (context, ref, _) {
              final searchQuery = ref.watch(searchQueryProvider);
              return Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.black38 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextFormField(
                  controller: _controller,
                  focusNode: _focusNode,
                  onTapOutside: (event) {
                    if (_focusNode.hasFocus) {
                      _focusNode.unfocus();
                    }
                  },
                  onChanged: (value) {
                    ref.read(searchQueryProvider.notifier).state = value;
                  },
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: TextStyle(fontSize: 14),
                    prefixIcon: Icon(CupertinoIcons.search),
                    suffixIcon: searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              _controller.clear();
                              ref.read(searchQueryProvider.notifier).state = '';
                              _focusNode.unfocus();
                            },
                          )
                        : null,
                    contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                    border: InputBorder.none,
                  ),
                ),
              );
            },
          ),
          recordAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text("Error: $e")),
            data: (records) {
              final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

              final filteredRecords =
                  searchQuery.isEmpty ? records : records.where((record) => record.name.toLowerCase().contains(searchQuery)).toList();
              final grouped = groupByFormattedDate(filteredRecords);

              return Expanded(
                child: ListView(
                  children: grouped.entries.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            labelForDate(entry.key),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        ...List.generate(entry.value.length, (index) {
                          final record = entry.value[index];

                          // return Consumer(
                          //   builder: (context, ref, _) {
                          //     final isSelected = ref.watch(selectedRecordIdsProvider).contains(record.id);
                          //     final isSelectionMode = ref.watch(selectionModeProvider);
                          //
                          //     return GestureDetector(
                          //       onLongPress: () {
                          //         ref.read(selectionModeProvider.notifier).state = true;
                          //         ref.read(selectedRecordIdsProvider.notifier).toggle(record.id);
                          //       },
                          //       onTap: () {
                          //         if (isSelectionMode) {
                          //           ref.read(selectedRecordIdsProvider.notifier).toggle(record.id);
                          //         } else {
                          //           Navigator.push(
                          //               context,
                          //               MaterialPageRoute(
                          //                   builder: (context) => recordDetailScreen(
                          //                         record: record,
                          //                       )));
                          //
                          //           // Navigate to details
                          //         }
                          //       },
                          //       child: recordTile(context, ref, index, record, isSelected, isSelectionMode),
                          //     );
                          //   },
                          // );
                          return recordItem(record);
                        }),
                      ],
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
