import 'dart:convert';
import 'package:http/http.dart' as http;

class CaseService {
  final String _baseUrl = "http://192.168.1.30:3000/api/cases";

  Future<List<dynamic>> fetchCases() async {
    
    try {
     
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
        
      } 
      
      else {
        throw Exception("Failed to load cases");
        
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
    
  }
  
}
