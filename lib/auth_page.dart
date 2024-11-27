import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'generated/l10n.dart'; // Intl tarafından oluşturulan S sınıfı
import 'main.dart';
import 'task_management_screen.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Locale _locale = const Locale('en'); // Varsayılan dil İngilizce

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF42A5F5),
              Color(0xFF7E57C2)
            ], // Daha canlı mavi ve mor tonlar
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Scaffold(
          // AppBar Başlık Modernleştirme
          appBar: AppBar(
            title: Text(
              S.of(context).appTitle,
              style: TextStyle(
                fontSize: 26, // Daha büyük font
                fontWeight: FontWeight.bold, // Kalın yazı
                foreground: Paint() // Renk geçişi
                  ..shader = const LinearGradient(
                    colors: <Color>[Color(0xFF42A5F5), Color(0xFF7E57C2)],
                  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
              ),
            ),
            actions: [
              DropdownButtonHideUnderline(
                child: DropdownButton<Locale>(
                  value: _locale,
                  items: S.delegate.supportedLocales.map((locale) {
                    return DropdownMenuItem(
                      value: locale,
                      child: Row(
                        children: [
                          // Bayrak ikonları için Flag paketi kullanıldı
                          Flag.fromString(
                            locale.languageCode == 'en'
                                ? 'US'
                                : 'FI', // Ülke kodları
                            height: 20,
                            width: 30,
                          ),
                          const SizedBox(width: 10),
                          // Dil kodu metni
                          Text(
                            locale.languageCode.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  dropdownColor: Colors.white,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  onChanged: (locale) {
                    setState(() {
                      _locale = locale!;
                      // Uygulama genelinde dili değiştirme
                      MyApp.setLocale(context, _locale);
                    });
                  },
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Kullanıcıdan e-posta girmesini istiyoruz
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon:
                        const Icon(Icons.email, color: Colors.blueAccent),
                    hintText: S.of(context).enterEmail,
                    hintStyle: const TextStyle(color: Colors.grey),
                    labelText: S.of(context).enterEmail,
                  ),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                // Kullanıcıdan şifre girmesini istiyoruz
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon:
                        const Icon(Icons.lock, color: Colors.blueAccent),
                    hintText: S.of(context).password,
                    hintStyle: const TextStyle(color: Colors.grey),
                    labelText: S.of(context).password,
                  ),
                  controller: _passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                // Kullanıcı kaydı için buton
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E), // Buton rengi
                    foregroundColor: Colors.white, // Yazı rengi
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: _registerUser,
                  child: Text(S.of(context).register),
                ),
                const SizedBox(height: 5),
                // Kullanıcı giriş işlemi için buton
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E), // Buton rengi
                    foregroundColor: Colors.white, // Yazı rengi
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: _signInUser,
                  child: Text(S.of(context).signIn),
                ),
                const SizedBox(height: 20),
                // Şifre sıfırlama işlemi için buton
                TextButton(
                  onPressed: _resetPassword,
                  child: Text(S.of(context).forgotPassword),
                  style: TextButton.styleFrom(
                    foregroundColor:
                        const Color(0xFF7E57C2), // Belirgin mor renk
                    textStyle: const TextStyle(
                      fontSize: 14, // Daha küçük font
                      decoration: TextDecoration.underline, // Altı çizili
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getFlag(String code) {
    switch (code) {
      case 'fi':
        return '🇫🇮';
      case 'en':
      default:
        return '🇺🇸';
    }
  }

// Kullanıcı giriş fonksiyonu
  Future<void> _signInUser() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Giriş öncesi kontrol
    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog(S.of(context).fieldsCannotBeEmpty);
      return;
    }
    if (!_isValidEmail(email)) {
      _showErrorDialog(S.of(context).invalidEmailFormat);
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).signInSuccessful)),
      );
      _navigateToTaskManagementScreen(); // Kullanıcı giriş yaparsa görev yönetimi ekranına geçiş yapıyoruz
    } catch (e) {
      // Firebase hata kodlarına göre hata mesajı
      String errorMessage = _getFirebaseErrorMessage(e);
      _showErrorDialog(errorMessage);
    }
  }

  // Firebase hatalarını çözümleyen fonksiyon
  String _getFirebaseErrorMessage(dynamic error) {
    switch (error.code) {
      case 'user-not-found':
        return S.of(context).userNotFound; // Kullanıcı bulunamadı
      case 'wrong-password':
        return S.of(context).wrongPassword; // Yanlış şifre
      case 'invalid-email':
        return S.of(context).invalidEmailFormat; // Geçersiz e-posta formatı
      case 'user-disabled':
        return S.of(context).userDisabled; // Hesap devre dışı
      default:
        return "${S.of(context).error}: ${error.message}"; // Diğer hatalar
    }
  }

// Email formatı kontrol fonksiyonu
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegex.hasMatch(email);
  }

// Hata mesajı için diyalog kutusu
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(S.of(context).error),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text(S.of(context).ok),
          ),
        ],
      ),
    );
  }

// Kullanıcı kaydı fonksiyonu
  Future<void> _registerUser() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Kayıt öncesi kontrol
    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog(S.of(context).fieldsCannotBeEmpty);
      return;
    }
    if (!_isValidEmail(email)) {
      _showErrorDialog(S.of(context).invalidEmailFormat);
      return;
    }
    if (password.length < 6) {
      _showErrorDialog(
          S.of(context).passwordTooShort); // Şifre uzunluk kontrolü
      return;
    }

    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).registrationSuccessful)),
      );
      _navigateToTaskManagementScreen(); // Başarılı kayıt sonrası görev ekranına geçiş
    } catch (e) {
      _showErrorDialog("${S.of(context).error}: ${e.toString()}");
    }
  }

  // Şifre sıfırlama fonksiyonu
  Future<void> _resetPassword() async {
    if (_emailController.text.trim().isNotEmpty) {
      try {
        await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).passwordResetEmailSent)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${S.of(context).error}: ${e.toString()}")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).enterYourEmailToResetPassword)),
      );
    }
  }

  // Görev yönetimi ekranına yönlendirme fonksiyonu
  void _navigateToTaskManagementScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) =>
            TaskManagementScreen(locale: Localizations.localeOf(context)),
      ),
    );
  }
}
