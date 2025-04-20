
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

