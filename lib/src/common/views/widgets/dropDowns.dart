
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class selectAgeDropdownBox extends StatelessWidget {
  final String? selectedValue;
  final Function(String) onChanged;

  selectAgeDropdownBox({
    required this.selectedValue,
    required this.onChanged,
  });

  final List<String> options = ['Male', 'Female', 'Prefer Not to say'];

  void _showOptionsMenu(BuildContext context) async {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final String? result = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + renderBox.size.height,
        offset.dx + renderBox.size.width,
        offset.dy,
      ),
      items: options.map((value) {
        return PopupMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );

    if (result != null) {
      onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Gender", style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 6),
        InkWell(
          onTap: () => _showOptionsMenu(context),
          child: InputDecorator(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
            child: Text(
              selectedValue ?? 'Select Gender',
            ),
          ),
        ),
      ],
    );
  }
}

