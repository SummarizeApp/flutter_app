import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';


class PdfViewerWidget extends StatefulWidget {
  final String filePath;
  final VoidCallback? onRemoveFile;
  
  const PdfViewerWidget({
    Key? key,
    required this.filePath,
    this.onRemoveFile, // Parametre burada kullanılıyor
  }) : super(key: key);

  @override
  _PdfViewerWidgetState createState() => _PdfViewerWidgetState();
}

class _PdfViewerWidgetState extends State<PdfViewerWidget> {
  double _currentScale = 1.0; // PDF zoom scale

  void _zoomIn() {
    setState(() {
      _currentScale = (_currentScale + 0.2).clamp(0.5, 3.0); // Clamp zoom scale
    });
  }

  void _zoomOut() {
    setState(() {
      _currentScale = (_currentScale - 0.2).clamp(0.5, 3.0); // Clamp zoom scale
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: 500,
        maxWidth: double.infinity,
      ),
      child: Stack(
        children: [
          Card(
            elevation: 4,
            color: Colors.white,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    height: 500,
                    child: Transform.scale(
                      scale: _currentScale,
                      child: PDFView(
                        filePath: widget.filePath,
                        enableSwipe: true,
                        swipeHorizontal: false,
                        autoSpacing: true,
                        pageFling: true,
                        onRender: (pages) {
                          setState(() {});
                        },
                        onError: (error) {
                          print(error.toString());
                        },
                        onPageError: (page, error) {
                          print('Page $page: $error');
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.zoom_in, color: Colors.blue),
                  onPressed: _zoomIn,
                ),
                IconButton(
                  icon: const Icon(Icons.zoom_out, color: Colors.blue),
                  onPressed: _zoomOut,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
