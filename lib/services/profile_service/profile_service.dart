import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:literate_app/veriables/global_veraibles.dart';

class ProfileService {
  // Profil bilgilerini getiren fonksiyon
  Future<Map<String, dynamic>> fetchProfile() async {
    // Token'ı getValueFromStore ile al
    final token = await getValueFromStore('access_token', 'string');
    if (token == null) {
      throw Exception('Token bulunamadı. Lütfen giriş yapınız.');
    }

    final url = Uri.parse('http://192.168.1.30:3000/api/auth/profile');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Token'ı Authorization başlığında kullanıyoruz
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        // Başarılı istek
        final responseBody = jsonDecode(response.body);
        if (responseBody['status'] == 'success') {
          // "data" içindeki "user" objesini döndür
          return responseBody['data']['user']; // Sadece user bilgileri döner
        } else {
          throw Exception('Profil bilgileri alınamadı: ${responseBody['msg']}');
        }
      } else if (response.statusCode == 401) {
        // Yetkilendirme hatası
        throw Exception('Yetkisiz erişim. Lütfen tekrar giriş yapınız.');
      } else {
        throw Exception('Sunucu hatası: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Profil bilgisi alınırken hata oluştu: $e');
    }
  }
}
