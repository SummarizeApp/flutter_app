import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:literate_app/models/user_modal.dart';

class AuthServiceRegister {
  // Kayıt isteği gönderen fonksiyon
  Future<void> sendRegisterRequest(UserModel user) async {
    final url = Uri.parse('http://192.168.8.159:3000/api/auth/register');
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

      if (response.statusCode == 201) {
        // Başarılı istek
        final responseData = jsonDecode(response.body);
        final userId = responseData['data']['userId'];

        // userId'yi SharedPreferences'a kaydet
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userId);

        print('Kayıt başarılı **********************************: $responseData');
         final savedUserId = prefs.getString('userId');
        print('Kaydedilen userId ********************************: $savedUserId');
       
      } else {
        
        print('Hata: ${response.statusCode}, Mesaj: ${response.body}');
      }
    } catch (e) {
      // İstek sırasında bir hata oluştu
      print('Hata oluştu: $e');
    }
  }
}
