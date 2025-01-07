import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:literate_app/services/auth_service/otp_service.dart';

class ResendOtpSection extends StatefulWidget {
  const ResendOtpSection({Key? key}) : super(key: key);

  @override
  _ResendOtpSectionState createState() => _ResendOtpSectionState();
}

class _ResendOtpSectionState extends State<ResendOtpSection> {
  bool _isLoading = false;  // Yükleniyor durumu

  Future<void> _handleResendOtp(BuildContext context) async {
    setState(() {
      _isLoading = true;  // Yükleniyor durumu başlat
    });

    final authService = AuthServiceVerifyOtp();
    final result = await authService.resendOtpRequest();

    setState(() {
      _isLoading = false;  // Yükleniyor durumu sonlandır
    });

    if (result) {
      // OTP başarıyla gönderildi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tr("Doğrulama kodunuz tekrar gönderildi.")),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      // OTP gönderimi başarısız oldu
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tr("otpResentError")),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          tr("didintReceive"),
          style: TextStyle(color: Colors.white),
        ),
        GestureDetector(
          onTap: () => _handleResendOtp(context),
          child: _isLoading
              ? CircularProgressIndicator()  // Yükleniyor göstergesi
              : Text(
                  tr("resendOtp"),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ],
    );
  }
}
