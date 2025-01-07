import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ForgetPasswordAuthService {
  final String forgotPasswordUrl = "http://192.168.8.159:3000/api/auth/forgot-password";
  final String verifyResetOtpUrl = "http://192.168.8.159:3000/api/auth/verify-reset-otp";

  // Forgot Password Request
  Future<void> sendForgotPasswordRequest(String email, String token) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = jsonEncode({'email': email});

    try {
      final response = await http.post(
        Uri.parse(forgotPasswordUrl),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['status'] == 'success') {
          // userId'yi SharedPreferences ile kaydet
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('userId', responseBody['data']['userId']);
          print('UserId saved: ${responseBody['data']['userId']}');
        } else {
          throw Exception(responseBody['msg']);
        }
      } else {
        final responseBody = jsonDecode(response.body);
        throw Exception('Error: ${responseBody['message']}');
      }
    } catch (e) {
      print('Forgot Password Error: $e');
      throw Exception('Failed to send forgot password request: $e');
    }
  }

  // Verify OTP Request
  Future<void> verifyResetOtp(String otpCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('userId');

  if (userId == null) {
    throw Exception('UserId bulunamadı. Lütfen önce şifre sıfırlama isteği gönderin.');
  }

  final headers = {
    'Content-Type': 'application/json',
  };

  final body = jsonEncode({
    'userId': userId,
    'otpCode': otpCode,
  });

  try {
    final response = await http.post(
      Uri.parse(verifyResetOtpUrl),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      print('OTP Verification Success: ${responseBody['msg']}');

      // `resetToken` değerini kaydetme
      final resetToken = responseBody['data']['resetToken'];
      await prefs.setString('resetToken', resetToken);

      print('Reset token saved: $resetToken');
    } else {
      final responseBody = jsonDecode(response.body);
      throw Exception('Error: ${responseBody['message']}');
    }
  } catch (e) {
    print('Verify OTP Error: $e');
    throw Exception('Failed to verify OTP: $e');
  }
}

}
