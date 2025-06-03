import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/res/appImages.dart';
import 'package:healthvaults/src/utils/router.dart';

import '../../features/recordsTab/profiles/controller/profileController.dart';
import '../../features/recordsTab/records/controller/recordController.dart';
import '../controller/userController.dart';
import '../services/authSharedPrefHelper.dart';

class Splashscreen extends ConsumerStatefulWidget {
  const Splashscreen({super.key});

  @override
  ConsumerState<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends ConsumerState<Splashscreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    await Future.delayed(const Duration(seconds: 2)); // Optional splash delay
    final isLoggedIn = await SharedPrefHelper.isUserLoggedIn();
    // final isLoggedIn = await SharedPrefHelper.isUserLoggedIn();
    final isExistingUser = await SharedPrefHelper.getIsExistingUser();
    if (mounted) {
      if (isLoggedIn) {
        // if (isExistingUser) {
        final userName = await SharedPrefHelper.getUserName();
        // final token = await SharedPrefHelper.getToken();
        // log(token!);

        ref.read(userNameProvider.notifier).state = userName ?? "Guest";

        // await ref.read(profilesProvider.notifier).fetchProfilesFromApi();


        //turn it on later ///
        // await ref.read(recordListProvider.notifier).fetchInitial();

        context.goNamed(routeNames.home);
        // } else {
        //   context.goNamed(routeNames.addDetails);
        // }
      } else {
        // context.goNamed(routeNames.login);
        context.goNamed(routeNames.home);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Image.asset(appImages.appLogo),
      ),
    );
  }
}
