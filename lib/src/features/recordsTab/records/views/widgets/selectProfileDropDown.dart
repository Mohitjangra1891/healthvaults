import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../modals/authModel.dart';
import '../../../profiles/controller/profileController.dart';




import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class selectProfileDropdownBox extends ConsumerStatefulWidget {
  final void Function(String selectedId) onSelected;
  const selectProfileDropdownBox({super.key, required this.onSelected});

  @override
  ConsumerState<selectProfileDropdownBox> createState() => _CustomDropdownBoxState();
}

class _CustomDropdownBoxState extends ConsumerState<selectProfileDropdownBox> {
  String? selectedName;

  void _showOptionsMenu(List<Profile> profiles) async {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Profile? selectedProfile = await showMenu<Profile>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + renderBox.size.height,
        offset.dx + renderBox.size.width,
        offset.dy,
      ),
      items: profiles.map((profile) {
        return PopupMenuItem<Profile>(
          value: profile,
          child: Text('${profile.firstName} ${profile.lastName}'),
        );
      }).toList(),
    );

    if (selectedProfile != null) {
      setState(() {
        selectedName = selectedProfile.firstName;
      });
      widget.onSelected(selectedProfile.id!); // 🔁 Return selected id to parent
    }
  }

  @override
  Widget build(BuildContext context) {
    final profilesAsync = ref.watch(profilesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select Profile", style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 6),
        profilesAsync.when(
          data: (profiles) {
            return InkWell(
              onTap: () => _showOptionsMenu(profiles),
              child: InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
                child: Text(selectedName ?? 'Tap to choose a profile'),
              ),
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (e, st) => Text('Error: $e'),
        ),
      ],
    );
  }
}
