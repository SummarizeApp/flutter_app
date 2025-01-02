import 'package:flutter/material.dart';
import 'package:literate_app/global_components/app_bar_default.dart';
import 'package:literate_app/presentations/summarize_screen/components/case_detail_screen.dart';
import 'package:literate_app/services/summary_service/summaryy_service.dart';

class SummarizeScreen extends StatefulWidget {
  const SummarizeScreen({super.key});

  @override
  State<SummarizeScreen> createState() => _SummarizeScreenState();
}

class _SummarizeScreenState extends State<SummarizeScreen> {
  final CaseService _caseService = CaseService();
  late Future<List<dynamic>> _cases;

  @override
  void initState() {
    super.initState();
    _fetchCases(); // Backend bağlantısını başlat
  }

  void _fetchCases() {
    setState(() {
      _cases = _caseService.fetchCases();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(
        title: "Hukuksal Özet",
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _cases,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final cases = snapshot.data!;
            if (cases.isEmpty) {
              // Backend boş bir liste döndüğünde gösterilecek mesaj
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Henüz bir hukuksal özet metnin bulunmamakta.\nLütfen ana sayfadan yüklemek istediğin PDF'i seç.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _fetchCases, // Yeniden deneme için
                        child: const Text("Yeniden Dene"),
                      ),
                    ],
                  ),
                ),
              );
            }
            // Eğer response doluysa card'ları göster
            return ListView.builder(
              itemCount: cases.length,
              itemBuilder: (context, index) {
                final caseData = cases[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  color: Colors.blue.shade50,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CaseDetailScreen(caseData: caseData),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          // Sol kısımda ikon
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.article_outlined,
                              size: 30,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Sağ kısımda içerik
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  caseData['title'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  caseData['description'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  caseData['createdAt'].split('T')[0],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Sağ kısımda ok ikonu
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            // Beklenmedik durum
            return const Center(child: Text("No cases found."));
          }
        },
      ),
    );
  }
}
