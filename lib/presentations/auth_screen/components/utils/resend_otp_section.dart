import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ResendOtpSection extends StatelessWidget {
  const ResendOtpSection({Key? key}) : super(key: key);

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
          onTap: () {
            // OTP tekrar gönderme işlemi buraya eklenicek
          },
          child: Text(
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
