import 'package:hive/hive.dart';

class AppPrefrence {
  static const String _boxName = 'app_preferences';
  static const String _introSeenKey = 'introduction_seen';
  static const String _languageKey = 'language_code';

  static Box get _box => Hive.box(_boxName);

  static bool get hassSeenIntroduction {
    return _box.get(_introSeenKey, defaultValue: false) as bool;
  }

  static Future<void> markIntroductionSeen() async {
    await _box.put(_introSeenKey, true);
  }

  static String get languageCode {
    return _box.get(_languageKey, defaultValue: 'en') as String;
  }

  static Future<void> setLanguageCode(String code) async {
    await _box.put(_languageKey, code);
  }
}
