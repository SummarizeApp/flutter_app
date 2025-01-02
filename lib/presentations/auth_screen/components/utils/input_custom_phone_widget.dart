import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputCustomWidgetPhone extends StatelessWidget {
  final String? hintText;
  final TextEditingController controller;
  final IconData icon;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const InputCustomWidgetPhone({
    super.key,
    this.hintText,
    required this.controller,
    required this.icon,
    this.obscureText = false,
    this.inputFormatters,
     this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.065, 
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: TextInputType.phone, 
        inputFormatters: inputFormatters, 
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).colorScheme.primary,
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 14, color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(
            icon,
            color: Theme.of(context).colorScheme.primaryContainer,
            size: 20,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
      ),
    );
  }
}
