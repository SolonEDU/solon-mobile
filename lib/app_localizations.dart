import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = 
    _AppLocalizationsDelegate();

  Map<String, String> _localizedStrings;

  Future<bool> load() async {
    String jsonString =
        await rootBundle.loadString('lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map(
      (key, value) {
        return MapEntry(key, value.toString());
      },
    );

    return true;
  }

  String translate(String key) {
    return _localizedStrings[key];
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return [
      'af',
      'sq',
      'ar',
      'az',
      'eu',
      'bn',
      'be',
      'bg',
      'ca',
      'chr',
      'zh',
      'hr',
      'cs',
      'da',
      'nl',
      'en',
      'eo',
      'et',
      'tl',
      'fi',
      'fr',
      'gl',
      'ka',
      'de',
      'el',
      'gu',
      'ht',
      'iw',
      'hi',
      'hu',
      'is',
      'id',
      'ga',
      'it',
      'ja',
      'kn',
      'ko',
      'la',
      'lv',
      'lt',
      'mk',
      'ms',
      'mt',
      'no',
      'fa',
      'pl',
      'pt',
      'ro',
      'ru',
      'sr',
      'sk',
      'sl',
      'es',
      'sw',
      'sv',
      'ta',
      'te',
      'th',
      'tr',
      'uk',
      'ur',
      'vi',
      'cy',
      'yi',
    ].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = new AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
