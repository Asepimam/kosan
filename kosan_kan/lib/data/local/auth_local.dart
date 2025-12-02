import 'package:hive/hive.dart';

class AuthLocal {
  static const String _boxName = 'auth_local';
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static Box get _box => Hive.box(_boxName);

  Future<void> saveAuthToken(String accessToken, String refreshToken) async {
    await _box.put(_tokenKey, accessToken);
    await _box.put(_refreshTokenKey, refreshToken);
  }

  Future<Map<String, String?>> getAuthToken() async {
    final accessToken = _box.get(_tokenKey) as String?;
    final refreshToken = _box.get(_refreshTokenKey) as String?;
    return {'accessToken': accessToken, 'refreshToken': refreshToken};
  }

  Future<void> clearAuthToken() async {
    await _box.delete(_tokenKey);
    await _box.delete(_refreshTokenKey);
  }
}
