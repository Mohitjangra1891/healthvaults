import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/utils/router.dart';

import '../../../common/views/widgets/toast.dart';
import '../../../res/appColors.dart';
import '../controller/authController.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  ConsumerState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;
  int countdown = 30;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(6, (index) => TextEditingController());
    focusNodes = List.generate(6, (index) => FocusNode());
    startTimer();
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    countdown = 30;
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        setState(() {
          countdown--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void onOtpEntered(int index, String value) {
    if (value.isNotEmpty) {
      if (index < 5) {
        FocusScope.of(context).requestFocus(focusNodes[index + 1]);
      } else {
        FocusScope.of(context).unfocus();
      }
    }
  }

  void verifyOtp() {
    if (controllers.any((controller) => controller.text.isEmpty)) {
      showToast("Please enter All digits");

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("Please enter all digits")),
      // );
      return;
    }

    String otp = controllers.map((controller) => controller.text).join();
    print("Entered OTP: $otp");
    ref.read(authProvider.notifier).verifyOtp(widget.phoneNumber, otp);

    controllers.map((controller) => controller.clear());
  }

  void resendOtp() {
    if (countdown == 0) {
      startTimer();
      print("Resending OTP...");
      ref.read(authProvider.notifier).sendOtp((widget.phoneNumber));
    }
  }

  @override
  Widget build(BuildContext context) {
    // final verifyOtpState = ref.watch(verifyOtpStateProvider);
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (prev, next) async {
      if (next is OTPVerified) {
        if (!next.data.data.existingUser! && next.data.data.user.token == null ) {
          // context.goNamed(routeNames.addDetails);
          context.push("${routeNames.addDetails}/${widget.phoneNumber}");

        } else {
          context.goNamed(routeNames.home);
        }
      } else if (next is AuthError) {
        showToast( next.message);

        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.message)));
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            Center(
              child: Image.asset(
                'assets/logo.png', // Replace with your logo asset
                height: 120,
              ),
            ),
            const SizedBox(height: 50),
            Text(
              'Verify Mobile No.',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 15),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                children: [
                  const TextSpan(text: "Please enter the verification code sent \nto your mobile number "),
                  TextSpan(
                    text: widget.phoneNumber,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: " via "),
                  const TextSpan(
                    text: "SMS",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: Text(
                'Change Mobile Number',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) {
                return Container(
                  alignment: Alignment.center,
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: Center(
                    child: TextField(
                      controller: controllers[index],
                      focusNode: focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) => onOtpEntered(index, value),
                      decoration: const InputDecoration(
                        counterText: "",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 60),
            const Text(
              "Didn’t receive OTP?",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            TextButton(
              onPressed: countdown == 0 ? resendOtp : null,
              child: Text(
                countdown == 0 ? "Resend OTP" : "Resend OTP in 0:$countdown Sec",
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 50),
            authState is AuthLoading
                ? CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: verifyOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Verify Otp',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
