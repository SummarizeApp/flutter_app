
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';



bool isTablet = false;
double screenSizeMultiplier = 1;
double screenWidth = 0;
double screenHeight = 0;

void setScreenSize(BuildContext context) {
  if (MediaQuery.of(context).size.shortestSide>= 600) {
    isTablet = true;
  }
  screenSizeMultiplier = isTablet ? 0.6 : 1;
  screenWidth = MediaQuery.of(context).size.width * screenSizeMultiplier;
  screenHeight = MediaQuery.of(context).size.height * screenSizeMultiplier;
}


  String formatDate(DateTime? date, bool showTime, String langCode) {
  if (date == null) {
    return "";
  }
  if (showTime) {
    return DateFormat.yMMMMd(langCode).add_jm().format(date); // Tarih ve zaman (saat:dakika)
  }
  return DateFormat.yMMMMd(langCode).format(date); // Sadece tarih
}

String formatTime(DateTime? date, String langCode) {
  if (date == null) {
    return "";
  }
  return DateFormat.Hm(langCode).format(date); // Saat ve dakika (örneğin: "10:30")
}

Future<String?> getValueFromStore(String key, String type) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key); // Key’in doğru olup olmadığını kontrol edin
}




