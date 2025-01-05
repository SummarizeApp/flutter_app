  import 'dart:convert';
  import 'package:http/http.dart' as http;
  import 'package:literate_app/veriables/global_veraibles.dart';

  class ProfileService {
  Future<Map<String, dynamic>?> fetchProfile() async {
    final token = await getValueFromStore('access_token', 'string');
    if (token == null) {
      throw Exception('Token bulunamadı. Lütfen giriş yapınız.');
    }
    print('profile ******* Token: $token');

    final url = Uri.parse('http://192.168.8.159:3000/api/users/profile');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        if (responseBody['status'] == 'success' &&
            responseBody['data'] != null &&
            responseBody['data']['user'] != null) {
          return responseBody['data']['user'];
        } else {
          print('Profil bilgisi alınamadı: ${responseBody['msg']}');
          return null;
        }
      } else if (response.statusCode == 401) {
        throw Exception('Yetkisiz erişim. Lütfen tekrar giriş yapınız.');
      } else {
        throw Exception('Sunucu hatası: ${response.statusCode}');
      }
    } catch (e) {
      print('Profil bilgisi alınırken hata oluştu: $e');
      return null;
    }
  }
}
