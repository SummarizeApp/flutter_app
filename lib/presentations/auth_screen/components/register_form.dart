import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:literate_app/models/user_modal.dart';
import 'package:literate_app/presentations/auth_screen/components/otp_verify_screen.dart';
import 'package:literate_app/presentations/auth_screen/components/utils/input_custom_phone_widget.dart';
import 'package:literate_app/presentations/auth_screen/components/utils/input_custom_widget.dart';
import 'package:literate_app/services/auth_service/register_service.dart';
import 'package:literate_app/utils/controller_auth.dart';
import 'package:literate_app/utils/phone_number_input_formatter.dart';
import 'package:literate_app/veriables/global_veraibles.dart';
// Validation fonksiyonlarını dahil ettik

class RegisterForm extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final AuthServiceRegister authServiceRegister = AuthServiceRegister();

  RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputCustomWidget(
          text: tr("userName"),
          controller: userNameController,
          icon: Icons.person,
        ),
        SizedBox(height: screenHeight * 0.020),
        InputCustomWidget(
          text: tr("email"),
          controller: emailController,
          icon: Icons.email,
        ),
        SizedBox(height: screenHeight * 0.02),
        InputCustomWidget(
          text: tr("password"),
          controller: passwordController,
          icon: Icons.lock,
          obscureText: true,
        ),
        SizedBox(height: screenHeight * 0.02),
        InputCustomWidgetPhone(
          hintText: tr("contactNumber"),
          controller: contactNumberController,
          icon: Icons.phone,
          inputFormatters: [PhoneNumberInputFormatter()],
        ),
        SizedBox(height: screenHeight * 0.01),
        ElevatedButton(
          onPressed: () async {
            String userName = userNameController.text.trim();
            String email = emailController.text.trim();
            String password = passwordController.text.trim();

            // Kullanıcı adı doğrulama
            String? userNameError = validateUserName(userName);
            if (userNameError != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(userNameError)),
              );
              return; // Kayıt işlemi durdurulur
            }

            // E-posta doğrulama
            String? emailError = validateEmail(email);
            if (emailError != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(emailError)),
              );
              return; // Kayıt işlemi durdurulur
            }

            // Şifre doğrulama
            String? passwordError = validatePassword(password);
            if (passwordError != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(passwordError)),
              );
              return; // Kayıt işlemi durdurulur
            }

            final user = UserModel(
              id: '',
              username: userName,
              email: email,
              password: password,
              connactNumber: contactNumberController.text.trim(),
            );

            try {
              await authServiceRegister.sendRegisterRequest(user);

              // Kayıt başarılı olduğunda OTP doğrulama ekranına yönlendir
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OtpVerificationScreen(),
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(tr("signUpFailed"))),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(tr("signUp")),
        ),
      ],
    );
  }
}
