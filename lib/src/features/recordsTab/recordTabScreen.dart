import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthvaults/src/features/recordsTab/profiles/views/profileListView.dart';
import 'package:healthvaults/src/features/recordsTab/records/views/docsListView.dart';

import '../../common/views/widgets/dailogs.dart';
import 'records/controller/recordController.dart';

class RecordsTabScreen extends ConsumerStatefulWidget {
  const RecordsTabScreen({super.key});

  @override
  ConsumerState<RecordsTabScreen> createState() => _healthTabScreenState();
}

class _healthTabScreenState extends ConsumerState<RecordsTabScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // 🛡️ This keeps your tab alive

  @override
  Widget build(BuildContext context) {
    super.build(context); // IMPORTANT for keep alive!

    debugPrint('🔄 Widget rebuilt: ${context.widget.runtimeType}');

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: const _AppBar(),
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 18, right: 18, top: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // _topSection(context),
              profileListView(),

              // docsListWidget()
              RecordListScreen()
            ],
          ),
        ),
      ),
    );
  }

}

Widget buildSelectionAppBar(BuildContext context, WidgetRef ref, Set<String> selectedIndexes) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      BackButton(
        onPressed: () {
          ref.read(selectionModeProvider.notifier).state = false;
          ref.read(selectedRecordIdsProvider.notifier).clear();
        },
      ),
      Text('Selected ${selectedIndexes.length} items', style: TextStyle(fontSize: 22)),
      Spacer(),
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          showDeleteConfirmationDialog(
            context: context,
            onConfirm: () async {
              await ref.read(recordListProvider.notifier).deleteRecords(selectedIndexes.toList());
              ref.read(selectedRecordIdsProvider.notifier).clear();
              ref.read(selectionModeProvider.notifier).state = false;
            },
          );
        },
      ),
      IconButton(icon: Icon(Icons.share), onPressed: () {}),
    ],
  );
}

class _AppBar extends ConsumerWidget {
  const _AppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('🔄 _AppBar rebuilt: ${context.widget.runtimeType}');

    final selectedIndexes = ref.watch(selectedRecordIdsProvider);
    final isSelectionMode = ref.watch(selectionModeProvider);

    return isSelectionMode ? buildSelectionAppBar(context, ref, selectedIndexes) : _buildNormalAppBar(context, ref);
  }

  Widget _buildNormalAppBar(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('My Records', style: TextStyle(fontSize: 22)),
          const Spacer(),
          PopupMenuButton<String>(
            position: PopupMenuPosition.under,
            onSelected: (value) {
              if (value == 'select') {
                ref.read(selectionModeProvider.notifier).state = true;
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem<String>(
                value: 'select',
                child: Text('Select Items'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
