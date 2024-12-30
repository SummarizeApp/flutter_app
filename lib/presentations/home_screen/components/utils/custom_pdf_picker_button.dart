import 'package:flutter/material.dart';

class CustomPdfPickerButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const CustomPdfPickerButton({
    Key? key,
    required this.onPressed,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed
      ,
      borderRadius: BorderRadius.circular(30), // Yuvarlatılmış köşeler
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
       color: Theme.of(context).colorScheme.primaryContainer,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.upload_file,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
