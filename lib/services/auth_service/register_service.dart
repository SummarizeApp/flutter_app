import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:literate_app/models/user_modal.dart';
// UserModel'in bulunduğu dosya yolu

class AuthServiceRegister {
  // Kayıt isteği gönderen fonksiyon
  Future<void> sendRegisterRequest(UserModel user) async {
    final url = Uri.parse('http://192.168.1.30:3000/api/auth/register');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'email': user.email,
      'password': user.password,
      'connactNumber': user.connactNumber,
      'username': user.username,
    });

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        // Başarılı istek
        print('Kayıt başarılı: ${response.body}');
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
  Future<bool> Register(String email, String password) async {
    final url = Uri.parse('http://192.168.1.30:3000/api/auth/register');
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
