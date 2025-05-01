import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileDpScreen extends StatefulWidget {
  const UserProfileDpScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileDpScreen> createState() => _UserProfileDpScreenState();
}

class _UserProfileDpScreenState extends State<UserProfileDpScreen> {
  String? dp;
  late String letter = "H"; // default letter if needed

  @override
  void initState() {
    super.initState();
    loadDp();
  }

  Future<void> loadDp() async {
    final prefs = await SharedPreferences.getInstance();
    final storedDp = await prefs.getString('dp');
    final firstName = await prefs.getString('first_name');
    if (storedDp == null || storedDp == "" || storedDp.isEmpty) {
      // You can update the letter based on name if you want

      setState(() {
        letter = firstName![0].toUpperCase();
      });
    } else {
      setState(() {
        dp = storedDp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: dp != null && dp!.isNotEmpty
          ? DownloadedImageViewer(
              imageUrl: dp!,
              letter: letter,
            )
          : Container(
              width: 60,
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.blue, // Or AppColors.primaryColor
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white),
              ),
              child: Center(
                child: Text(
                  letter,
                  style: const TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
            ),
    );
  }
}

class DownloadedImageViewer extends StatefulWidget {
  final String imageUrl;
  final String letter;
  final double size;

  const DownloadedImageViewer({Key? key, required this.imageUrl, required this.letter, this.size = 60}) : super(key: key);

  @override
  State<DownloadedImageViewer> createState() => _DownloadedImageViewerState();
}

class _DownloadedImageViewerState extends State<DownloadedImageViewer> {
  Uint8List? imageBytes;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchImageBytes();
  }

  Future<void> fetchImageBytes() async {
    try {
      final response = await http.get(Uri.parse(widget.imageUrl));
      if (response.statusCode == 200) {
        setState(() {
          imageBytes = response.bodyBytes;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white),
        color: Colors.grey.shade300,
      ),
      child: isLoading
          ? Center(
              child: Text(
                " ",
                style: const TextStyle(color: Colors.white, fontSize: 22),
              ),
            )
          : imageBytes != null
              ? ClipOval(
                  child: Image.memory(
                    imageBytes!,
                    fit: BoxFit.cover,
                    width: widget.size,
                    height: widget.size,
                  ),
                )
              : Center(
                  child: Text(
                    widget.letter,
                    style: const TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ),
    );
  }
}
