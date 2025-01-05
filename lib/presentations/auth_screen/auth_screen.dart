
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:literate_app/presentations/auth_screen/components/login_form.dart';
import 'package:literate_app/presentations/auth_screen/components/register_form.dart';
import 'package:literate_app/veriables/global_veraibles.dart';
import 'package:lottie/lottie.dart';

 

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Row(
        children: [
          _SideMenu(
            isLogin: isLogin,
            onMenuTap: (bool loginMode) {
              setState(() {
                isLogin = loginMode;
              });
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Lottie.asset(
                        'assets/lottie/initial_book.json',
                        height: screenHeight * 0.19, 
                        repeat: false,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isLogin ? tr("welcome") : tr("createAcount"),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    isLogin ? LoginForm() : RegisterForm(),
                    const SizedBox(height: 20)
                   
                    
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SideMenu extends StatelessWidget {
  final bool isLogin;
  final Function(bool) onMenuTap;

  const _SideMenu({
    required this.isLogin,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * 0.12,
      color: Theme.of(context).colorScheme.primary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _SideMenuButton(
            title: tr("signIn"),
            isSelected: isLogin,
            onTap: () => onMenuTap(true),
          ),
          SizedBox(height: screenHeight * 0.1),
          _SideMenuButton(
            title: tr("signUp"),
            isSelected: !isLogin,
            onTap: () => onMenuTap(false),
          ),
        ],
      ),
    );
  }
}

class _SideMenuButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _SideMenuButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: RotatedBox(
        quarterTurns: 3,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.white54,
          ),
        ),
      ),
    );
  }
}
