import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class I18n {
  final Locale locale;

  I18n(this.locale);

  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static I18n of(BuildContext context) {
    return Localizations.of<I18n>(context, I18n);
  }

  // Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<I18n> delegate = _I18nDelegate();

  Map<String, String> _localizedStrings;

  Future<bool> load() async {
    // Load the language JSON file from the "lang" folder
    String jsonString = await rootBundle.loadString('lib/locales/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  // This method will be called from every widget which needs a localized text
  String t(String key) {
    return _localizedStrings[key];
  }
}

// LocalizationsDelegate is a factory for a set of localized resources
// In this case, the localized strings will be gotten in an I18n object
class _I18nDelegate extends LocalizationsDelegate<I18n> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const _I18nDelegate();

  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    return ['vi', 'en'].contains(locale.languageCode);
  }

  @override
  Future<I18n> load(Locale locale) async {
    // I18n class is where the JSON loading actually runs
    I18n localizations = new I18n(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_I18nDelegate old) => false;
}