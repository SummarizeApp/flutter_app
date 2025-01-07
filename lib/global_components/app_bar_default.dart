import 'package:flutter/material.dart';

class AppBarDefault extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppBarDefault({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Yükseklik

  @override
  Widget build(BuildContext context) {
    return AppBar(
    backgroundColor: Theme.of(context).colorScheme.primary, // MediumAquaMarine Koyu yeşil tonları
      elevation: 0, // Gölgeyi kaldırdık
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white, // Başlık rengi beyaz
          fontSize: 22,
          fontWeight: FontWeight.w500, // Orta ağırlıkta yazı
          letterSpacing: 1.1, // Harfler arasındaki mesafe
        ),
      ),
       centerTitle: true,
    );
  }
}
