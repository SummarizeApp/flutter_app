
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:literate_app/global_components/app_bar_default.dart';
import 'package:literate_app/presentations/home_screen/components/custom_pdf_picker.dart';
import 'package:literate_app/presentations/home_screen/components/custom_pdf_viewer_widget.dart';
import 'package:literate_app/presentations/home_screen/components/utils/custom_summary_button.dart';
import 'dart:io';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<File> files = [];
  String? selectedFilePath;

  void handleFilePicked(List<File> pickedFiles) {
    if (pickedFiles.isNotEmpty) {
      setState(() {
        files.add(pickedFiles.last);
        selectedFilePath = pickedFiles.last.path;
      });
    }
  }

  void removeLastFile() {
    setState(() {
      if (files.isNotEmpty) {
        files.removeLast();
        selectedFilePath = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(
        title: tr('homeScreen'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTitle(),
              const SizedBox(height: 40),
              
              PdfPickerWidget(
                onFilesPicked: handleFilePicked,
              ),
              const SizedBox(height: 40),
              if (selectedFilePath == null) _buildLottieAnimation(),
              if (files.isNotEmpty) _buildFileList(),
              const SizedBox(height: 20),
              if (selectedFilePath != null)
                PdfViewerWidget(
                  filePath: selectedFilePath!,
                  onRemoveFile: removeLastFile,
                ),
              const SizedBox(height: 20),
              if (files.isNotEmpty)
                CustomSummaryButton(
                  files: files,
                  onPressed: () {
                    // Özelleştirilmiş işlem
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      tr('chooseLawText'),
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildFileList() {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10.0),
        title: Text(
          files.last.path.split('/').last,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Icon(Icons.picture_as_pdf, color: Colors.red),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: removeLastFile,
        ),
      ),
    );
  }

   Widget _buildLottieAnimation() {
    return Center(
      child: Lottie.asset(
        'assets/lottie/law2.json', // Lottie animasyon dosya yolu
        width: 300,
        height: 300,
        repeat: true,
        animate: true,
      ),
    );
  }
}
