
import 'package:flutter/material.dart';
import 'package:literate_app/global_components/app_bar_default.dart';

class DictionaryScreen extends StatelessWidget {
  const DictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarDefault(
        title:  ('Dictionary Screen'),
       
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
         
        ),
      ),
    );
  }
}
