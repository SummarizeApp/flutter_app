import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class OtpInputField extends StatelessWidget {
  final TextEditingController controller;

  const OtpInputField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: tr('otp'),
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primaryContainer),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primaryContainer, width: 2),
        ),
        prefixIcon: Icon(Icons.lock, color: Theme.of(context).colorScheme.primaryContainer),
      ),
      keyboardType: TextInputType.number,
      style: const TextStyle(fontSize: 16),
    );
  }
}
