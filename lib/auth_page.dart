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
      appBar: AppBar(
        title: Text(S.of(context).appTitle),
        actions: [
          DropdownButton<Locale>(
            value: _locale,
            items: S.delegate.supportedLocales.map((locale) {
              final flag = _getFlag(locale.languageCode);
              return DropdownMenuItem(
                value: locale,
                child: Center(
                  child: Text(
                    flag,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              );
            }).toList(),
            onChanged: (locale) {
              setState(() {
                _locale = locale!;
                // Uygulama genelinde dili değiştirme
                MyApp.setLocale(context, _locale);
              });
            },
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
              controller: _emailController,
              decoration: InputDecoration(
                labelText: S.of(context).enterEmail,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            // Kullanıcıdan şifre girmesini istiyoruz
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: S.of(context).password,
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            // Kullanıcı kaydı için buton
            ElevatedButton(
              onPressed: _registerUser,
              child: Text(S.of(context).register),
            ),
            const SizedBox(height: 5),
            // Kullanıcı giriş işlemi için buton
            ElevatedButton(
              onPressed: _signInUser,
              child: Text(S.of(context).signIn),
            ),
            const SizedBox(height: 20),
            // Şifre sıfırlama işlemi için buton
            TextButton(
              onPressed: _resetPassword,
              child: Text(S.of(context).forgotPassword),
            ),
          ],
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

  // Kullanıcı kaydı fonksiyonu
  Future<void> _registerUser() async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).registrationSuccessful)),
      );
      _navigateToTaskManagementScreen(); // Kullanıcı kaydı başarılıysa görev yönetimi ekranına geçiş yapıyoruz
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${S.of(context).error}: ${e.toString()}")),
      );
    }
  }

  // Kullanıcı giriş fonksiyonu
  Future<void> _signInUser() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).signInSuccessful)),
      );
      _navigateToTaskManagementScreen(); // Kullanıcı giriş yaparsa görev yönetimi ekranına geçiş yapıyoruz
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${S.of(context).error}: ${e.toString()}")),
      );
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
