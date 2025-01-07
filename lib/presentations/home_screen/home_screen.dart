import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:literate_app/global_components/app_bar_default.dart';
import 'package:literate_app/presentations/home_screen/components/custom_pdf_picker.dart';
import 'package:literate_app/presentations/home_screen/components/custom_pdf_viewer_widget.dart';
import 'package:literate_app/presentations/home_screen/components/utils/custom_summary_button.dart';
import 'package:literate_app/services/summary_service/pdf_uplaoud_service.dart';
import 'dart:io';
import 'package:lottie/lottie.dart';
import 'package:mime/mime.dart';  // mime paketini dahil ettik

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<File> files = [];
  String? selectedFilePath;
  bool isLoading = false; // Yükleme durumunu takip etmek için
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void handleFilePicked(List<File> pickedFiles) {
    if (pickedFiles.isNotEmpty) {
      final pickedFile = pickedFiles.last;
      final mimeType = lookupMimeType(pickedFile.path); // Dosyanın mime türünü alıyoruz
      final fileExtension = pickedFile.path.split('.').last.toLowerCase(); // Dosya uzantısını alıyoruz

      // Eğer dosyanın türü pdf ise
      if (mimeType == 'application/pdf' || fileExtension == 'pdf') {
        setState(() {
          files.add(pickedFile);
          selectedFilePath = pickedFile.path;
          titleController.text = pickedFile.path.split('/').last; // Dosya ismini başlık olarak ayarla
        });
      } else {
        // Eğer dosya pdf değilse, hata mesajı gösteriyoruz
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lütfen sadece PDF dosyaları yükleyin")),
        );
      }
    }
  }

  void removeLastFile() {
    setState(() {
      if (files.isNotEmpty) {
        files.removeLast();
        selectedFilePath = null;
        titleController.clear();
        descriptionController.clear();
      }
    });
  }

  Future<void> summarizeFiles() async {
    if (files.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen bir dosya seçin")),
      );
      return;
    }

    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Başlık ve açıklama alanlarını doldurmanız gerekiyor")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      for (var file in files) {
        var response = await FileUploadService().uploadFile(
          title: titleController.text, // Kullanıcının girdiği başlık
          description: descriptionController.text, // Kullanıcının girdiği açıklama
          file: file,
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Dosya başarıyla yüklendi!")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Dosya yükleme başarısız: ${response.body}")),
          );
        }
        print(response.body);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
             _buildTextFields(),
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
                  onPressed: summarizeFiles, // Özetleme işlemini başlat
                ),
                const SizedBox(height: 20),
              if (isLoading) const CircularProgressIndicator(), // Yükleme göstergesi
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

  Widget _buildTextFields() {
    return Column(
      children: [
        TextField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: "Başlık",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: descriptionController,
          decoration: InputDecoration(
            labelText: "Açıklama",
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildLottieAnimation() {
    return Center(
      child: Lottie.asset(
        'assets/lottie/law2.json',
        width: 300,
        height: 300,
        repeat: true,
        animate: true,
      ),
    );
  }
}