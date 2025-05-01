import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthvaults/src/features/recordsTab/records/controller/recordController.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../common/views/widgets/toast.dart';

class UploadService {
  static Future<http.Response> uploadPdf({
    required File pdfFile,
    required String name,
    required String description,
    required String date,
    required String type,
    required String pid,
    required String token,
  }) async {
    try {
      log('🔄 [UploadService] Starting PDF upload process...');
      log('📄 File path: ${pdfFile.path}');
      log('🧾 Name: $name, Description: $description, Date: $date, Type: $type, PID: $pid');

      final uri = Uri.parse('https://myhealthvaults.com/api/v1/record/profile/upload');
      log('🌐 API Endpoint: $uri');

      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['name'] = name
        ..fields['description'] = description
        ..fields['date'] = date
        ..fields['type'] = type
        ..fields['pid'] = pid;

      final mimeType = lookupMimeType(pdfFile.path) ?? 'application/pdf';
      log('📎 MIME type resolved: $mimeType');

      final multipartFile = await http.MultipartFile.fromPath(
        'pdfFile',
        pdfFile.path,
        contentType: MediaType.parse(mimeType),
        filename: basename(pdfFile.path),
      );

      request.files.add(multipartFile);
      log('📦 Multipart file prepared: ${multipartFile.filename}');

      final streamedResponse = await request.send();
      log('📡 Request sent. Awaiting streamed response...');

      final response = await http.Response.fromStream(streamedResponse);
      log('✅ Response received. Status code: ${response.statusCode}');

      log('🔍 Response body: ${response.body}');
      return response;
    } catch (e, st) {
      log('❌ Exception during upload: $e', stackTrace: st);
      rethrow;
    }
  }
}

// Image and PDF Selection State
class FileSelectionState {
  final List<File> images;
  final File? pdfFile;

  FileSelectionState({required this.images, this.pdfFile});

  FileSelectionState copyWith({List<File>? images, File? pdfFile}) {
    return FileSelectionState(
      images: images ?? this.images,
      pdfFile: pdfFile ?? this.pdfFile,
    );
  }
}

final fileSelectionProvider = StateNotifierProvider<FileSelectionNotifier, FileSelectionState>((ref) {
  return FileSelectionNotifier();
});

class FileSelectionNotifier extends StateNotifier<FileSelectionState> {
  FileSelectionNotifier() : super(FileSelectionState(images: [], pdfFile: null));
   int maxFileSizeInBytes = 5 * 1024 * 1024; // 5MB

  void clearAll() {
    state = FileSelectionState(images: [], pdfFile: null); // resets everything
  }
  Future<void> pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked != null) {
      state = state.copyWith(images: [...state.images, File(picked.path)]);
    }
  }
  Future<void> pickMultipleImages(BuildContext context) async {
    final pickedFiles = await ImagePicker().pickMultiImage();

    if (pickedFiles != null) {
      final newFiles = pickedFiles.map((file) => File(file.path)).toList();

      final totalSize = newFiles.fold<int>(0, (sum, file) => sum + file.lengthSync());

      if (totalSize > maxFileSizeInBytes) {
        showToast('Selected images exceed 5MB. Please choose smaller files.');

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Selected images exceed 5MB. Please choose smaller files.')),
        // );
        return;
      }

      state = state.copyWith(images: [...state.images, ...newFiles]);
    }
  }
  Future<void> pickPdf(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);

      if (file.lengthSync() > maxFileSizeInBytes) {
        showToast( 'Selected PDF is larger than 5MB. Please choose a smaller file.');

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Selected PDF is larger than 5MB. Please choose a smaller file.')),
        // );
        return;
      }

      state = state.copyWith(pdfFile: file);
    }
  }


  Future<File> convertImagesToPdf(List<File> images) async {
    final pdf = pw.Document();
    final tempDir = await getTemporaryDirectory();
    final outputPath = "${tempDir.path}/output.pdf";

    for (var image in images) {
      final imageData = pw.MemoryImage(image.readAsBytesSync());
      pdf.addPage(pw.Page(build: (pw.Context context) => pw.Image(imageData)));
    }

    final outputFile = File(outputPath);
    await outputFile.writeAsBytes(await pdf.save());
    return outputFile;
  }

  void clearSelection() {
    state = FileSelectionState(images: [], pdfFile: null);
  }
}

// Upload State Management
class UploadState {
  final bool isLoading;
  final String? error;
  final bool success;

  UploadState({required this.isLoading, this.error, required this.success});

  factory UploadState.initial() {
    return UploadState(isLoading: false, success: false, error: null);
  }

  UploadState copyWith({bool? isLoading, String? error, bool? success}) {
    return UploadState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      success: success ?? this.success,
    );
  }
}

final uploadStateProvider = StateNotifierProvider<UploadNotifier, UploadState>((ref) {
  return UploadNotifier();
});

class UploadNotifier extends StateNotifier<UploadState> {
  UploadNotifier() : super(UploadState.initial());

  Future<void> uploadFile(
    File file,
    String name,
    String description,
    String date,
    String type,
    String pid,
    String token, {
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      final response = await UploadService.uploadPdf(
        pdfFile: file,
        name: name,
        description: description,
        date: date,
        type: type,
        pid: pid,
        token: token,
      );
      if (response.statusCode == 200) {
        log('🎉 [Provider]record Upload successful');

        await ref.read(recordListProvider.notifier).fetchInitial();
        context.pop(); // for go_router

        state = state.copyWith(isLoading: false, success: true);
      } else {
        log('⚠️ [Provider] Upload failed: ${response.reasonPhrase}');

        state = state.copyWith(isLoading: false, error: 'An error occurred. Please try again.');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'An error occurred. Please try again.');
    }
  }
}
