import 'package:flutter/material.dart';

class WeekdaySelector extends StatelessWidget {
  final Set<int> selectedIndices;

  final ValueChanged<Set<int>> onChanged;

  const WeekdaySelector({Key? key, required this.selectedIndices, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(days.length, (i) {
        final isSelected = selectedIndices.contains(i);
        return GestureDetector(
          onTap: () {
            final newSet = Set<int>.from(selectedIndices);
            if (isSelected)
              newSet.remove(i);
            else
              newSet.add(i);
            onChanged(newSet);
          },
          child: Container(
            width: 40,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                width: isSelected ? 2 : 1,
                color: isSelected ? Colors.blue : Colors.grey.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 4,
              children: [
                Icon(
                  isSelected ? Icons.circle_rounded : Icons.circle_outlined,
                  size: 10,
                ),
                Text(
                  days[i],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class TrainingDurationSelector extends StatelessWidget {
  final int selected;
  final Function(int) onChanged;

  const TrainingDurationSelector({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final options = [30, 45, 60, 75, 90, 105, 120];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("TRAINING DURATION, MIN", style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 12,
            children: options.map((duration) {
              final isSelected = duration == selected;
              return ChoiceChip(
                label: Text('$duration'),
                selected: isSelected,
                showCheckmark: false,
                onSelected: (_) => onChanged(duration),
                selectedColor: Colors.blue,
                backgroundColor: isDark ? Colors.transparent : Colors.white,
                labelPadding: EdgeInsets.all(6),
                labelStyle: TextStyle(color: isSelected ? Colors.white : null),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class TargetAreaSelector extends StatelessWidget {
  final String selected;
  final Function(String) onChanged;

  const TargetAreaSelector({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final areas = ['Full body', 'Upper body', 'Abs', 'Lower body'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("TARGET AREAS", style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: areas.length,
            itemBuilder: (context, index) {
              final area = areas[index];
              final isSelected = area == selected;

              return GestureDetector(
                onTap: () => onChanged(area),
                child: Column(
                  children: [
                    Container(
                      height: 70,
                      width: 60,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Icon(Icons.person), // Replace with actual image
                    ),
                    const SizedBox(height: 4),
                    Text(area, style: TextStyle(fontSize: 12)),
                  ],
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 12),
          ),
        ),
      ],
    );
  }
}

class DifficultySelector extends StatelessWidget {
  final String selected;
  final Function(String) onChanged;

  const DifficultySelector({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // final levels = ['Easy', 'Medium', 'Hard'];
    final levels = ['Newbie', 'Skilled', 'Pro'];
    final images = ['assets/images/dumbell.png', 'assets/images/arm.png', 'assets/images/fire.png'];
    final levels_sub = ['You are new to working out.', 'You have some experience.', 'Your are a Professional.'];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("CHOOSE YOUR CURRENT LEVEL", style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        Row(
          spacing: 12,
          children: levels.asMap().entries.map((entry) {
            final index = entry.key;
            final level = entry.value;
            final subText = levels_sub[index];
            final img = images[index];
            final isSelected = level == selected;

            return Expanded(
              child: GestureDetector(
                onTap: () => onChanged(level),
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(12),
                  color: isDark ? Colors.grey[800]! : Colors.white!,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    // margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      // border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 6,
                      children: [
                        Image.asset(
                          img,
                          color: isSelected ? Colors.white : Colors.black,
                          height: 60,
                        ),
                        Text(
                          level,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                        Text(
                          subText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class ToggleOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final Function(bool) onChanged;

  const ToggleOption({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Transform.scale(
        scale: 0.8,
        child: Switch(
          value: value,
          onChanged: onChanged,
          thumbColor: MaterialStateProperty.all(Colors.white),
          // trackColor: MaterialStateProperty.all(Colors.blue),
          activeColor: Colors.blueAccent,
        ),
      ),
    );
  }
}
