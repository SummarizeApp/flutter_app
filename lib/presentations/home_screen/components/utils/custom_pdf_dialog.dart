import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_pdfview/flutter_pdfview.dart'; // flutter_pdfview paketini ekledik

class PdfViewerDialog extends StatelessWidget {
  final File file;

  const PdfViewerDialog({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'PDF Görüntüleyici',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            // Pdf dosyasını pdf_flutter ile gösteriyoruz
            Expanded(
              child: PDFView(
                filePath: file.path, // Dosya yolunu veriyoruz
                enableSwipe: true, // Kaydırarak sayfalar arasında geçiş yapılabilir
                swipeHorizontal: true, // Yatay kaydırma
                autoSpacing: true, // Sayfalar arası boşluk
                pageFling: true, // Sayfa atlama
                onPageChanged: (int? current, int? total) {
                  
                },
                onError: (e) {
                  print("PDF Hatası: $e");
                },
                onPageError: (page, e) {
                  print("Sayfa hatası $page: $e");
                },
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialogu kapat
              },
              child: const Text('Kapat'),
            ),
          ],
        ),
      ),
    );
  }
}
