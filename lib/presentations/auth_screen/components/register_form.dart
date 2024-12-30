
// import 'package:dictionary_app/services/auth_service_register.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:literate_app/models/user_modal.dart';
import 'package:literate_app/presentations/auth_screen/components/utils/input_custom_widget.dart';
import 'package:literate_app/services/auth_service/register_service.dart';

class SignUpForm extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final AuthServiceRegister authServiceRegister = AuthServiceRegister();

  SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputCustomWidget(
          text: tr("userName"),
          controller: userNameController,
          icon: Icons.person,
        ),
        const SizedBox(height: 20),
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
        const SizedBox(height: 20),
        InputCustomWidget(
          text: tr("contactNumber"),
          controller: contactNumberController,
          icon: Icons.phone,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            // Kullanıcıdan alınan bilgilerle UserModel oluştur
            final user = UserModel(
              id: '', // ID backend tarafından oluşturulacağı için boş bırakıyoruz
              username: userNameController.text.trim(),
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
              connactNumber: contactNumberController.text.trim(),
            );

            // AuthServiceRegister kullanarak kayıt işlemini gerçekleştir
            try {
              await authServiceRegister.sendRegisterRequest(user);
              // Kayıt başarılı olduğunda mesaj göster
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(tr("signUpSuccess"))),
              );
            } catch (e) {
              // Kayıt sırasında hata olduğunda mesaj göster
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
