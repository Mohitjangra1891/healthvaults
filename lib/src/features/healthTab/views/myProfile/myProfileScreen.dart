import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/common/services/authSharedPrefHelper.dart';
import 'package:healthvaults/src/common/services/profileSharedPrefHelper.dart';
import 'package:healthvaults/src/features/healthTab/views/myProfile/editUserProfileScreen.dart';
import 'package:healthvaults/src/utils/router.dart';

import '../../../../common/controller/userController.dart';
import '../../../../common/views/widgets/imagwWidget.dart';
import '../../../../res/appColors.dart';
import '../../../../utils/themes/themeProvider.dart';

class MyProfilePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    final themeNotifier = ref.read(themeNotifierProvider.notifier);
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
    final userName = ref.watch(userNameProvider);
    final firstName = userName
        .split(' ')
        .first;
    final lastName = userName
        .split(' ')
        .length > 1 ? userName.split(' ')[1] : '';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("My Profile", style: TextStyle(fontWeight: FontWeight.bold)),
        // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Row
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  UserProfileDpScreen(),
                  const SizedBox(width: 12),
                  Text(userName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  editUserProfileSceen(
                                    firstName: firstName,
                                    lastName: lastName,
                                  )));
                    },
                    icon: Icon(Icons.edit, color: AppColors.primaryColor),
                  )
                ],
              ),
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
                },
                isDark: isDark),
            _settingTile(icon: Icons.sync, label: "Contacts Sync", onPressed: () {}, isDark: isDark),
            _settingTile(icon: Icons.notifications_none, label: "Notifications", onPressed: () {}, isDark: isDark),

            const SizedBox(height: 24),

            // Section: App Setting
            const Text("App Setting", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _settingTile(icon: Icons.privacy_tip, label: "Privacy and Policy", onPressed: () {}, isDark: isDark),
            _settingTile(icon: Icons.cancel, label: "Close Account", onPressed: () {}, isDark: isDark),
            _settingTile(
                icon: Icons.logout,
                label: "Log out",
                onPressed: () async {
                  await SharedPrefHelper.clearAll();
                  await ProfileStorageHelper.clearAll();
                  context.goNamed(routeNames.splash);
                },
                isDark: isDark),
          ],
        ),
      ),
    );
  }

  Widget _settingTile({required bool isDark, required IconData icon, required String label, required VoidCallback onPressed}) {
    return Card(
      elevation: 0,
      color: isDark ? Colors.white12 : Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0), side: BorderSide(color: Colors.black54, width: 0.2)),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primaryColor),
        title: Text(label),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onPressed, // Add navigation logic here
      ),
    );
  }
}
