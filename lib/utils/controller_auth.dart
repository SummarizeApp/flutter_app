import 'package:easy_localization/easy_localization.dart';


// Kullanıcı adı kontrolü
String? validateUserName(String userName) {
  if (userName.isEmpty) {
    return tr("userNameEmpty");
  } else if (userName.length < 3) {
    return tr("userNameTooShort");
  }
  return null;
}

// E-posta kontrolü
String? validateEmail(String email) {
  if (email.isEmpty) {
    return tr("emailEmpty");
  }
  String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  RegExp regex = RegExp(emailPattern);
  if (!regex.hasMatch(email)) {
    return tr("invalidEmail");
  }
  return null;
}

// Şifre kontrolü
String? validatePassword(String password) {
  if (password.isEmpty) {
    return tr("passwordEmpty");
  } else if (password.length < 6) {
    return tr("passwordTooShort");
  }
  return null;
}
