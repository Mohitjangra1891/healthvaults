import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/controller/userController.dart';
import '../../../common/services/authSharedPrefHelper.dart';
import '../../../modals/authModel.dart';
import '../../recordsTab/profiles/controller/profileController.dart';
import '../../recordsTab/records/controller/recordController.dart';
import '../repo/authRepo.dart';

sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class OTPSent extends AuthState {}

class OTPVerified extends AuthState {
  final VerifyOtpResponse data;

  OTPVerified(this.data);
}

class UserDetailsAdded extends AuthState {
  final VerifyOtpResponse data;

  UserDetailsAdded(this.data);
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

final authProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref);
});

class AuthController extends StateNotifier<AuthState> {
  final Ref ref;

  AuthController(this.ref) : super(AuthInitial());

  Future<void> sendOtp(String phone) async {
    state = AuthLoading();
    try {
      final res = await ApiClient.post('otp/send', body: {"phoneNumber": "+91$phone"});
      print(res);
      log(res.toString(), name: "AuthContoller/ sendOTP");

      if (res['status'] == 202) {
        state = OTPSent();
      } else {
        state = AuthError("Failed to send OTP");
      }
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> verifyOtp(String phone, String otp) async {
    state = AuthLoading();
    try {
      final res = await ApiClient.post('otp/verify', body: {
        "user": {"phoneNumber": "+91$phone"},
        "code": otp
      });

      log(res.toString(), name: "AuthContoller/ verifyOTP");
      if (res['status'] == 202) {
        final data = VerifyOtpResponse.fromJson(res);
        // Save to SharedPreferences
        final user = data.data.user;
        bool existingUser = data.data.existingUser ?? false;
        await SharedPrefHelper.saveIsExistingUser(existingUser);

        await SharedPrefHelper.saveLoginDetails(
          token: user.token ?? '',
          refreshToken: user.refreshToken ?? '',
          userId: user.userId ?? '',
          profileId: user.profileId ?? '',
          phoneNumber: user.phoneNumber ?? '',
          firstName: user.firstName ?? '',
          lastName: user.lastName ?? '',
          gender: user.gender ?? '',
          dob: user.dob ?? '',
          dp: user.dp ?? '',
        );
        if (existingUser) {
          await SharedPrefHelper.saveUserLOggedIn(true);
          ref.read(userNameProvider.notifier).state = "${user.firstName} ${user.lastName}";
          await ref.read(profilesProvider.notifier).fetchProfilesFromApi();
          await ref.read(recordListProvider.notifier).fetchInitial();
        }

        state = OTPVerified(data);
      } else {
        state = AuthError("Invalid OTP");
      }
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> addUserDetails(String firstName, String lastName, String phone, String gender, String dob) async {
    state = AuthLoading();
    try {
      final res = await ApiClient.post('user/signup',
          body: {"firstname": firstName, "lastname": lastName, "phonenumber": "+91$phone", "gender": gender, "dob": dob});
      log(res.toString(), name: "AuthContoller/ addUserDetails");

      if (res['status'] == 200) {
        final data = VerifyOtpResponse.fromJson(res);
        // Save to SharedPreferences
        final user = data.data.user;

        await SharedPrefHelper.saveUserLOggedIn(true);

        await SharedPrefHelper.saveLoginDetails(
          token: user.token ?? '',
          refreshToken: user.refreshToken ?? '',
          userId: user.userId ?? '',
          profileId: user.profileId ?? '',
          phoneNumber: user.phoneNumber ?? '',
          firstName: user.firstName ?? '',
          lastName: user.lastName ?? '',
          gender: user.gender ?? '',
          dob: user.dob ?? '',
          dp: user.dp ?? '',
        );
        ref.read(userNameProvider.notifier).state = "${user.firstName} ${user.lastName}";
        await ref.read(profilesProvider.notifier).fetchProfilesFromApi();
        await ref.read(recordListProvider.notifier).fetchInitial();

        state = UserDetailsAdded(data);
      } else {
        state = AuthError(res['message']);
      }
    } catch (e) {
      state = AuthError(e.toString());
    }
  }
}
