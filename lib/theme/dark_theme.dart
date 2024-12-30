import 'package:flutter/material.dart';

import 'text_theme.dart';

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.lightBlue[800],
    fontFamily: 'Quicksand',
    textTheme: textTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    colorScheme: const ColorScheme.dark(
      surface: Color.fromARGB(255, 4, 94, 124),
      primary: Color.fromARGB(255, 5, 47, 63),
      primaryContainer: Color.fromARGB(255, 149, 175, 2),
      onPrimaryContainer: Color(0xff5f11db),
      secondary: Color(0xFF492582),
      onSecondary: Color(0xffa39bae),
      tertiary: Color(0xff23b52e),
      secondaryContainer: Color(
        0xffff1d51,
      ),
      error: Color(
        0xffff1d51,
      ),
      onSecondaryContainer: Colors.white,
      onSurface: Colors.white,
    ));

extension DarkColors on ColorScheme {
  Color get googleColor => const Color(0xfff14336);
  Color get appleColor => const Color(0xff000000).withOpacity(0.33);
  Color get darkOrange => const Color(0xFFFF8C00);
}
