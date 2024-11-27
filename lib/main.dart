import 'package:firebase_core/firebase_core.dart'; // Firebase’i Flutter uygulamasıyla entegre etmek için gerekli temel pakettir. Firebase özelliklerini (Authentication, Firestore, vb.) kullanmak için bu paketi başlatmalıyız.
import 'package:flutter/material.dart'; // Flutter'ın temel UI bileşenlerini sağlar (örn. Scaffold, AppBar, Text gibi).
import 'package:flutter_localizations/flutter_localizations.dart'; // Uygulamada çoklu dil desteği (lokalizasyon) eklemek için kullanılır.
import 'generated/l10n.dart'; //  intl paketi kullanılarak oluşturulmuş, uygulamanın farklı dillerde çalışmasını sağlayan sınıf (S sınıfı).
import 'auth_page.dart'; // Kullanıcı giriş/çıkış sayfasını oluşturduğum bir dosyaya referans.
import 'config/firebase_options.dart'; // Firebase ayarlarını içeren dosyaya referans.
import 'config/theme.dart'; // Uygulamanın temasını içeren dosyaya referans.

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Flutter, asenkron işlemleri düzgün bir şekilde başlatmadan önce gerekli bağlamı oluşturur. Firebase başlatılmadan önce çağrılması gerekir.
  // Firebase'i başlatıyoruz.
  await Firebase.initializeApp(options: firebaseOptions);
  runApp(
      MyApp()); // Flutter uygulamasını başlatır ve kök widget olarak MyApp sınıfını tanımlar.
}

class MyApp extends StatefulWidget {
  // Uygulamanın dinamik bir özelliği olduğu için StatefulWidget kullanıldi.
  static void setLocale(BuildContext context, Locale newLocale) {
    // Açıklamalar01:
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(
        newLocale); // _MyAppState sınıfına gider ve dil değişikliği (Locale) bilgisini gönderir.
  }

  @override
  _MyAppState createState() =>
      _MyAppState(); // MyApp widget’inin durumunu yöneten sınıf. Örneğin, burada dil seçimi kaydedilir.
}

class _MyAppState extends State<MyApp> {
  Locale?
      _locale; // Uygulamanın mevcut dilini tutan değişken. Eğer bu değişken null ise, varsayılan dil kullanılır.

  void setLocale(Locale locale) {
    // Dil değiştirme işlemini sağlar ve arayüzü günceller.
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale, // locale: Hangi dilin kullanılacağını belirler.

      title: // title: Uygulama başlığı (bazı durumlarda gösterilir).
          'ToDo App', // Bu noktada S.of(context) kullanmak hataya neden olabilir

      debugShowCheckedModeBanner:
          false, // Debug modundayken sağ üstteki “DEBUG” yazısını gizler.

      theme: appTheme, // Uygulamanın teması (light theme)
      darkTheme: darkTheme, // Uygulamanın karanlık teması (dark theme)

      supportedLocales: S.delegate
          .supportedLocales, // supportedLocales: Uygulamanın desteklediği diller. Bu, S.delegate.supportedLocales kullanılarak alınır.

      localizationsDelegates: const [
        // localizationsDelegates: Lokalizasyon için kullanılan kaynaklar.
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      home: AuthPage(), // home: Uygulamanın açılış sayfası (AuthPage).
    );
  }
}
