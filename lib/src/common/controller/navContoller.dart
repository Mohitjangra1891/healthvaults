// // navbar_visibility_provider.dart
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// class NavbarVisibilityNotifier extends StateNotifier<bool> {
//   NavbarVisibilityNotifier() : super(true); // Start with visible navbar
//
//   void hide() => state = false; // Hide navbar
//   void show() => state = true; // Show navbar
// }
//
// final navbarVisibilityProvider = StateNotifierProvider<NavbarVisibilityNotifier, bool>((ref) {
//   return NavbarVisibilityNotifier();
// });
//
