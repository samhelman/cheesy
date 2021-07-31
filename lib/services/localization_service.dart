import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocalizationService {
  final Locale locale;

  LocalizationService(this.locale);

  static LocalizationService? of(BuildContext context) {
    return Localizations.of<LocalizationService>(context, LocalizationService);
  }

  static List<Locale> supportedLocales = [
    Locale('en'),
    Locale('es', 'ES'),
  ];

  Map<String, dynamic> _localizedStrings = {};

  Future load({required Map<String, dynamic> jsonMap}) async {
    _localizedStrings.addAll(jsonMap);
  }

  String translate(String key) {
    List<dynamic> keys = key.split('.');
    var value = keys.fold(_localizedStrings, (dynamic obj, key) => obj[key]);
    return value == null ? '[no translation]' : value.toString();
  }

  static const LocalizationsDelegate<LocalizationService> delegate =
  _LocalizationDelegate();
}

class _LocalizationDelegate
    extends LocalizationsDelegate<LocalizationService> {
  const _LocalizationDelegate();

  @override
  bool isSupported(Locale locale) => ['en'].contains(locale.languageCode);

  @override
  Future<LocalizationService> load(Locale locale) async {
    LocalizationService localization = LocalizationService(locale);
    String jsonString = await rootBundle
        .loadString('assets/i18n/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    await localization.load(jsonMap: jsonMap);
    return localization;
  }

  @override
  bool shouldReload(_LocalizationDelegate old) => false;
}
