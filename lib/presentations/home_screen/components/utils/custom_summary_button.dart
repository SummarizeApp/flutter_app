import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomSummaryButton extends StatelessWidget {
  final List<File> files;  // List of picked files
  final Function onPressed; // Action to be performed when button is pressed

  const CustomSummaryButton({
    Key? key,
    required this.files,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: files.isNotEmpty ? () => onPressed() : null, // Button disabled if no files
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer , // Blue when files are selected, grey otherwise
      ),
      child: Text(
        tr('selectedSummary'), // Button text
        style:  const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
