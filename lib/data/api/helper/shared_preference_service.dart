import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _tokenKey = 'token';

  /// 🔹 Simpan token
  static Future<void> saveToken(String token) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(_tokenKey, token);
  }

  /// 🔹 Ambil token
  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// 🔹 Hapus token (Logout)
  static Future<void> removeToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
