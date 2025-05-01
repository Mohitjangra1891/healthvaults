import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// navbar_visibility_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthvaults/src/features/healthTab/views/healthTabScreen.dart';
import 'package:healthvaults/src/res/appColors.dart';

import 'features/recordsTab/recordTabScreen.dart';
import 'features/recordsTab/records/views/widgets/addNewRecordSheet.dart';



class NavBarVisibilityNotifier extends StateNotifier<bool> {
  NavBarVisibilityNotifier() : super(true); // default: visible

  void show() => state = true;

  void hide() => state = false;

  void toggle() => state = !state;
}

final navBarVisibilityProvider = StateNotifierProvider<NavBarVisibilityNotifier, bool>(
  (ref) => NavBarVisibilityNotifier(),
);

class FloatingNavBarScreen extends ConsumerStatefulWidget {
  @override
  _FancyFloatingNavBarState createState() => _FancyFloatingNavBarState();
}

class _FancyFloatingNavBarState extends ConsumerState<FloatingNavBarScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  final PageController _controller = PageController();


  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    _controller.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void _onScroll(ScrollNotification notification) {
    final visibilityNotifier = ref.read(navBarVisibilityProvider.notifier);
    if (notification is UserScrollNotification) {
      if (notification.direction == ScrollDirection.reverse) {
        visibilityNotifier.hide();
      } else if (notification.direction == ScrollDirection.forward) {
        visibilityNotifier.show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              _onScroll(notification);
              return true;
            },
            child: PageView(
              controller: _controller,
              physics: NeverScrollableScrollPhysics(),
              children: [
                healthTabScreen(),
                RecordsTabScreen(),
              ],
            ),
          ),

          // 👉 FAB only on healthTabScreen (index 0)
          if (_selectedIndex == 1)
            Consumer(
              builder: (context, ref, _) {
                final isVisible = ref.watch(navBarVisibilityProvider);

                return Positioned(
                  right: 24,
                  bottom: isVisible ? 100 : -100,
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 400),
                    opacity: isVisible ? 1 : 0,
                    child: FloatingActionButton(
                      onPressed: () {
                        add_New_RECORD_BottomSheet(context);
                        // Add your logic here
                      },
                      backgroundColor: isDark ? Colors.white : AppColors.primaryColor,
                      child: Icon(Icons.add, color: isDark ? AppColors.primaryColor : Colors.white),
                    ),
                  ),
                );
              },
            ),

          Consumer(
            builder: (context, ref, _) {
              final isVisible = ref.watch(navBarVisibilityProvider);

              return Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedSlide(
                  offset: Offset(0, isVisible ? 0 : 1.5),
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 24),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _navIcon(Icons.health_and_safety_outlined, "My Health", 0),
                        SizedBox(width: 32),
                        _navIcon(Icons.receipt_long, "Records", 1),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _navIcon(IconData icon, String label, int index) {
    final isActive = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.primaryColor : Colors.white54,
            size: 28,
          ),
          Text(
            label,
            style: TextStyle(color: isActive ? AppColors.primaryColor : Colors.grey),
          )
        ],
      ),
    );
  }
}
