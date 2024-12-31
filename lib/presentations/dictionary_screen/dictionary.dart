import 'package:flutter/material.dart';
import 'package:literate_app/presentations/dictionary_screen/components/case_detail_screen.dart';

import 'package:literate_app/services/summary_service/summaryy_service.dart';


class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  final CaseService _caseService = CaseService();
  late Future<List<dynamic>> _cases;

  @override
  void initState() {
    super.initState();
    _cases = _caseService.fetchCases();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cases"),
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
            return ListView.builder(
              itemCount: cases.length,
              itemBuilder: (context, index) {
                final caseData = cases[index];
                return Card(
                  child: ListTile(
                    title: Text(caseData['title']),
                    subtitle: Text(caseData['description']),
                    trailing: Text(caseData['createdAt'].split('T')[0]),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CaseDetailScreen(caseData: caseData),
                        ),
                      );
                    },
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
