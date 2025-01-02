import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class InputCustomWidget extends StatelessWidget {
  final String? text;
  final TextEditingController controller;
  final IconData icon;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters; // Add this parameter
   final String? Function(String?)? validator;

  InputCustomWidget({
     this.text,
    required this.controller,
    required this.icon,
    this.obscureText = false,
    this.inputFormatters, // Accept inputFormatters as a parameter
    this.validator
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.055, // screenHeight değişkeni yerine MediaQuery kullanıldı
      child: TextField(
        controller: controller, // controller buraya eklendi
        obscureText: obscureText,
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).colorScheme.primary,
          hintText: text,
          hintStyle: const TextStyle(fontSize: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primaryContainer, size: 20),
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }
}
