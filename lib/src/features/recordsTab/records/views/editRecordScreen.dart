import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/views/widgets/button.dart';
import '../../../../common/views/widgets/textfield.dart';
import '../../../../common/views/widgets/toast.dart';
import '../../../../modals/record.dart';
import '../controller/editRecodController.dart';

class editRecordScreen extends StatefulWidget {
  final MedicalRecord record;

  const editRecordScreen({super.key, required this.record});

  @override
  State<editRecordScreen> createState() => _editRecordScreenState();
}

class _editRecordScreenState extends State<editRecordScreen> {
  final TextEditingController _first_controller = TextEditingController();
  final TextEditingController _second_controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _first_controller.text = widget.record.name;
    _second_controller.text = widget.record.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 👉 clears keyboard focus
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text("Edit Record"),
          leading: const BackButton(),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // First Name
              buildTextField(context, label: 'Doctor name', hint: 'Enter Doctor name', controller: _first_controller, allowClearButton: true),
              const SizedBox(height: 16),

              // Last Name
              buildTextField(context, label: "Description", hint: 'Enter Description', controller: _second_controller, allowClearButton: true),
              const SizedBox(height: 16),

              Consumer(
                builder: (context, ref, _) {
                  final editState = ref.watch(EditStateProvider);

                  return editState.isLoading
                      ? Center(child: const CircularProgressIndicator())
                      : button_Primary(
                          onPressed: () async {
                            if (_first_controller.text.isNotEmpty && _second_controller.text.isNotEmpty) {
                              // ref.read(RecordProvider.notifier).addRecord(
                              //       RecordModel(name: "New Patient", createdAt: selectedDate!, type: widget.recordType),
                              //     );
                              final updatedRecord = widget.record.copyWith(
                                name: _first_controller.text,
                                description: _second_controller.text,
                              );
                              ref.read(EditStateProvider.notifier).editRecord(context: context, ref: ref, newRecord: updatedRecord);
                            } else {
                              showToast("Please enter All Fields");
                            }
                          },
                          title: "Save");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
