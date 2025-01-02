import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class OtpActionButton extends StatelessWidget {
  final bool isDisabled;
  final VoidCallback onPressed;

  const OtpActionButton({
    Key? key,
    required this.isDisabled,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      child:  Text (tr('emailAppBar')),
    );
  }
}
