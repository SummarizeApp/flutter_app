import 'dart:io';
import 'package:flutter/material.dart';
import 'package:literate_app/global_components/app_bar_default.dart';
import 'package:http/http.dart' as http;
import 'package:literate_app/veriables/global_veraibles.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CaseDetailScreen extends StatelessWidget {
  final Map<String, dynamic> caseData;

  const CaseDetailScreen({super.key, required this.caseData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(
        title: caseData['title'],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Açıklama
              _buildSectionHeader(context, "Açıklama"),
              _buildSectionContent(caseData['description']),
              const SizedBox(height: 20),

              // Oluşturulma Tarihi
              _buildSectionHeader(context, "Oluşturulma Tarihi"),
              _buildSectionContent(caseData['createdAt'].split('T')[0]),
              const SizedBox(height: 20),

              // İçerik
              _buildSectionHeader(context, "Özetlenen Hukuksal Metnin:"),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  caseData['summary'],
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Dosyalar (Eğer varsa)
              if (caseData['files'] != null && caseData['files'].isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(context, "Dosyalar"),
                    ...caseData['files'].map<Widget>((file) {
                      return GestureDetector(
                        onTap: () async {
                          final uri = Uri.parse(file);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri,
                                mode: LaunchMode.externalApplication);
                          } else {
                            // URL'nin logunu yazdır
                            print("Açılamayan URL: $uri");

                            // Kullanıcıya Snackbar ile bilgi ver
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Bağlantı açılamadı.")),
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            children: [
                              const Icon(Icons.file_present, color: Colors.red),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  file,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.download),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black87,
        height: 1.5,
      ),
    );
  }

  // Future<void> _downloadFile(BuildContext context, String url) async {
  //   try {
  //     // Token'ı alın (Global değişken veya bir yöntemle depolanan token)
  //     final token = await getValueFromStore('access_token', 'string');
  //     if (token == null) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //             content: Text("Token bulunamadı. Lütfen giriş yapınız.")),
  //       );
  //       return;
  //     }

  //     // İstek için Authorization başlığını ekleyin
  //     final headers = {
  //       'Authorization': 'Bearer $token',
  //     };

  //     final response = await http.get(Uri.parse(url), headers: headers);

  //     if (response.statusCode == 200) {
  //       final directory = await getApplicationDocumentsDirectory();
  //       final filePath = "${directory.path}/${url.split('/').last}";

  //       final file = File(filePath);
  //       await file.writeAsBytes(response.bodyBytes);

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Dosya indirildi: $filePath")),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //             content: Text(
  //                 "Dosya indirilemedi. Hata kodu: ${response.statusCode}")),
  //       );
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Dosya indirme sırasında bir hata oluştu: $e")),
  //     );
  //   }
  // }
}
