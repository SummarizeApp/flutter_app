import 'package:flutter/material.dart';

class AppBarDefaultHome extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppBarDefaultHome({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Yükseklik

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,  // Koyu yeşil tonları
      elevation: 0, // Gölgeyi kaldırdık
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back, // Geri gel ikonu
          color: Colors.white, // İkonun rengi beyaz
        ),
        onPressed: () {
          // Geri gitme işlevi, örneğin:
          Navigator.pop(context);
        },
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white, // Başlık rengi beyaz
          fontSize: 22,
          fontWeight: FontWeight.w500, // Orta ağırlıkta yazı
          letterSpacing: 1.1, // Harfler arasındaki mesafe
        ),
      ),
    );
  }
}
