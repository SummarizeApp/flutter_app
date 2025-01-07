import 'dart:convert';
import 'package:http/http.dart' as http;


class ResetPasswordAuthService {

  
  // final String resetPasswordUrl = "http://192.168.8.159:3000/api/auth/reset-password/:resetToken";

 Future<void> resetPassword(String resetToken, String newPassword, String confirmPassword) async {
  final String resetPasswordUrl = "http://192.168.8.159:3000/api/auth/reset-password";

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $resetToken',
  };

  final body = jsonEncode({
    'newPassword': newPassword,
    'confirmPassword': confirmPassword,
  });

  try {
    final response = await http.post(
      Uri.parse('$resetPasswordUrl/$resetToken'),
      headers: headers,
      body: body,
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      print('Password reset success: ${responseBody['message']}');
    } else {
      final responseBody = jsonDecode(response.body);
      throw Exception('Error: ${responseBody['message']}');
    }
  } catch (e) {
    print('Password reset error: $e');
    throw Exception('Failed to reset password: $e');
  }
}

}
