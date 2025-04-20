import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../modals/profile.dart';

final profileListProvider = StateNotifierProvider<ProfileListNotifier, List<Profile>>((ref) {
  return ProfileListNotifier();
});

class ProfileListNotifier extends StateNotifier<List<Profile>> {
  ProfileListNotifier() : super([
    Profile(letter: "M", name: "Mohit J"),

  ]);

  void addProfile(Profile profile) {
    state = [...state, profile];
  }

  void deleteProfile(Profile profile) {
    state = state.where((p) => p != profile).toList();
  }
}

