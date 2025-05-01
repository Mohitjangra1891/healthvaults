import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/common/controller/userController.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common/views/widgets/ImageSelrctor.dart';
import '../../../../common/views/widgets/button.dart';
import '../../../../common/views/widgets/datePicker.dart';
import '../../../../common/views/widgets/dropDowns.dart';
import '../../../../common/views/widgets/textfield.dart';
import '../../../../common/views/widgets/toast.dart';
import '../../../../modals/authModel.dart';
import '../../../../res/appColors.dart';
import '../controller/profileController.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final TextEditingController _firstName_controller = TextEditingController();
  final TextEditingController _lastName_controller = TextEditingController();
  DateTime? selectedDate;
  String? gender;
  String? selectedDp; // store the base64 image


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Create Profile"),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Stack(
            //   alignment: Alignment.bottomRight,
            //   children: [
            //     CircleAvatar(
            //       radius: 50,
            //       backgroundColor: AppColors.primaryColor,
            //       child: Icon(Icons.account_circle_outlined, size: 70, color: Colors.white),
            //     ),
            //     Positioned(
            //       bottom: 0,
            //       right: -4,
            //       child: Icon(Icons.edit, size: 26, color: AppColors.primaryColor),
            //     ),
            //   ],
            // ),
            ProfileImagePicker(
              onImageSelected: (bytes) {
                // you get selected bytes here
                setState(() {
                  selectedDp = base64Encode(bytes);
                });
               
              },
            ),
            const SizedBox(height: 32),

            // First Name
            buildTextField(context, label: 'First name', hint: 'Enter First Name', controller: _firstName_controller),
            const SizedBox(height: 16),

            // Last Name
            buildTextField(context, label: 'Last name', hint: 'Enter Last Name', controller: _lastName_controller),
            const SizedBox(height: 16),

            CustomDatePicker(
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
              title: 'DOB',
            ),
            const SizedBox(height: 16),

            selectAgeDropdownBox(
              selectedValue: gender,
              onChanged: (value) {
                setState(() {
                  gender = value;
                });
              },
            ), // Gender

            const SizedBox(height: 32),

            // Continue Button
            Consumer(
              builder: (context, ref, _) {
                final profiles = ref.watch(profilesProvider);
                final isLoading = ref.watch(loaderProvider);

                return isLoading
                    ? Center(child: CircularProgressIndicator())
                    : button_Primary(
                        onPressed: () async {
                          if (_firstName_controller.text.isNotEmpty && _lastName_controller.text.isNotEmpty) {
                            ref.read(loaderProvider.notifier).state = true;

                            final profile = Profile(
                                firstName: _firstName_controller.text.trim(),
                                lastName: _firstName_controller.text.trim(),
                                dp: selectedDp,
                                gender: gender,
                                dob: selectedDate.toString());
                            try {
                              await ref.read(profilesProvider.notifier).addProfile(profile);
                              ref.read(loaderProvider.notifier).state = false;

                              context.pop(); // for go_router
                            } catch (e) {
                              ref.read(loaderProvider.notifier).state = false;

                              print("exception-- $e");
                              showToast("exception-- $e");
                            }
                          } else {
                            showToast("Please enter All Fields");

                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   const SnackBar(content: Text("Please enter your Full Name")),
                            // );
                          }
                        },
                        title: "Continue");
              },
            ),
          ],
        ),
      ),
    );
  }
}
