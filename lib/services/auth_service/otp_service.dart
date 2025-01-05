import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthServiceVerifyOtp {
  Future<Map<String, String>?> sendOtpVerificationRequest(String otpCode) async {
    final url = Uri.parse('http://192.168.1.45:3000/api/auth/verify-otp');
    final headers = {'Content-Type': 'application/json'};

    // SharedPreferences'tan userId'yi al
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) {
      print('User ID bulunamadı. Doğrulama işlemi başarısız.');
      return null;
    }

    final body = jsonEncode({
      'userId': userId,
      'otpCode': otpCode,
    });

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Doğrulama başarılı: $responseData');

        // accessToken ve refreshToken kaydet
        final accessToken = responseData['data']['accessToken'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', accessToken);

        return {
          'accessToken': accessToken,
          'refreshToken': responseData['data']['refreshToken'],
        };
      } else {
        print('Hata: ${response.statusCode}, Mesaj: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Hata oluştu: $e');
      return null;
    }
  }
}
