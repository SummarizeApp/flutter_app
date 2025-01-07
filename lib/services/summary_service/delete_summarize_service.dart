import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DeleteCaseService {
  final String _baseUrl = 'http://192.168.8.159:3000/api/cases/delete';

  // Silme isteği gönderen metod
  Future<void> deleteCase(List<String> caseIds) async {
    try {
      final token = await _getAccessToken();  // Token'ı al
      if (token == null) {
        throw Exception('Token bulunamadı. Lütfen giriş yapınız.');
      }

      final response = await http.delete(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Authorization başlığını ekliyoruz
        },
        body: json.encode({
          'caseIds': caseIds,
        }),
      );

      if (response.statusCode == 200) {
        // Silme başarılı
        print('Silme işlemi başarılı****************************');
      } else {
        // Hata mesajı
        print('Silme işlemi başarısız*************************: ${response.body}');
      }
    } catch (e) {
      // Hata durumunda
      print('Hata*****************: $e');
    }
  }

  // SharedPreferences'tan access token'ı almak
  Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    print('SharedPreferences Access Token: $accessToken');
    return accessToken;
  }
}
