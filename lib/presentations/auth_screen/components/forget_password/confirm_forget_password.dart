import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:literate_app/presentations/auth_screen/components/forget_password/confirm_password_custom_widget.dart';
import 'dart:async';
import 'package:literate_app/services/auth_service/forget_password_service.dart';

class CustomConfirmMail extends StatefulWidget {
  final VoidCallback onConfirm;

  const CustomConfirmMail({Key? key, required this.onConfirm}) : super(key: key);

  @override
  State<CustomConfirmMail> createState() => _CustomConfirmMailState();
}

class _CustomConfirmMailState extends State<CustomConfirmMail> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final ForgetPasswordAuthService _authService = ForgetPasswordAuthService();

  bool _isLoading = false;
  bool _showOtpSection = false;
  bool _isOtpButtonEnabled = true;
  int _remainingSeconds = 600; // 10 dakika
  Timer? _timer;

  String? _emailError;
  String? _otpError;

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isOtpButtonEnabled = false;
        });
      }
    });
  }

  Future<void> _sendForgotPassword() async {
    setState(() {
      _isLoading = true;
      _emailError = null; // Reset error message
    });

    final email = _emailController.text.trim();
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

    if (!emailRegex.hasMatch(email)) {
      setState(() {
        _emailError = 'Lütfen geçerli bir e-posta adresi girin.';
      });
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final token = "your_token"; // Token'ı alın (örneğin, SecureStorage'den)
      await _authService.sendForgotPasswordRequest(email, token);
      setState(() {
        _showOtpSection = true;
        _remainingSeconds = 600;
        _isOtpButtonEnabled = true;
      });
      _startCountdown();
    } catch (e) {
      setState(() {
        _emailError = 'Böyle bir e-posta adresi bulunamadı.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _verifyOtp() async {
    setState(() {
      _isLoading = true;
      _otpError = null; // Reset OTP error message
    });

    try {
      await _authService.verifyResetOtp(_otpController.text.trim());
      await showDialog(
        context: context,
        builder: (context) => CustomResetPasswordDialog(
          onResetSuccess: () {
            // Şifre sıfırlandıktan sonra yapılacaklar
            print('Şifre başarıyla sıfırlandı.');
          },
        ),
      );
      Navigator.pop(context); // Dialogu kapat
    } catch (e) {
      setState(() {
        _otpError = 'Hata: Yanlış OTP kodu girdiniz.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Email TextField
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'E-mail',
              hintText: 'E-posta adresinizi girin',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          if (_emailError != null) ...[
            const SizedBox(height: 8),
            Text(
              _emailError!,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
          const SizedBox(height: 16),

          // Send Password Reset Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              foregroundColor: Colors.white,
            ),
            onPressed: _isLoading ? null : _sendForgotPassword,
            child: _isLoading
                ? CircularProgressIndicator(color: Colors.white)
                : Text('Şifreni sıfırla'),
          ),

          if (_showOtpSection) ...[
            const SizedBox(height: 32),
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blueAccent,
              child: Text(
                _formatTime(_remainingSeconds),
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),

            // OTP TextField
            TextField(
              controller: _otpController,
              decoration: InputDecoration(
                labelText: 'OTP Kod',
                hintText: 'Gelen OTP kodunu girin',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            if (_otpError != null) ...[
              const SizedBox(height: 8),
              Text(
                _otpError!,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
            const SizedBox(height: 16),

            // Verify OTP Button
            ElevatedButton(
                style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              foregroundColor: Colors.white,
            ),
              onPressed: _isOtpButtonEnabled && !_isLoading ? _verifyOtp : null,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Doğrula'),
            ),
          ],
        ],
      ),
    );
  }
}
