import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:literate_app/services/auth_service/otp_service.dart';

class OtpVerificationScreen extends StatelessWidget {
  final TextEditingController otpController = TextEditingController();
  final AuthServiceVerifyOtp authServiceVerifyOtp = AuthServiceVerifyOtp();

  OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter the OTP sent to your email',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: otpController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'OTP Code',
                prefixIcon: Icon(Icons.lock),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final otpCode = otpController.text.trim();

                // OTP doğrulama işlemi
                try {
                  final tokens = await authServiceVerifyOtp.sendOtpVerificationRequest(otpCode);
                  if (tokens != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('OTP Verified Successfully!')),
                    );
                    // Başarılı doğrulamadan sonra '/navigator' sayfasına yönlendirme
                    context.go('/navigator');  // Burada yönlendirme doğru sayfaya yapılacak
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invalid OTP, please try again.')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('An error occurred during verification.')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
