import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:literate_app/global_components/app_bar_default.dart';
import 'package:literate_app/services/profile_service/profile_service.dart';
import 'package:literate_app/services/summary_service/summaryy_service.dart';
import 'package:path_provider/path_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;
  String? _userName;
  String? _email;
  String? _contactNumber;
  List<String>? _title;
  String? _createdAt;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
    _loadSavedProfileImage();
  }

  /// Fetch profile data from the backend and update the state
  Future<void> _fetchProfileData() async {
    try {
      final profileService = ProfileService();
      final summarizeService = CaseService();

      final profileData = await profileService.fetchProfile();
      final CaseTitleData = await summarizeService.fetchCases();

      if (profileData != null) {
        setState(() {
          _email = profileData['email'] ?? 'No Email';
          _userName = profileData['username'] ?? 'Unknown';
          _contactNumber = profileData['connactNumber'] ?? 'No Number';

          // 'data' içindeki 'title' bilgilerini toplama
          final cases = CaseTitleData as List<dynamic>? ?? [];

          _title =
              cases.map((caseItem) => caseItem['title'] as String).toList();

          _createdAt = profileData['createdAt'] != null
              ? DateTime.parse(profileData['createdAt']).toLocal().toString()
              : 'No Date';
        });
      } else {
        print('Profil bilgisi alınamadı.');
        _showSnackBar('Profil bilgisi alınamadı. Lütfen tekrar deneyin.');
      }
    } catch (e) {
      print("Hata oluştu: $e");
      _showSnackBar('Hata oluştu: $e');
    }
  }

  Future<void> _showLogoutDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Oturum Kapatma"),
          content:
              const Text("Oturumunuzu kapatmak istediğinize emin misiniz?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialogu kapat
              },
              child: const Text("Vazgeç"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialogu kapat
                context.go('/'); // Ana ekrana yönlendir
              },
              child: const Text("Evet"),
            ),
          ],
        );
      },
    );
  }

  /// Allow user to pick an image from the gallery
 Future<void> _pickImage() async {
  final picker = ImagePicker();
  try {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final directory = await getApplicationDocumentsDirectory();
      final savedImagePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Resmi cihaz hafızasına kaydetme
      final savedImage = await File(pickedImage.path).copy(savedImagePath);

      setState(() {
        _profileImage = savedImage; // Kaydedilen resmi kullan
      });

      _showSnackBar("Resim başarıyla kaydedildi");
    }
  } catch (e) {
    _showSnackBar("Resim seçme hatası: $e");
  }
}

  /// Fetch saved profile image path during initialization
  Future<void> _loadSavedProfileImage() async {
  final directory = await getApplicationDocumentsDirectory();
  final files = directory.listSync(); // Dizin içindeki tüm dosyaları alır.

  for (var file in files) {
    if (file.path.endsWith('.jpg')) {
      setState(() {
        _profileImage = File(file.path); // Kaydedilen ilk resmi yükle
      });
      break;
    }
  }
}


  /// Show a Snackbar with a given message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Method to delete the profile image
  Future<void> _deleteProfileImage() async {
    try {
      if (_profileImage != null) {
        await _profileImage!.delete(); // Dosyayı sil
        setState(() {
          _profileImage = null; // Resmi sil
        });
        _showSnackBar('Resim başarıyla silindi.');
      } else {
        _showSnackBar('Silinecek resim bulunamadı.');
      }
    } catch (e) {
      _showSnackBar('Resim silinirken hata oluştu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(
        title: tr("profile"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Image Section
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.blue.shade50,
                    child: CircleAvatar(
                      radius: 55,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : const AssetImage(
                                  'assets/images/default_profile.jpg')
                              as ImageProvider,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Silme Butonu
                        if (_profileImage != null)
                          InkWell(
                            onTap: _deleteProfileImage,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        const SizedBox(width: 45),
                        // Kamera Butonu
                        InkWell(
                          onTap: _pickImage, // Image seçmek için tıklama
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Profile Information Section with Cards
              if (_userName != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileCard(
                        title: "Kullanıcı Adı:", value: _userName!),
                    _buildProfileCard(title: "Mail:", value: _email!),
                    _buildProfileCard(
                        title: "İletişim Numarası:", value: _contactNumber!),
                    _buildProfileCard(
                        title: "Hesap oluşturma tarihi:", value: _createdAt!),
                    if (_title != null && _title!.isNotEmpty)
                      _buildProfileCard(
                        title: "Davalar:",
                        value: _title!
                            .asMap() // Listeyi indexler ile birlikte kullanmanızı sağlar.
                            .entries
                            .map((entry) =>
                                "${entry.key + 1}. ${entry.value}") 
                            .join("\n"), // Satırları birleştirir.
                      ),
                  ],
                ),

              const SizedBox(height: 24),

              // Logout Button
              ElevatedButton.icon(
                onPressed: _showLogoutDialog,
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text("Çıkış yap"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Custom method to build profile card for each info section
  Widget _buildProfileCard({required String title, required String value}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
