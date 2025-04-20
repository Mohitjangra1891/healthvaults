import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/common/widgets/button.dart';
import 'package:healthvaults/src/modals/record.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../res/appColors.dart';
import 'controller/recordController.dart';

class uploadDocumentScreen extends StatefulWidget {
  final String recordType;

  const uploadDocumentScreen({super.key, required this.recordType});

  @override
  State<uploadDocumentScreen> createState() => _uploadDocumentScreenState();
}

class _uploadDocumentScreenState extends State<uploadDocumentScreen> {
  DateTime? selectedDate;

  final TextEditingController _first_controller = TextEditingController();
  final TextEditingController _second_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Upload Document"),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomDropdownBox(),
            const SizedBox(height: 16),

            // First Name
            _buildTextField(context, label: 'Doctor name', hint: 'Enter Doctor Name', controller: _first_controller),
            const SizedBox(height: 16),

            // Last Name
            _buildTextField(context, label: 'Description', hint: 'Enter Description', controller: _second_controller),
            const SizedBox(height: 16),

            CustomDatePicker(
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),

            // Gender

            const SizedBox(height: 32),
            DynamicImagePicker(),
            const SizedBox(height: 32),

            // Continue Button

            Consumer(
              builder: (context, ref, _) {
                return button_Primary(
                    onPressed: () {
                      if (_first_controller.text.isNotEmpty && _second_controller.text.isNotEmpty) {
                        ref.read(RecordProvider.notifier).addRecord(
                          RecordModel(name: "New Patient", createdAt: selectedDate!, type: widget.recordType),
                        );

                        context.pop(); // for go_router
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please enter All Fields")),
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
  final List<String> options = [
    'Profile 1',
    'Profile 2',
    'Profile 3',
    'Profile 4',
  ];
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
        Text("Select Profile", style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 6),
        InkWell(
          onTap: _showOptionsMenu,
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
            child: Text(
              selectedValue ?? 'Select Profile',
            ),
          ),
        ),
      ],
    );
  }
}


class CustomDatePicker extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const CustomDatePicker({super.key, required this.onDateSelected});

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? selectedDate;

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
      widget.onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = selectedDate != null ? DateFormat('yyyy-MM-dd').format(selectedDate!) : 'Select Date';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Issue Date", style: Theme.of(context).textTheme.labelMedium),
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

class DynamicImagePicker extends StatefulWidget {
  @override
  _DynamicImagePickerState createState() => _DynamicImagePickerState();
}

class _DynamicImagePickerState extends State<DynamicImagePicker> {
  List<File> _images = [];

  Future<void> _pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked != null) {
      setState(() {
        _images.add(File(picked.path));
      });
    }
  }

  Widget _buildImageBox(File image) {
    return Container(
      width: 70,
      height: 90,
      margin: EdgeInsets.only(right: 6, bottom: 6),
      decoration: BoxDecoration(border: Border.all(color: Theme.of(context).dividerColor)),
      child: Image.file(image, fit: BoxFit.cover),
    );
  }

  Widget _buildAddBox() {
    return Container(
      height: 90,
      width: 70,
      margin: EdgeInsets.only(right: 6, bottom: 6),
      decoration: BoxDecoration(border: Border.all(color: Theme.of(context).dividerColor)),
      child: IconButton(
          onPressed: () {
            selectImageOptionSheet(context);
          },
          icon: Icon(
            CupertinoIcons.add,
            color: AppColors.primaryColor,
            size: 50,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Click to add Documents (max size: 5mb)", style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 6),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ..._images.map((img) => _buildImageBox(img)).toList(),
              _buildAddBox(),
            ],
          ),
        ),
      ],
    );
  }

  void selectImageOptionSheet(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                height: 5,
                width: 40,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[700] : Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              button_Primary(
                  onPressed: () {
                    _pickImage(ImageSource.gallery);
                  },
                  title: "Gallery"),
              const SizedBox(height: 16),
              button_Primary(
                  onPressed: () {
                    _pickImage(ImageSource.camera);
                  },
                  title: "Camera"),
              const SizedBox(height: 16),
              button_Primary(onPressed: () {}, title: "PDF"),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
