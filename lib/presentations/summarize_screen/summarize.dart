import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:literate_app/global_components/app_bar_default.dart';
import 'package:literate_app/presentations/summarize_screen/components/case_detail_screen.dart';
import 'package:literate_app/services/summary_service/delete_summarize_service.dart';
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
    _fetchCases();
  }

  void _fetchCases() {
    setState(() {
      _cases = _caseService.fetchCases();
    });
  }

  void _deleteCase(int index) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Silmek İstiyor musunuz?"),
        content: const Text("Bu davayı silmek istediğinize emin misiniz?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("İptal"),
          ),
          TextButton(
            onPressed: () async {
              final deleteCaseService = DeleteCaseService();
              try {
                // Silinecek dava ID'sini liste olarak oluştur
                final cases = await _cases;
                final caseId = cases[index]['_id'] as String;
                final caseIds = [caseId]; // caseIds için liste oluşturuyoruz

                // Servis çağrısını yap
                await deleteCaseService.deleteCase(caseIds);

                // Başarılı olursa listeyi güncelle
                setState(() {
                  _cases = _cases.then((cases) {
                    cases.removeAt(index);
                    return cases;
                  });
                });

                // Kullanıcıya bilgi ver
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Dava başarıyla silindi."),
                    duration: Duration(seconds: 2),
                  ),
                );
              } catch (e) {
                // Hata durumunda kullanıcıya bilgi ver
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Silme işlemi başarısız: $e"),
                    duration: const Duration(seconds: 2),
                  ),
                );
              } finally {
                Navigator.of(context).pop();
              }
            },
            child: const Text(
              "Sil",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
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
                        onPressed: _fetchCases,
                        child: const Text("Yeniden Dene"),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: cases.length,
              itemBuilder: (context, index) {
                final caseData = cases[index];
                return Slidable(
                  key: ValueKey(caseData['_id']),
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    extentRatio: 0.25,
                    children: [
                   CustomSlidableAction(
  onPressed: (context) {
    _deleteCase(index);
  },
  backgroundColor: Colors.transparent,
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.delete_forever,
        size: 40, // İkon boyutunu burada büyütebilirsiniz.
        color: Colors.red,
      ),
      const SizedBox(height: 4),
      const Text(
        "Sil",
        style: TextStyle(
          color: Colors.red,
          fontSize: 14,
        ),
      ),
    ],
  ),
),


                    ],
                  ),
                  child: Card(
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
                        if (caseData['summary'] == null ||
                            caseData['summary'].isEmpty) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Bilgilendirme"),
                                content: const Text(
                                    "Hukuksal metniniz hala özetleniyor. Lütfen bekleyiniz."),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Tamam"),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CaseDetailScreen(caseData: caseData),
                            ),
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
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
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("No cases found."));
          }
        },
      ),
    );
  }
}
