import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/common/controller/userController.dart';
import 'package:image_picker/image_picker.dart';

import '../../../res/appColors.dart';



class ProfileImagePicker extends StatefulWidget {
  final void Function(Uint8List pickedBytes) onImageSelected;
  final Uint8List? initialImage; // <-- new field

  const ProfileImagePicker({
    super.key,
    required this.onImageSelected,
    this.initialImage,
  });

  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.initialImage;
  }

  Uint8List? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (pickedFile != null) {
      final bytes = await File(pickedFile.path).readAsBytes();
      setState(() {
        _selectedImage = bytes;
      });
      widget.onImageSelected(bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.primaryColor,
            backgroundImage: _selectedImage != null ? MemoryImage(_selectedImage!) : null,
            child: _selectedImage == null ? Icon(Icons.account_circle_outlined, size: 70, color: Colors.white) : null,
          ),
          Positioned(
            bottom: 0,
            right: -4,
            child: Icon(Icons.edit, size: 26, color: AppColors.primaryColor),
          ),
        ],
      ),
    );
  }
}

