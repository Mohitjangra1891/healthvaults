import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LocationPicker extends StatelessWidget {
  final String? selected; // “home” or “gym”
  final ValueChanged<String> onChanged;
  const LocationPicker({ required this.selected, required this.onChanged });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color bg(bool active) => active
        ? Colors.blue
        : (isDark ? Colors.grey[800]! : Colors.grey[200]!);
    Color fg(bool active) => active ? Colors.white : Colors.black87;

    return Row(
      children: [
        _buildButton('home', Icons.home, bg(selected=='home'), fg(selected=='home')),
        const SizedBox(width: 12),
        _buildButton('gym', Icons.fitness_center, bg(selected=='gym'), fg(selected=='gym')),
      ],
    );
  }

  Widget _buildButton(String value, IconData icon, Color bg, Color fg) {
    return Expanded(
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(12),
        color: bg,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onChanged(value),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: fg),
                const SizedBox(width: 8),
                Text(
                  value == 'home' ? 'Home' : 'Gym',
                  style: TextStyle(color: fg, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EquipmentSelector extends StatefulWidget {
  final List<String> allItems;
  final ValueChanged<List<String>> onChanged;

  EquipmentSelector({ required this.allItems, required this.onChanged });

  @override
  _EquipmentSelectorState createState() => _EquipmentSelectorState();
}

class _EquipmentSelectorState extends State<EquipmentSelector> {
  final _selected = <String>[];
  final _otherController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Grid buttons
        Wrap(
          spacing: 12, runSpacing: 12,
          children: widget.allItems.map((item) {
            final active = _selected.contains(item);
            return _buildEquipButton(item, active);
          }).toList(),
        ),

        const SizedBox(height: 16),

        // Chips
        Wrap(
          spacing: 8, runSpacing: 8,
          children: _selected.map((item) => Chip(
            label: Text(item),
            onDeleted: () => _toggle(item),
          )).toList(),
        ),

        const SizedBox(height: 12),

        // “Other” text field + add button
        Row(
          children: [
            Expanded(
              child: TextField(
                onTapOutside: (PointerDownEvent) {
                  FocusScope.of(context).unfocus();
                },
                controller: _otherController,
                decoration: InputDecoration(
                  hintText: 'Other equipments…',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: CupertinoColors.activeBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                final txt = _otherController.text.trim();
                if (txt.isEmpty || _selected.contains(txt)) return;
                _toggle(txt);
                _otherController.clear();
              },
              child: Text('ADD'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEquipButton(String item, bool active) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = active
        ? Colors.blue
        : (isDark ? Colors.grey[800]! : Colors.grey[200]!);
    final fg = active ? Colors.white : Colors.black87;
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      color: bg,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _toggle(item),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
            /* you can swap in icons by mapping item→IconData */
            Icon(Icons.fitness_center, color: fg),
            SizedBox(width: 8),
            Text(item, style: TextStyle(color: fg)),
            ],
          ),
        ),
      ),
    );
  }

  void _toggle(String item) {
    setState(() {
      if (_selected.contains(item))
        _selected.remove(item);
      else
        _selected.add(item);
      widget.onChanged(_selected);
    });
  }
}
class GoalPicker extends StatefulWidget {
  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;
  GoalPicker({ required this.selected, required this.onChanged });

  @override
  State<GoalPicker> createState() => _GoalPickerState();
}

class _GoalPickerState extends State<GoalPicker> {
  final goals = const [
    {'key':'lose', 'label':'Lose Weight', 'icon': Icons.scale},
    {'key':'build','label':'Build Strength','icon': Icons.fitness_center},
    {'key':'flex','label':'Improve Flexibility & Mobility','icon': Icons.self_improvement},
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12, runSpacing: 12,
      children: goals.map((g) {
        final active = widget.selected.contains(g['key']);
        return _goalButton("goal", "label", g['icon'] as IconData, active);
      }).toList(),
    );
  }

  Widget _goalButton(String key, String label, IconData icon, bool active) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = active
        ? Colors.blue
        : (isDark ? Colors.grey[800]! : Colors.grey[200]!);
    final fg = active ? Colors.white : Colors.black87;

    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(12),
      color: bg,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          final newSet = Set<String>.from(widget.selected);
          if (active) newSet.remove(key); else newSet.add(key);
          widget.onChanged(newSet);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: fg),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(color: fg, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
