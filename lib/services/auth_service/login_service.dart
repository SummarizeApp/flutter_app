import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthServiceLogin {
  // Giriş işlemi ve token saklama
  Future<bool> login(String email, String password) async {
    final url = Uri.parse('http://192.168.1.30:3000/api/auth/login');
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
        // Başarılı giriş, token'ları al ve sakla
        final responseBody = jsonDecode(response.body);
        final accessToken = responseBody['data']['accessToken']; // accessToken
        final refreshToken = responseBody['data']['refreshToken']; // refreshToken

        // Token'ları sakla
        await storeTokens(accessToken, refreshToken);

        print('Giriş başarılı, Access Token: $accessToken');
        return true; // Başarı durumunda true döner
      } else {
        // Hata durumu
        print('Hata: ${response.statusCode}, Mesaj: ${response.body}');
        return false; // Başarısız giriş
      }
    } catch (e) {
      // İstek sırasında bir hata oluştu
      print('Hata oluştu: $e');
      return false; // Hata durumunda false döner
    }
  }

  // Token'ları SharedPreferences'a saklamak
  Future<bool> storeTokens(String accessToken, String refreshToken) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', accessToken);
      await prefs.setString('refresh_token', refreshToken);
      print('Tokenlar başarıyla saklandı.');
      return true; // Başarı durumunda true döndür
    } catch (e) {
      print('Token saklama hatası: $e');
      return false; // Hata durumunda false döndür
    }
  }

  // SharedPreferences'tan access token'ı almak
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    print('SharedPreferences Access Token: $accessToken');
    return accessToken;
  }

  // SharedPreferences'tan refresh token'ı almak
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refresh_token');
    print('SharedPreferences Refresh Token: $refreshToken');
    return refreshToken;
  }

  // Token'ları SharedPreferences'tan silmek
  Future<void> removeTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    print('Tokenlar SharedPreferences\'tan silindi.');
  }
}
