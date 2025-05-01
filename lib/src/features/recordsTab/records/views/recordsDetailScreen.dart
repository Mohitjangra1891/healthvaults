import 'package:flutter/material.dart';
import 'package:healthvaults/src/modals/record.dart';
import 'package:http/http.dart' as http;
import 'package:pdfx/pdfx.dart';

class recordDetailScreen extends StatefulWidget {
  final MedicalRecord record;

  const recordDetailScreen({super.key, required this.record});

  @override
  State<recordDetailScreen> createState() => _PdfAsImageScreenState();
}

class _PdfAsImageScreenState extends State<recordDetailScreen> {
  late final PdfDocument _document;

  // PdfPageImage? _pageImage;
  final List<PdfPageImage> _pages = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  // Future<void> _loadPdf() async {
  //   final response = await http.get(Uri.parse(widget.record.link));
  //   if (response.statusCode == 200) {
  //     _document = await PdfDocument.openData(response.bodyBytes);
  //
  //     final page = await _document.getPage(1);
  //     _pageImage = await page.render(
  //       width: page.width,
  //       height: page.height,
  //       format: PdfPageImageFormat.png,
  //     );
  //     await page.close();
  //
  //     if (mounted) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     }
  //   } else {
  //     // Handle error
  //     debugPrint('Failed to load PDF: ${response.statusCode}');
  //   }
  // }
  Future<void> _loadPdf() async {
    try {
      final response = await http.get(Uri.parse(widget.record.link));
      // print(response.statusCode);
      // print(response.body);

      if (response.statusCode == 200) {
        _document = await PdfDocument.openData(response.bodyBytes);

        for (int i = 1; i <= _document.pagesCount; i++) {
          final page = await _document.getPage(i);
          final pageImage = await page.render(
            width: page.width,
            height: page.height,
            format: PdfPageImageFormat.png,
          );
          await page.close();
          _pages.add(pageImage!);
        }

        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        debugPrint('Failed to load PDF: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error loading PDF: $e');
    }
  }

  @override
  void dispose() {
    _document.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text(widget.record.name)),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                BackButton(
                  color: Colors.black,
                ),
                Text(
                  widget.record.name,
                  style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Spacer(),
                IconButton(onPressed: () {}, icon: Icon(Icons.share))
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 28),
              child: Text(
                widget.record.description,
                style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 28),
              //   child: _pageImage != null
              //       ? InteractiveViewer(panEnabled: true, scaleEnabled: true, child: Image.memory(_pageImage!.bytes))
              //       : const Text("Failed to load PDF image"),
              // ),
              Expanded(
                child: InteractiveViewer(
                  trackpadScrollCausesScale: true,
                  panEnabled: true,
                  scaleEnabled: true,
                  child: ListView.builder(
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      return Container(
                        color: Colors.grey.shade200,
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Image.memory(
                          _pages[index].bytes,
                          fit: BoxFit.fitWidth,
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
