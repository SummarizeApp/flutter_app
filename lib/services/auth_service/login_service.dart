import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthServiceLogin {
  // Giriş işlemi
  Future<bool> login(String email, String password) async {
    final url = Uri.parse('http://192.168.8.159:3000/api/auth/login');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'email': email,
      'password': password,
    });

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final accessToken = responseBody['data']['accessToken'];
        final refreshToken = responseBody['data']['refreshToken'];

        // Token'ları SharedPreferences'a kaydet
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', accessToken);
        await prefs.setString('refresh_token', refreshToken);

        print('Giriş başarılı, Access Token: $accessToken');
        return true;
      } else {
        print('Hata: ${response.statusCode}, Mesaj: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Hata oluştu: $e');
      return false;
    }
  }

  // SharedPreferences'tan access token'ı almak
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Token'ları silmek
  Future<void> removeTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    print('Tokenlar silindi.');
  }
}
