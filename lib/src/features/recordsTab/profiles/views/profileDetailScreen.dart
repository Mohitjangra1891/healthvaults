import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/features/recordsTab/recordTabScreen.dart';

import '../../../../common/views/widgets/recordItem.dart';
import '../../../../modals/authModel.dart';
import '../../../../res/appColors.dart';
import '../../records/controller/recordController.dart';
import '../../records/views/recordsDetailScreen.dart';
import '../controller/profileController.dart';

class profileDetailScreen extends ConsumerWidget {
  final Profile profile;

  const profileDetailScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    debugPrint('🔄 Widget rebuilt: ${context.widget.runtimeType}');

    return WillPopScope(
      onWillPop: () async {
        final isSelectionMode = ref.read(selectionModeProvider);
        if (isSelectionMode) {
          ref.read(selectionModeProvider.notifier).state = false;
          return false; // Stop back navigation
        }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: _AppBar(profile),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                ProfileRecordsScreen(
                  profileId: profile.id!,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileRecordsScreen extends ConsumerStatefulWidget {
  final String profileId;

  const ProfileRecordsScreen({super.key, required this.profileId});

  @override
  ConsumerState<ProfileRecordsScreen> createState() => _RecordListScreenState();
}

class _RecordListScreenState extends ConsumerState<ProfileRecordsScreen> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final recordAsync = ref.watch(recordListProvider);
    final records = ref.watch(filteredRecordListProvider(widget.profileId));
    final searchQuery = ref.watch(profileRecordsSearchQueryProvider).toLowerCase();

    final filteredRecords = searchQuery.isEmpty ? records : records.where((record) => record.name.toLowerCase().contains(searchQuery)).toList();
    final grouped = groupByFormattedDate(filteredRecords);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    debugPrint('🔄 Widget rebuilt: ${context.widget.runtimeType}');

    return Expanded(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            // padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: TextFormField(
              controller: _controller,
              focusNode: _focusNode,
              onTapOutside: (event) {
                print("on tap outside");
                // If it's already focused, unfocus to close keyboard
                if (_focusNode.hasFocus) {
                  _focusNode.unfocus();
                }
              },
              onChanged: (value) {
                ref.read(profileRecordsSearchQueryProvider.notifier).state = value;
              },
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(fontSize: 14),
                prefixIcon: Icon(
                  CupertinoIcons.search,
                ),
                suffixIcon: ref.watch(profileRecordsSearchQueryProvider).isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          ref.read(profileRecordsSearchQueryProvider.notifier).state = '';
                          _focusNode.unfocus(); // Optional: Hide keyboard after clear
                        },
                      )
                    : null,
                contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),

                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none, // border: OutlineInputBorder( borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
          ),
          NotificationListener<ScrollNotification>(
            onNotification: (scroll) {
              if (scroll.metrics.pixels == scroll.metrics.maxScrollExtent) {
                // ref.read(recordListProvider.notifier).fetchMore();
              }
              return false;
            },
            child: Expanded(
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

                        return Consumer(
                          builder: (context, ref, _) {
                            final isSelected = ref.watch(selectedRecordIdsProvider).contains(record.id);
                            final isSelectionMode = ref.watch(selectionModeProvider);

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
                              child: recordTile(context, ref, index, record, isSelected, isSelectionMode),
                            );
                          },
                        );
                      }),
                    ],
                  );
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// class ProfileRecordsScreen extends ConsumerWidget {
//   final String profileId;
//
//   const ProfileRecordsScreen({super.key, required this.profileId});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final records = ref.watch(filteredRecordListProvider(profileId));
//
//     final grouped = groupByFormattedDate(records);
//
//     return Expanded(
//       child: ListView(
//         children: grouped.entries.map((entry) {
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 12.0),
//                 child: Text(
//                   labelForDate(entry.key),
//                   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                 ),
//               ),
//               ...List.generate(entry.value.length, (index) {
//                 final record = entry.value[index];
//                 return Consumer(
//                   builder: (context, ref, _) {
//                     final isSelected = ref.watch(selectedRecordIdsProvider).contains(record.id);
//                     final isSelectionMode = ref.watch(selectionModeProvider);
//
//                     return GestureDetector(
//                       onLongPress: () {
//                         ref.read(selectionModeProvider.notifier).state = true;
//                         ref.read(selectedRecordIdsProvider.notifier).toggle(record.id);
//                       },
//                       onTap: () {
//                         if (isSelectionMode) {
//                           ref.read(selectedRecordIdsProvider.notifier).toggle(record.id);
//                         }
//                       },
//                       child: recordTile(context, ref, index, record, isSelected, isSelectionMode),
//                     );
//                   },
//                 );
//               }),
//             ],
//           );
//         }).toList(),
//       ),
//     );
//   }
// }

class _AppBar extends ConsumerWidget {
  final Profile profile;

  const _AppBar(this.profile, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('🔄 _AppBar rebuilt: ${context.widget.runtimeType}');

    final selectedIndexes = ref.watch(selectedRecordIdsProvider);
    final isSelectionMode = ref.watch(selectionModeProvider);

    return isSelectionMode ? buildSelectionAppBar(context, ref, selectedIndexes) : _buildNormalAppBar(context, ref);
  }

  Widget _buildNormalAppBar(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BackButton(),
          Container(
            // width: 60,
            // height: 60,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white),
            ),
            child: Center(child: Text(profile.firstName![0].toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 22))),
          ),
          SizedBox(
            width: 12,
          ),
          Text('${profile.firstName!} ${profile.lastName!}'),
          Spacer(),
          PopupMenuButton<String>(
            position: PopupMenuPosition.under,
            onSelected: (value) async {
              if (value == 'select') {
                ref.read(selectionModeProvider.notifier).state = true;
              }
              if (value == 'delete') {
                await ref.read(profilesProvider.notifier).deleteProfile(profile.profileId!);
                context.pop();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'select',
                child: Text('Select Items'),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('Delete Profile'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
