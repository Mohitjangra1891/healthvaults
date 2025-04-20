import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../res/appColors.dart';
import '../../../../utils/themes/themeProvider.dart';

class MyProfilePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    final themeNotifier = ref.read(themeNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("My Profile", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // Profile Row
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white ),
                ),
                child: Text('M', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 12),
              const Text("mohit janhra", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const Spacer(),
              Icon(Icons.edit, color: AppColors.primaryColor),
            ],
          ),
          const SizedBox(height: 24),

          // Section: Personalization
          const Text("Personalization", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _settingTile(
              icon: themeMode != ThemeMode.dark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
              label: themeMode != ThemeMode.dark ? "Dark Mode" : "Light Mode",
              onPressed: () {
                themeNotifier.setTheme(themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);


              }),
          _settingTile(icon: Icons.sync, label: "Contacts Sync", onPressed: () {}),
          _settingTile(icon: Icons.notifications_none, label: "Notifications", onPressed: () {}),

          const SizedBox(height: 24),

          // Section: App Setting
          const Text("App Setting", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _settingTile(icon: Icons.privacy_tip, label: "Privacy and Policy", onPressed: () {}),
          _settingTile(icon: Icons.cancel, label: "Close Account", onPressed: () {}),
          _settingTile(icon: Icons.logout, label: "Log out", onPressed: () {}),
        ],
      ),
    );
  }

  Widget _settingTile({required IconData icon, required String label, required VoidCallback onPressed}) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0),
      side: BorderSide(color: Colors.black54 ,width: 0.2)
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primaryColor),
        title: Text(label),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onPressed, // Add navigation logic here
      ),
    );
  }
}
