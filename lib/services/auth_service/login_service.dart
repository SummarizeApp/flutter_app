import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthServiceLogin {
  // Giriş isteği gönderen fonksiyon
  Future<void> sendLoginRequest(String email, String password) async {
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
        // Başarılı istek
        print('Yanıt: ${response.body}');
      } else {
        // Hata durumu
        print('Hata: ${response.statusCode}, Mesaj: ${response.body}');
      }
    } catch (e) {
      // İstek sırasında bir hata oluştu
      print('Hata oluştu: $e');
    }
  }

  // Giriş işlemi sonucu boolean döndüren fonksiyon
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
        // Başarılı istek
        print('Giriş başarılı: ${response.body}');
        return true; // Başarı durumunda true döner
      } else {
        // Hata durumu
        print('Hata: ${response.statusCode}, Mesaj: ${response.body}');
        return false; // Başarısız giriş
      }
    } catch (e) {
      print('Hata oluştu: $e');
      return false; // Hata durumunda da false döner
    }
  }
}
