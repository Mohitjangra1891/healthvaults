import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthvaults/src/res/appColors.dart';
import 'package:healthvaults/src/res/appImages.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../common/views/widgets/button.dart';
import '../../controller/uoloadRecordController.dart';

class DynamicImagePicker extends ConsumerWidget {
//   @override
//   _DynamicImagePickerState createState() => _DynamicImagePickerState();
// }
//
// class _DynamicImagePickerState extends State<DynamicImagePicker> {
  // List<File> _images = [];
  //
  // Future<void> _pickImage(ImageSource source) async {
  //   final picked = await ImagePicker().pickImage(source: source);
  //   if (picked != null) {
  //     setState(() {
  //       _images.add(File(picked.path));
  //     });
  //   }
  // }

  Widget _buildImageBox(File image, BuildContext context) {
    return Container(
      width: 70,
      height: 90,
      margin: EdgeInsets.only(right: 6, bottom: 6),
      decoration: BoxDecoration(border: Border.all(color: Theme.of(context).dividerColor)),
      child: Image.file(image, fit: BoxFit.cover),
    );
  }

  Widget _buildPdfBox(File image, BuildContext context, double width) {
    return Container(
      width: width,
      height: 90,
      margin: EdgeInsets.only(right: 6, bottom: 6),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
        color: Colors.grey,
      ),
      child: Stack(
        children: [
          // Centered logo
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 24),
              child: Image.asset(
                appImages.appLogo,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Positioned delete button
          Positioned(
            right: 40,
            top: 0,
            bottom: 0,
            child: IconButton(
              onPressed: () {},
              icon: Icon(CupertinoIcons.delete_simple),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildAddBox(BuildContext context, WidgetRef ref) {
    return Container(
      height: 90,
      width: 70,
      margin: EdgeInsets.only(right: 6, bottom: 6),
      decoration: BoxDecoration(border: Border.all(color: Theme.of(context).dividerColor)),
      child: IconButton(
          onPressed: () {
            selectImageOptionSheet(context, ref);
          },
          icon: Icon(
            CupertinoIcons.add,
            color: AppColors.primaryColor,
            size: 50,
          )),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileSelectionState = ref.watch(fileSelectionProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Click to add Documents (max size: 5mb)", style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 6),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              if (fileSelectionState.pdfFile != null)
                _buildPdfBox(fileSelectionState.pdfFile!, context, screenWidth)
              else ...[
                ...fileSelectionState.images.map((img) => _buildImageBox(img, context)).toList(),
                _buildAddBox(context, ref),
              ],
            ],
          ),
        ),
      ],
    );
  }

  void selectImageOptionSheet(BuildContext context, WidgetRef ref) {
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
                  onPressed: () async {
                    // _pickImage(ImageSource.camera);
                    await ref.read(fileSelectionProvider.notifier).pickImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                  title: "Camera"),
              const SizedBox(height: 16),
              button_Primary(
                  onPressed: () async {
                    // _pickImage(ImageSource.gallery);
                    await ref.read(fileSelectionProvider.notifier).pickMultipleImages(context);
                    Navigator.pop(context);
                  },
                  title: "Gallery"),

              const SizedBox(height: 16),
              button_Primary(
                  onPressed: () async {
                    await ref.read(fileSelectionProvider.notifier).pickPdf(context);
                    Navigator.pop(context);
                  },
                  title: "PDF"),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
