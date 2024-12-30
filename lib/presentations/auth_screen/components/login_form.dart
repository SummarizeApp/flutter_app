
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:literate_app/presentations/auth_screen/components/utils/input_custom_widget.dart';
import 'package:literate_app/services/auth_service/login_service.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginForm({super.key});

  // Login işlemi yapan fonksiyon
  void handleLogin(BuildContext context, String email, String password) async {
    // E-posta ve şifreyi kontrol et
    print("Email: $email");
    print("Password: $password");

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog(context, "E-posta ve şifre boş olamaz!");
      return;
    }

    final AuthServiceLogin authService = AuthServiceLogin();
    try {
      // Giriş isteğini gönder
      bool success = await authService.login(email, password);

      if (success) {
        context.go('/navigator');
      } else {
        print("Login failed. Please check your credentials.");
        _showErrorDialog(context, "Giriş başarısız! Lütfen bilgilerinizi kontrol edin.");
      }
    } catch (e) {
      _showErrorDialog(context, "Bir hata oluştu: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputCustomWidget(
          text: tr("email"),
          controller: emailController,
          icon: Icons.email,
        ),
        const SizedBox(height: 20),
        InputCustomWidget(
          text: tr("password"),
          controller: passwordController,
          icon: Icons.lock,
          obscureText: true,
        ),
        const SizedBox(height: 10),
        
        // Şifremi unuttum linki
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () {
              // Şifremi unuttum işlemi
              print('Şifremi unuttum tıklandı');
            },
            child: Text(
              "Şifremi Unuttum",
              style: TextStyle(
                color: Colors.white,  // Beyaz renk
                fontSize: 14,
              ),
            ),
          ),
        ),
        
        ElevatedButton(
          onPressed: () {
            handleLogin(
              context,
              emailController.text,
              passwordController.text,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(tr("signIn")),
        ),
        
        // Divider
        const SizedBox(height: 20),
        Divider(
          color: Colors.white,
          thickness: 1,
        ),
        
        // Sosyal medya ile giriş ikonları
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(FontAwesomeIcons.google, color: Colors.white),
              onPressed: () {
                print('Google ile giriş yapılacak');
              },
            ),
            const SizedBox(width: 20),
            IconButton(
              icon: Icon(FontAwesomeIcons.facebook, color: Colors.white),
              onPressed: () {
                print('Facebook ile giriş yapılacak');
              },
            ),
            const SizedBox(width: 20),
            IconButton(
              icon: Icon(FontAwesomeIcons.instagram, color: Colors.white),
              onPressed: () {
                print('Instagram ile giriş yapılacak');
              },
            ),
          ],
        ),
      ],
    );
  }

  // Hata mesajını gösteren fonksiyon
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
