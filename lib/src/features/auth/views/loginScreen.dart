import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/common/widgets/button.dart';
import 'package:healthvaults/src/utils/router.dart';

import '../../../res/appColors.dart';

class LoginScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool chechBoxValue = true;
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // final createOtpState = ref.watch(createOtpStateProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: screenHeight*0.03 ,vertical: screenHeight*0.04),
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
                style: TextStyle(fontSize: 18 ,fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              Center(
                child: Image.asset(
                  'assets/loginBG.png',
                  height: screenHeight*0.4,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(

                      autofocus: false,
                      readOnly: true,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: '+91',
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w400),

                        // No border
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.onBackground),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.onBackground),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.onBackground),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    flex: 6,
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        onTapOutside: (PointerDownEvent) {
                          FocusScope.of(context).unfocus();
                        },
                        autofocus: false,
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'Mobile Number',
                          hintStyle: TextStyle(fontSize: 12, color: Color.fromRGBO(204, 204, 204, 1), fontWeight: FontWeight.w400),

                          // No border
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.onBackground),
                          ), enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.onBackground),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: AppColors.primaryColor),
                          ), focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: AppColors.primaryColor),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   const SnackBar(content: Text("Please enter your phone number")),
                            // );
                            return 'Please enter your phone number';
                          } else if (value.replaceAll(RegExp(r'\D'), '').length != 10) {
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   const SnackBar(content: Text("Enter a valid 10-digit phone number")),
                            // );
                            return 'Enter a valid 10-digit phone number';
                          }
                          return null;
                        },

                      ),
                    ),
                  ),
                ],
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
              SizedBox(
                width: double.infinity,
                height: 50,
                child: button_Primary(
                    onPressed: (){
                      if (_formKey.currentState!.validate()) {
                        // ref.read(authProvider.notifier).createOtp(91, int.parse(_phoneController.text), context, isBottomSheet: false);

                        context.push("${routeNames.otpVerify}/${_phoneController.text.trim()}");
                      } else {
                        print("Validation failed");
                      }
                    },
                    title: "Continue"),
              ),
              // createOtpState.when(
              //   data: (_) {
              //     return SizedBox(
              //       width: double.infinity,
              //       height: 50,
              //       child: button_Primary(
              //           onPressed: () {
              //             if (_formKey.currentState!.validate()) {
              //               print("Next button pressed with valid input");
              //               // ref.read(authProvider.notifier).createOtp(91, int.parse(_phoneController.text), context, isBottomSheet: false);
              //             } else {
              //               print("Validation failed");
              //             }
              //           },
              //           title: "Continue"),
              //     );
              //   },
              //   loading: () => const Center(
              //       child: CircularProgressIndicator(
              //     color: AppColors.primaryColor,
              //   )),
              //   error: (Object error, StackTrace stackTrace) {
              //     return SizedBox(
              //       width: double.infinity,
              //       height: 50,
              //       child: button_Primary(
              //           onPressed: () {
              //             if (_formKey.currentState!.validate()) {
              //               print("Next button pressed with valid input");
              //               // ref.read(authProvider.notifier).createOtp(91, int.parse(_phoneController.text), context, isBottomSheet: false);
              //             } else {
              //               print("Validation failed");
              //             }
              //           },
              //           title: "Continue"),
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
