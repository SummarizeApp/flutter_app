import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:literate_app/veriables/global_veraibles.dart';

class CaseService {
  final String _baseUrl = "http://192.168.1.30:3000/api/cases";

  Future<List<dynamic>> fetchCases() async {
  final token = await getValueFromStore('access_token', 'string');
  if (token == null) {
    throw Exception('Token bulunamadı. Lütfen giriş yapınız.');
  }

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  try {
    final response = await http.get(Uri.parse(_baseUrl), headers: headers);
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['status'] == 'success') {
        return responseBody['data']; // Sadece "data" listesini döndür
      } else {
        throw Exception('API Error: ${responseBody['msg']}');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized - Please check your token.');
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  } catch (e) {
    print('Fetch Cases Error: $e');
    throw Exception('Failed to load cases: $e');
  }
}

}
