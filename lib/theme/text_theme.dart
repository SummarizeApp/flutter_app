

import 'package:flutter/material.dart';
import 'package:literate_app/veriables/global_veraibles.dart';

TextTheme textTheme = TextTheme(
  //Hoş geldiniz, Giriş Yap
  titleLarge: TextStyle(
    fontSize: screenWidth * 0.079,
    color: Colors.white,
    fontWeight: FontWeight.w700,
  ),
  //Merhaba {isim}
  titleMedium: TextStyle(
    fontSize: screenWidth * 0.046, //0.050
    color: Colors.white,
    fontWeight: FontWeight.w700,
  ),
  titleSmall: TextStyle(
    fontSize: screenWidth * 0.042, //0.045
    color: Colors.white,
    fontWeight: FontWeight.w600,
  ),
  //Dream created date
  bodyLarge: TextStyle(
    fontSize: screenWidth * 0.04, //0.042
    color: Colors.white,
    fontWeight: FontWeight.w500,
  ),
  bodyMedium: TextStyle(
    fontSize: screenWidth * 0.036, //0.038
    color: Colors.white,
    fontWeight: FontWeight.w500,
  ),
  bodySmall: TextStyle(
    fontSize: screenWidth * 0.034, // 0.035
    color: Colors.white,
    fontWeight: FontWeight.w400,
  ),
);
