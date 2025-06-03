import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/utils/router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../common/views/widgets/button.dart';
import '../../../common/views/widgets/toast.dart';
import '../../../res/appColors.dart';
import '../controller/authController.dart';

class LoginScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool chechBoxValue = true;
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String phoneNumber;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (prev, next) {
      if (next is OTPSent) {
        context.push("${routeNames.otpVerify}/${_phoneController.text}");

        // Navigator.push(context, MaterialPageRoute(builder: (context) => OtpVerificationScreen(phoneNumber: _phoneController.text)));
      } else if (next is AuthError) {

        showToast(next.message);

        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.message)));
      }
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.03, vertical: screenHeight * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/logo.png', // Replace with your logo asset
                height: 60,
              ),
              const SizedBox(height: 20),
              Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const Text(
                'Keep Your Health Documents Secured.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Center(
                child: Image.asset(
                  'assets/loginBG.png',
                  height: screenHeight * 0.4,
                ),
              ),
              const SizedBox(height: 4),
              Form(
                key: _formKey,
                child: IntlPhoneField(
                  controller: _phoneController,
                  // disableLengthCheck: true,
                  flagsButtonPadding: const EdgeInsets.all(8),
                  dropdownIconPosition: IconPosition.trailing,
                  decoration: InputDecoration(
                    hintText: 'Mobile Number',
                    hintStyle: TextStyle(fontSize: 12, color: Color.fromRGBO(204, 204, 204, 1), fontWeight: FontWeight.w400),

                    // No border
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.onBackground),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.onBackground),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: AppColors.primaryColor),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: AppColors.primaryColor),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  initialCountryCode: 'IN',
                  showCursor: true,
                  showDropdownIcon: true,
                  onChanged: (phone) {
                    print(phone.completeNumber);
                    phoneNumber = phone.completeNumber;
                  },
                  validator: (value) {
                    if (value == null || value.number.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 12),
              Center(
                child: const Text(
                  'We\'ll send you an otp to verify this\n mobile number.',
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              authState is AuthLoading
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: button_Primary(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ref.read(authProvider.notifier).sendOtp(phoneNumber);
                              print("sending otp to ${phoneNumber}");
                              //
                            } else {
                              print("Validation failed");
                            }
                          },
                          title: "Continue"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
