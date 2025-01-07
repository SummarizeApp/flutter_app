import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart'; // flutter_slidable paketini içe aktar
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
                          child: Slidable(
                            key: ValueKey(file),
                            startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              dismissible: DismissiblePane(onDismissed: () {}),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    // Silme işlemi burada yapılır
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('$file başlığı silindi.')),
                                    );
                                  },
                                  backgroundColor: Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Sil',
                                ),
                                SlidableAction(
                                  onPressed: (context) {
                                    // Paylaşma işlemi burada yapılır
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('$file başlığı paylaşıldı.')),
                                    );
                                  },
                                  backgroundColor: Color(0xFF21B7CA),
                                  foregroundColor: Colors.white,
                                  icon: Icons.share,
                                  label: 'Paylaş',
                                ),
                              ],
                            ),
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
    return Slidable(
      key: ValueKey(title),  // Her bölüm için benzersiz bir anahtar
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {}),
        children: [
          SlidableAction(
            onPressed: (context) {
              // Silme işlemi burada yapılır
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$title başlığı silindi.')),
              );
            },
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Sil',
          ),
          SlidableAction(
            onPressed: (context) {
              // Paylaşma işlemi burada yapılır
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$title başlığı paylaşıldı.')),
              );
            },
            backgroundColor: Color(0xFF21B7CA),
            foregroundColor: Colors.white,
            icon: Icons.share,
            label: 'Paylaş',
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
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
