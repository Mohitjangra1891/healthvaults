import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../res/appColors.dart';
import '../../../utils/router.dart';
import '../controller/profileController.dart';

class profileListView extends ConsumerWidget {
  const profileListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profiles = ref.watch(profileListProvider);

    return SizedBox(
        height: 80,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            ...profiles.map((p) => _profileCircle(p.letter, p.name)),
            _addProfileButton(context),
          ],
        ));
  }
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
