// import 'package:dictionary_app/global_components/custom_alert_content.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:literate_app/presentations/home_screen/components/utils/custom_pdf_picker_button.dart';
import 'dart:io';

import 'package:literate_app/utils/dialog_utils.dart';

class PdfPickerWidget extends StatefulWidget {
  final void Function(List<File> files) onFilesPicked;

  const PdfPickerWidget({
    Key? key,
    required this.onFilesPicked,
  }) : super(key: key);

  @override
  State<PdfPickerWidget> createState() => _PdfPickerWidgetState();
}

class _PdfPickerWidgetState extends State<PdfPickerWidget> {
  List<File> selectedFiles = [];

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false, // Sadece bir dosya seçimine izin veriyoruz
    );

    if (result != null) {
      setState(() {
        selectedFiles = [File(result.files.single.path!)]; // Sadece bir dosya seçildiği için tek elemanlı bir liste oluşturuyoruz
      });

      widget.onFilesPicked(selectedFiles);

      // PDF dosyasının boyutunu konsola yazdırma
      var file = selectedFiles.first;
      try {
        int fileSize = file.lengthSync(); // Dosyanın boyutunu bayt olarak al
        print('File: ${file.path.split('/').last} - Size: ${fileSize / 1024} KB'); // Boyutu KB cinsinden yazdır
      } catch (e) {
        print('Error reading file size for ${file.path.split('/').last}: $e');
      }
    } else {
      // Kullanıcı dosya seçmeyi iptal ettiğinde özel alert göstermek
      _showFilePickerCancelAlert();
    }
  }

 void _showFilePickerCancelAlert() {
  showSimpleAlertModal(
    context,
    title: tr('noFileSelected'),
    body: tr('noFileSelected'), // Mesaj
    buttonText: tr('ok'),
    onPressButton: () {
      // OK butonuna tıklanıldığında yapılacak işlem
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomPdfPickerButton(
          onPressed: pickFiles, // pickFiles fonksiyonunu burada kullanın
          label: tr('pickPdfFies'),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
