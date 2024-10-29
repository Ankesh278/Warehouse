import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warehouse/Localization/Languages.dart';


class LanguageSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(),
      body: DropdownButton<Locale>(
        value: languageProvider.locale,
        onChanged: (Locale? newLocale) {
          if (newLocale != null) {
            languageProvider.setLocale(newLocale);
          }
        },
        items: LanguageProvider.supportedLocales.map((Locale locale) {
          return DropdownMenuItem(
            value: locale,
            child: Text(locale.languageCode.toUpperCase()),
          );
        }).toList(),
      ),
    );
  }
}
