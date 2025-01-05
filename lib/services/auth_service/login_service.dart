import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthServiceLogin {
  // Giriş işlemi
  Future<bool> login(String email, String password) async {
    final url = Uri.parse('http://192.168.1.45:3000/api/auth/login');
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
        print('Giriş başarılı, Access Token: ${responseBody['data']['accessToken']}');
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
    final accessToken = prefs.getString('access_token');
    print('SharedPreferences Access Token: $accessToken');
    return accessToken;
  }

  // Token'ları silmek
  Future<void> removeTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    print('Token silindi.');
  }
}
