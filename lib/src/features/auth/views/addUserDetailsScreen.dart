import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/common/services/authSharedPrefHelper.dart';
import 'package:healthvaults/src/utils/router.dart';

import '../../../common/views/widgets/button.dart';
import '../../../common/views/widgets/datePicker.dart';
import '../../../common/views/widgets/dropDowns.dart';
import '../../../common/views/widgets/textfield.dart';
import '../../../common/views/widgets/toast.dart';
import '../controller/authController.dart';

class addUserDetailsScreen extends ConsumerStatefulWidget {
  final String phoneNumber;

  const addUserDetailsScreen(this.phoneNumber, {super.key});

  @override
  ConsumerState<addUserDetailsScreen> createState() => _addUserDetailsScreenState();
}

class _addUserDetailsScreenState extends ConsumerState<addUserDetailsScreen> {
  final TextEditingController _firstName_controller = TextEditingController();

  final TextEditingController _lastName_controller = TextEditingController();
  DateTime? selectedDate;
  String? gender;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (prev, next) {
      if (next is UserDetailsAdded) {
        context.go(routeNames.home);
        // Navigator.pushReplacementNamed(context, AppRoute.home);
      } else if (next is AuthError) {
        showToast(next.message);

        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.message)));
      }
    });
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Text("Just a few more details..."),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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
              }, title: 'DOB',
            ),
            const SizedBox(height: 16),

            // CustomDropdownBox(),
            selectAgeDropdownBox(
              selectedValue: gender,
              onChanged: (value) {
                setState(() {
                  gender = value;
                });
              },
            ),
            // Gender

            const SizedBox(height: 32),

            // Continue Button
            authState is AuthLoading
                ? CircularProgressIndicator()
                : button_Primary(
                    onPressed: () async {
                      if (_firstName_controller.text.isNotEmpty && _lastName_controller.text.isNotEmpty && gender != null) {
                        final phone = await SharedPrefHelper.getPhoneNumber();
                        ref.read(authProvider.notifier).addUserDetails(_firstName_controller.text.trim(), _lastName_controller.text.trim(),
                            widget.phoneNumber, selectedDate.toString(), gender!);
                      } else {
                        showToast("Please enter your Full Name" );

                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(content: Text("Please enter your Full Name")),
                        // );
                      }
                    },
                    title: "Continue")
          ],
        ),
      ),
    );
  }
}
