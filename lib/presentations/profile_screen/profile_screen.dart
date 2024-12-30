import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:literate_app/global_components/app_bar_default.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;

  /// Kullanıcıdan galeriye erişim izni isteyip, resim seçimini yöneten metod.
  Future<void> _pickImage() async {
    // Galeriye erişim izni kontrolü
    final permission = Platform.isAndroid
        ? Permission.manageExternalStorage
        : Permission.photos;

    if (await permission.isDenied || await permission.isRestricted) {
      final status = await permission.request();
      if (!status.isGranted) {
        _showSettingsDialog();
        return;
      }
    }

    // İzin verildiyse, ImagePicker ile galeri aç
    if (await permission.isGranted) {
      final picker = ImagePicker();
      try {
        final pickedImage = await picker.pickImage(source: ImageSource.gallery);

        if (pickedImage != null) {
          setState(() {
            _profileImage = File(pickedImage.path);
          });
        }
      } catch (e) {
        _showSnackBar("Resim seçme sırasında bir hata oluştu: $e");
      }
    } else {
      _showSnackBar("Galeri erişimi reddedildi.");
    }
  }

  /// İzin verilmediğinde ayarlara yönlendiren bir diyalog gösterir.
  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Gerekli İzinler"),
        content: const Text(
          "Galeriye erişim için izin vermeniz gerekiyor. Ayarlar sayfasından izin verebilirsiniz.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Vazgeç"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text("Ayarları Aç"),
          ),
        ],
      ),
    );
  }

  /// Kullanıcıya Snackbar mesajı gösterir.
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(
        title:  ("Profile"),
     
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.deepPurple, Colors.deepPurpleAccent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  child: InkWell(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 45,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : const AssetImage('assets/images/default_profile.jpg')
                                as ImageProvider,
                        child: const Align(
                          alignment: Alignment.bottomRight,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            const Text(
              "John Doe",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              "johndoe@example.com",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildProfileOption(Icons.person, "Edit Profile", () {
                    // Edit Profile işlemleri
                  }),
                  _buildProfileOption(Icons.notifications, "Notifications", () {
                    // Notifications işlemleri
                  }),
                  _buildProfileOption(Icons.settings, "Settings", () {
                    // Settings işlemleri
                  }),
                  _buildProfileOption(Icons.help, "Help & Support", () {
                    // Help işlemleri
                  }),
                  const Divider(),
                  _buildProfileOption(Icons.logout, "Logout", () {
                    // Logout işlemleri
                  }, color: Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Profil seçenekleri için tek tip widget oluşturan metod.
  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap,
      {Color color = Colors.black}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
