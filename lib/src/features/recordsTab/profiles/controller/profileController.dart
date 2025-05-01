import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthvaults/src/common/services/authSharedPrefHelper.dart';

import '../../../../common/services/profileSharedPrefHelper.dart';
import '../../../../modals/authModel.dart';
import '../../../auth/repo/authRepo.dart';

// final profileListProvider = StateNotifierProvider<ProfileListNotifier, List<MyProfile>>((ref) {
//   return ProfileListNotifier();
// });
//
// class ProfileListNotifier extends StateNotifier<List<MyProfile>> {
//   ProfileListNotifier() : super([
//     MyProfile(letter: "M", name: "Mohit J"),
//
//   ]);
//
//   void addProfile(MyProfile profile) {
//     state = [...state, profile];
//   }
//
//   void deleteProfile(MyProfile profile) {
//     state = state.where((p) => p != profile).toList();
//   }
// }
//

final profilesProvider = StateNotifierProvider<ProfilesController, AsyncValue<List<Profile>>>(
      (ref) =>
  ProfilesController()
    ..loadProfilesFromCache(),
);

class ProfilesController extends StateNotifier<AsyncValue<List<Profile>>> {
  ProfilesController() : super(const AsyncLoading());

  Future<void> loadProfilesFromCache() async {
    final cached = await ProfileStorageHelper.loadProfiles();
    log("saved prfofiels" + cached.toString(), name: "ProfileController / loadFromcache");

    state = AsyncData(cached);
  }

  Future<void> fetchProfilesFromApi() async {
    state = AsyncLoading();
    try {
      final res = await ApiClient.get('profile/list');
      final owned = (res['data']['owned'] as List).map((e) => Profile.fromJson(e)).toList();
      state = AsyncData(owned);
      await ProfileStorageHelper.saveProfiles(owned);
      // // Find the profile where userprofile == true
      // final userProfile = owned.firstWhere(
      //       (profile) => profile.userprofile == true,
      // );
      // await SharedPrefHelper.saveDP(userProfile.dp ?? "");
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> addProfile(Profile profile) async {
    await ApiClient.postWithToken('profile/create',
        body: {"firstname": profile.firstName, "lastname": profile.lastName, "dp": profile.dp, "gender": profile.gender, "dob": profile.dob});
    await fetchProfilesFromApi();
  }

  Future<void> deleteProfile(String id) async {
    final res = await ApiClient.deleteProfile('profile/delete', id);
    if (res['status'] == 200) {
      // Update provider state
      final updatedProfiles = state.whenData(
            (profiles) => profiles.where((profile) => id != profile.id).toList(),
      );

      state = updatedProfiles;

      // ✅ Also update SharedPreferences
      if (updatedProfiles.hasValue) {
        await ProfileStorageHelper.saveProfiles(updatedProfiles.value!);
      }
    } else {
      throw Exception("Failed to delete records");
    }
  }

  Future<String> getProfileNameById(String id) async {
    final profiles = state.value; // Access the loaded profiles

    if (profiles == null) {
      return ''; // No profiles loaded yet
    }

    final profile = profiles.firstWhere(
          (profile) => profile.id == id,
    );

    return profile.firstName ?? 'Unknown';
  }
}
