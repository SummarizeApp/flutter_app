import 'package:flutter/services.dart';

class PhoneNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    // Sadece rakamları al
    text = text.replaceAll(RegExp(r'\D'), '');

    // Telefon numarasını formatla: (XXX) XXX XX XX
    if (text.length > 10) {
      text = '(${text.substring(0, 3)}) ${text.substring(3, 6)} ${text.substring(6, 8)} ${text.substring(8, 10)}';
    } else if (text.length > 6) {
      text = '(${text.substring(0, 3)}) ${text.substring(3, 6)} ${text.substring(6)}';
    } else if (text.length > 3) {
      text = '(${text.substring(0, 3)}) ${text.substring(3)}';
    } else if (text.isNotEmpty) {
      text = '(${text.substring(0)}';
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
