import 'package:flutter/material.dart';

/// Uygulamanın ana teması
final ThemeData appTheme = ThemeData(
  primarySwatch: Colors.blue, // Ana renk paleti
  visualDensity: VisualDensity.adaptivePlatformDensity, // Görsel yoğunluk
);

/// Karanlık tema (opsiyonel) cihazın sistem ayarlarından "Dark Mode" etkinleştirerek test edebilirsin.
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark, // Karanlık tema
  primarySwatch: Colors.blue,
);
