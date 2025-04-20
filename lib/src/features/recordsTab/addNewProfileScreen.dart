import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/common/widgets/button.dart';
import 'package:intl/intl.dart';

import '../../common/widgets/datePicker.dart';
import '../../common/widgets/textfield.dart';
import '../../modals/profile.dart';
import '../../res/appColors.dart';
import 'controller/profileController.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {

  final TextEditingController _firstName_controller = TextEditingController();
  final TextEditingController _lastName_controller = TextEditingController();
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
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primaryColor,
                  child: Icon(Icons.account_circle_outlined, size: 70, color: Colors.white),
                ),
                Positioned(
                  bottom: 0,
                  right: -4,
                  child: Icon(Icons.edit, size: 26, color: AppColors.primaryColor),
                ),
              ],
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
                  // selectedDate = date;
                });
              },
            ),
            const SizedBox(height: 16),

            CustomDropdownBox(),
            // Gender

            const SizedBox(height: 32),

            // Continue Button
            Consumer(
              builder: (context, ref, _) {
                return button_Primary(
                    onPressed: () {
                      if (_firstName_controller.text.isNotEmpty && _lastName_controller.text.isNotEmpty) {
                        String firstLetter = _firstName_controller.text[0].toUpperCase();

                        ref.read(profileListProvider.notifier).addProfile(
                            Profile(letter: firstLetter, name: "${_firstName_controller.text.trim()} ${_lastName_controller.text.trim()}"));
                        context.pop(); // for go_router
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please enter your Full Name")),
                        );
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

class CustomDropdownBox extends StatefulWidget {
  @override
  _CustomDropdownBoxState createState() => _CustomDropdownBoxState();
}

class _CustomDropdownBoxState extends State<CustomDropdownBox> {
  final List<String> options = ['Male', 'Female', 'Prefer Not to say'];
  String? selectedValue;

  void _showOptionsMenu() async {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final String? result = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + renderBox.size.height,
        offset.dx + renderBox.size.width,
        offset.dy,
      ),
      items: options.map((value) {
        return PopupMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );

    if (result != null) {
      setState(() {
        selectedValue = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Gender", style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 6),
        InkWell(
          onTap: _showOptionsMenu,
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
            child: Text(
              selectedValue ?? 'Select Gender',
            ),
          ),
        ),
      ],
    );
  }
}
