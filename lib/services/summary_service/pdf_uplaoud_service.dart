import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mime/mime.dart'; // MIME tipi kontrolü için import
import 'package:http_parser/http_parser.dart';

class FileUploadService {
  final String endpoint = "http://192.168.1.45:3000/api/cases";

  Future<http.Response> uploadFile({
    required String title,
    required String description,
    required File file,
  }) async {
    // Token'ı SharedPreferences'tan al
    final token = await _getAccessToken();
    print('Alınan Token: $token');
    
    if (token == null) {
      throw Exception('Token bulunamadı. Lütfen giriş yapınız.');
    }

    try {
      // Multipart request oluşturma
      var request = http.MultipartRequest('POST', Uri.parse(endpoint));

      // Authorization başlığını ekle
      request.headers['Authorization'] = 'Bearer $token';

      // Text alanlarını ekle
      request.fields['title'] = title;
      request.fields['description'] = description;

      // Dosya uzantısını kontrol et ve MIME tipini al
      final mimeType = lookupMimeType(file.path); // Dosyanın MIME tipini alıyoruz
      if (mimeType != 'application/pdf') {
        throw Exception('Yalnızca PDF dosyaları kabul edilir!');
      }

      // Dosyayı ekle
      var fileStream = http.ByteStream(file.openRead());
      var fileLength = await file.length();
      var multipartFile = http.MultipartFile(
        'file',
        fileStream,
        fileLength,
        filename: file.path.split('/').last,
        contentType: mimeType != null ? MediaType.parse(mimeType) : MediaType('application', 'pdf'), // MIME tipi belirtildi
      );

      request.files.add(multipartFile);

      // İstek gönderme
      var response = await request.send();

      // Yanıtı döndürme
      return http.Response.fromStream(response);
    } catch (e) {
      throw Exception("File upload failed: $e");
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
