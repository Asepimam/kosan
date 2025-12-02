import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  late final Map<String, String> _strings;

  AppLocalizations(this.locale);

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    final result = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
    assert(result != null, 'No AppLocalizations found in context');
    return result!;
  }

  Future<bool> load() async {
    final jsonString = await rootBundle.loadString(
      'assets/langs/${locale.languageCode}.json',
    );
    final Map<String, dynamic> map = json.decode(jsonString);
    _strings = map.map((key, value) => MapEntry(key, value.toString()));
    return true;
  }

  String t(String key, {Map<String, String>? params}) {
    var raw = _strings[key] ?? key;
    if (params != null) {
      params.forEach((k, v) {
        raw = raw.replaceAll('{$k}', v);
      });
    }
    return raw;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'id'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
