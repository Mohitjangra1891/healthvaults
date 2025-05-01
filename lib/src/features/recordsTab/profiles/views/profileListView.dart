import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/res/appColors.dart';
import 'package:healthvaults/src/utils/router.dart';

import '../../../../common/views/widgets/imagwWidget.dart';
import '../../records/controller/recordController.dart';
import '../controller/profileController.dart';
import 'profileDetailScreen.dart';

class profileListView extends ConsumerWidget {
  const profileListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final profiles = ref.watch(profileListProvider);
    final profiles = ref.watch(profilesProvider);

    return SizedBox(
      height: 90,
      child: profiles.when(
        data: (profiles) => ListView(
          scrollDirection: Axis.horizontal,
          children: [
            ...profiles.map((p) {
              String firstLetter = p.firstName![0].toUpperCase();

              return _profileCircle(firstLetter, p.dp, p.firstName!, () {
                ref.read(selectionModeProvider.notifier).state = false;

                Navigator.push(context, MaterialPageRoute(builder: (context) => profileDetailScreen(profile: p)));
              });
            }).toList(),
            _addProfileButton(context),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }
}

Widget _profileCircle(String letter, String? dp, String name, final VoidCallback onPressed) {
  return InkWell(
    onTap: onPressed,
    child: Padding(
      padding: const EdgeInsets.only(right: 24),
      child: Container(
        width: 60,
        height: 60,
        child: Column(
          children: [
            dp != ""
                ? DownloadedImageViewer(
                    imageUrl: dp!,
              letter: letter,
                  )
                : Container(
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
