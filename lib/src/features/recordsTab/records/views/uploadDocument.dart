import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthvaults/src/common/views/widgets/toast.dart';
import 'package:healthvaults/src/features/recordsTab/records/views/widgets/imagepicker.dart';
import 'package:healthvaults/src/features/recordsTab/records/views/widgets/selectProfileDropDown.dart';
import 'package:intl/intl.dart';

import '../../../../common/services/authSharedPrefHelper.dart';
import '../../../../common/views/widgets/button.dart';
import '../../../../common/views/widgets/datePicker.dart';
import '../../../../common/views/widgets/textfield.dart';
import '../controller/uoloadRecordController.dart';
// import 'package:toast/toast.dart';

class uploadDocumentScreen extends ConsumerStatefulWidget {
  final String recordType;

  const uploadDocumentScreen({super.key, required this.recordType});

  @override
  ConsumerState<uploadDocumentScreen> createState() => _uploadDocumentScreenState();
}

class _uploadDocumentScreenState extends ConsumerState<uploadDocumentScreen> {
  DateTime? selectedDate;
  late String pid;

  final TextEditingController _first_controller = TextEditingController();
  final TextEditingController _second_controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(fileSelectionProvider.notifier).clearAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    // final textTheme = theme.textTheme;
    // final colorScheme = theme.colorScheme;

    final title = widget.recordType == "MedicalBill" ? "Bill name" : "Doctor name";
    final sub = widget.recordType == "LabReport" ? "Hospital/Lab name" : "Description";
    final dateTitle = widget.recordType == "LabReport" ? "Test date" : "Issue date";
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
// ✅ Example usage in a parent widget:
            selectProfileDropdownBox(
              onSelected: (id) {
                print("Selected ID: $id");
                pid = id;
              },
            ),

            const SizedBox(height: 16),

            // First Name
            buildTextField(context, label: title, hint: 'Enter $title', controller: _first_controller),
            const SizedBox(height: 16),

            // Last Name
            buildTextField(context, label: sub, hint: 'Enter $sub', controller: _second_controller),
            const SizedBox(height: 16),

            CustomDatePicker(
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });
              }, title: dateTitle,
            ),

            // Gender

            const SizedBox(height: 32),
            DynamicImagePicker(),
            const SizedBox(height: 32),

            // Continue Button

            Consumer(
              builder: (context, ref, _) {
                final uploadState = ref.watch(uploadStateProvider);
                final fileSelectionState = ref.watch(fileSelectionProvider);

                return uploadState.isLoading
                    ? Center(child: const CircularProgressIndicator())
                    : button_Primary(
                        onPressed: () async {
                          if (_first_controller.text.isNotEmpty && _second_controller.text.isNotEmpty && selectedDate != null && pid != null) {
                            // ref.read(RecordProvider.notifier).addRecord(
                            //       RecordModel(name: "New Patient", createdAt: selectedDate!, type: widget.recordType),
                            //     );

                            final token = await SharedPrefHelper.getToken();
                            final formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate!);

                            if (fileSelectionState.pdfFile != null) {
                              await ref.read(uploadStateProvider.notifier).uploadFile(
                                    fileSelectionState.pdfFile!,
                                    _first_controller.text.trim(),
                                    _second_controller.text.trim(),
                                    formattedDate,
                                    widget.recordType,
                                    pid,
                                    '$token',
                                    context: context,
                                    ref: ref,
                                  );
                            } else {
                              if (fileSelectionState.images.isNotEmpty) {
                                final pdfFile = await ref.read(fileSelectionProvider.notifier).convertImagesToPdf(fileSelectionState.images);
                                await ref.read(uploadStateProvider.notifier).uploadFile(
                                      pdfFile,
                                      _first_controller.text.trim(),
                                      _second_controller.text.trim(),
                                      formattedDate,
                                      widget.recordType,
                                      pid,
                                      '$token',
                                      context: context,
                                      ref: ref,
                                    );
                              } else {
                                showToast("Please select prescription image");
                              }
                            }
                          } else {
                            showToast("Please enter All Fields");
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
