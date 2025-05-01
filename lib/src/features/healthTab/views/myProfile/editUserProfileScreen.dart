import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/views/widgets/ImageSelrctor.dart';
import '../../../../common/views/widgets/button.dart';
import '../../../../common/views/widgets/textfield.dart';
import '../../../../common/views/widgets/toast.dart';
import '../../../recordsTab/records/controller/editRecodController.dart';

class editUserProfileSceen extends StatefulWidget {
  final String firstName;
  final String lastName;

  const editUserProfileSceen({super.key, required this.firstName, required this.lastName});

  @override
  State<editUserProfileSceen> createState() => _editUserProfileSceenState();
}

class _editUserProfileSceenState extends State<editUserProfileSceen> {
  final TextEditingController _first_controller = TextEditingController();
  final TextEditingController _second_controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _first_controller.text = widget.firstName;
    _second_controller.text = widget.lastName;
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
          title: const Text("Edit Profile"),
          leading: const BackButton(),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // ProfileImagePicker(
              //   onImageSelected: (pickedBytes) {
              //     // handle after user picks a new image
              //   },
              //   initialImage: yourUint8ListImage, // pass it here!
              // ),

              const SizedBox(height: 16),

              // First Name
              buildTextField(context, label: 'First Name', hint: 'Enter First Name', controller: _first_controller, allowClearButton: true),
              const SizedBox(height: 46),

              // Last Name
              buildTextField(context, label: "Last Name", hint: 'Enter Last Name', controller: _second_controller, allowClearButton: true),
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
                              // final updatedRecord = widget.record.copyWith(
                              //   name: _first_controller.text,
                              //   description: _second_controller.text,
                              // );
                              // ref.read(EditStateProvider.notifier).editRecord(context: context, ref: ref, newRecord: updatedRecord);
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
