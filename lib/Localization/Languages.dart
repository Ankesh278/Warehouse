import 'dart:ui';

import 'package:flutter/cupertino.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!supportedLocales.contains(locale)) return;
    _locale = locale;
    notifyListeners();
  }

  // List of supported locales
  static const supportedLocales = [
    Locale('en', ''), // English
    Locale('hi', ''), // Hindi
    Locale('bn', ''), // Bengali
    Locale('kn', ''), // Kannada
    Locale('mr', ''), // Marathi
    Locale('ml', ''), // Malayalam
    Locale('te', ''), // Telugu
    Locale('ta', ''), // Tamil
  ];

  // Mapping of locale codes to their full names
  static const Map<String, String> languageNames = {
    'en': 'English',
    'hi': 'Hindi(हिन्दी)',
    'bn': 'Bengali(বাংলা)',
    'kn': 'Kannada(ಕನ್ನಡ)',
    'mr': 'Marathi(मराठी)',
    'ml': 'Malayalam(മലയാളം)',
    'te': 'Telugu(తెలుగు)',
    'ta': 'Tamil(தமிழ்)',
  };

  // Method to get the full language name
  String getLanguageName(Locale locale) {
    return languageNames[locale.languageCode] ?? locale.languageCode;
  }
}
