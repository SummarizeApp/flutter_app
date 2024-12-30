import 'package:flutter/material.dart';

class CustomAlertContent extends StatelessWidget {
  final String
      svgName; // Bu, SVG'nin adını temsil ediyordu, artık ikon ismi olacak
  final String body;
  final String buttonText;
  final String? cancelButtonText;

  final void Function()? onPressButton;
  final void Function()? onPressCancel;

  const CustomAlertContent({
    super.key,
    required this.svgName, // İkon adı yerine alacak
    required this.body,
    required this.buttonText,
    this.onPressButton,
    this.onPressCancel,
    this.cancelButtonText,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Icon gösterimi
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Icon(
            svgName == 'error'
                ? Icons.error
                : Icons.warning, // Olumsuz durumu simgeleyen ikonlar
            size: screenWidth *
                0.2, // İkon boyutunu ekran genişliğine göre ayarla
            color: Colors.red, // İkon rengini kırmızı yapalım
          ),
        ),
        const SizedBox(height: 16), // Mesaj ile ikon arasındaki boşluk
        Text(
          body,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24), // Butonlar arasındaki boşluk
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Butonları ortalayalım
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onPressButton?.call();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .primaryContainer, // Metin rengi
                    elevation: 5, // Gölge efekti
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Yuvarlatılmış köşeler
                    ),
                  ),
                  child: Text(buttonText),
                ),
              ),
            ),
            // Cancel butonu (varsa)
            if (cancelButtonText != null)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onPressCancel?.call();
                    },
                    child: Text(cancelButtonText!),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.red, // Cancel butonu kırmızı olmalı
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16), // Alt boşluk
      ],
    );
  }
}
