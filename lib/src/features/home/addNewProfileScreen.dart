import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/common/widgets/button.dart';
import 'package:intl/intl.dart';

import '../../modals/profile.dart';
import '../../res/appColors.dart';
import 'controller/profileController.dart';

class CreateProfileScreen extends StatelessWidget {
  const CreateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final TextEditingController _firstName_controller = TextEditingController();
    final TextEditingController _lastName_controller = TextEditingController();
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
            _buildTextField(context, label: 'First name', hint: 'Enter First Name', controller: _firstName_controller),
            const SizedBox(height: 16),

            // Last Name
            _buildTextField(context, label: 'Last name', hint: 'Enter Last Name', controller: _lastName_controller),
            const SizedBox(height: 16),

            CustomDatePicker(),
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
                        String firstLetter =  _firstName_controller.text[0].toUpperCase();

                        ref
                            .read(profileListProvider.notifier)
                            .addProfile(Profile(letter: firstLetter, name: "${_firstName_controller.text.trim()} ${_lastName_controller.text.trim()}"));
                        context.pop(); // for go_router

                      }
                      else{
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

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required String hint,
    bool readOnly = false,
    Widget? suffixIcon,
    VoidCallback? onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffixIcon,
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colorScheme.primary),
            ),
          ),
        ),
      ],
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

class CustomDatePicker extends StatefulWidget {
  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? selectedDate;

  Future<void> _pickDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = selectedDate != null ? DateFormat('yyyy-MM-dd').format(selectedDate!) : 'Select DOB';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Date of Birth", style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 6),
        InkWell(
          onTap: _pickDate,
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
            child: Text(
              formattedDate,
            ),
          ),
        ),
      ],
    );
  }
}
