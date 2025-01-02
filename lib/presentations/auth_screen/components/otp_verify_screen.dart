import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:literate_app/global_components/app_bar_default.dart';
import 'package:literate_app/presentations/auth_screen/components/utils/count_down_timer_widger.dart';
import 'package:literate_app/presentations/auth_screen/components/utils/otp_action_button.dart';
import 'package:literate_app/presentations/auth_screen/components/utils/otp_input_field.dart';
import 'package:literate_app/presentations/auth_screen/components/utils/resend_otp_section.dart';
import 'package:literate_app/services/auth_service/otp_service.dart';
import 'package:literate_app/veriables/global_veraibles.dart';

class OtpVerificationScreen extends StatefulWidget {
  OtpVerificationScreen({super.key});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController otpController = TextEditingController();
  final AuthServiceVerifyOtp authServiceVerifyOtp = AuthServiceVerifyOtp();

  late Timer _timer;
  int _remainingTime = 10; // 5 dakika = 300 saniye
  bool _isButtonDisabled = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime == 0) {
        setState(() {
          _isButtonDisabled = true; // Buton devre dışı bırakılır
        });
        _timer.cancel();
      } else {
        setState(() {
          _remainingTime--;
        });
      }
    });
  }

  String get _formattedTime {
    final minutes = (_remainingTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingTime % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(
        title: tr('emailAppBar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
             Text(
              tr('enterOtp'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
             SizedBox(height: screenHeight *0.030),
            CountdownTimer(
              remainingTime: _remainingTime,
              formattedTime: _formattedTime,
            ),
             SizedBox(height: screenHeight*  0.030),
            OtpInputField(
              controller: otpController,
            ),
             SizedBox(height: screenHeight * 0.02),
            OtpActionButton(
              isDisabled: _isButtonDisabled,
              onPressed: () async {
                final otpCode = otpController.text.trim();
                try {
                  final tokens = await authServiceVerifyOtp.sendOtpVerificationRequest(otpCode);
                  if (tokens != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text(tr('succesMail'))),
                    );
                    context.go('/navigator');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text (tr('invalidOtp'))),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text(tr('verificationError'))),
                  );
                }
              },
            ),
             SizedBox(height: screenHeight * 0.02),
            ResendOtpSection(),
          ],
        ),
      ),
    );
  }
}







