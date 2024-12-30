
import 'package:flutter/material.dart';
import 'package:literate_app/global_components/app_bar_default.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialState();
}

class _InitialState extends State<InitialScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: 'initial'),
      body: Center(
        child: const Text('Welcome to the Dictionary App'),
      ),
    );
  }
}
