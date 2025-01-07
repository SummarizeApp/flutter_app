import 'package:flutter/material.dart';
import 'package:literate_app/services/auth_service/forget_password_confirm_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomResetPasswordDialog extends StatefulWidget {
  final VoidCallback onResetSuccess;

  const CustomResetPasswordDialog({Key? key, required this.onResetSuccess}) : super(key: key);

  @override
  State<CustomResetPasswordDialog> createState() => _CustomResetPasswordDialogState();
}

class _CustomResetPasswordDialogState extends State<CustomResetPasswordDialog> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final ResetPasswordAuthService _authService = ResetPasswordAuthService();

  bool _isLoading = false;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  String? _newPasswordError;
  String? _confirmPasswordError;

  // Şifre uzunluğu kontrolü
  bool _isPasswordValid(String password) {
    return password.length >= 6;
  }

  Future<void> _resetPassword() async {
    setState(() {
      _isLoading = true;
      _newPasswordError = null; // Hata mesajını sıfırla
      _confirmPasswordError = null;
    });

    if (!_isPasswordValid(_newPasswordController.text.trim())) {
      setState(() {
        _newPasswordError = 'Şifre en az 6 karakter olmalıdır.';
      });
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (_newPasswordController.text.trim() != _confirmPasswordController.text.trim()) {
      setState(() {
        _confirmPasswordError = 'Şifreler eşleşmiyor.';
      });
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final resetToken = prefs.getString('resetToken');

      if (resetToken == null) {
        throw Exception('Reset token bulunamadı.');
      }

      await _authService.resetPassword(
        resetToken,
        _newPasswordController.text.trim(),
        _confirmPasswordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Şifre başarıyla sıfırlandı.')),
      );

      widget.onResetSuccess(); // Başarılı durumda bir callback çağır
      Navigator.pop(context); // Dialogu kapat
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Şifreyi Sıfırla',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Yeni Şifre TextField
            TextField(
              controller: _newPasswordController,
              obscureText: _obscureNewPassword,
              decoration: InputDecoration(
                labelText: 'Yeni Şifre',
                hintText: 'Yeni şifrenizi girin',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureNewPassword = !_obscureNewPassword;
                    });
                  },
                ),
              ),
            ),
            if (_newPasswordError != null) ...[
              const SizedBox(height: 8),
              Text(
                _newPasswordError!,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
            const SizedBox(height: 16),

            // Şifreyi Onayla TextField
            TextField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: 'Şifreyi Onayla',
                hintText: 'Şifrenizi tekrar girin',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
            ),
            if (_confirmPasswordError != null) ...[
              const SizedBox(height: 8),
              Text(
                _confirmPasswordError!,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
            const SizedBox(height: 16),

            // Reset Password Button
            ElevatedButton(
              onPressed: _isLoading ? null : _resetPassword,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Şifreyi Sıfırla'),
            ),
          ],
        ),
      ),
    );
  }
}
