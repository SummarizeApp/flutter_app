import 'package:flutter/material.dart';
import 'package:literate_app/global_components/app_bar_default.dart';
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

              // Özetlenen Hukuksal Metin
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

              // Özet Dosyası URL'si
              if (caseData['summaryFileUrl'] != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(context, "Özet Dosyası"),
                    GestureDetector(
                      onTap: () async {
                        final uri = Uri.parse(caseData['summaryFileUrl']);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Bağlantı açılamadı.")),
                          );
                        }
                      },
                      child: Text(
                        "Dosyayı Görüntüle",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
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
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Bağlantı açılamadı.")),
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
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
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
}
