import 'package:flutter/material.dart';
import 'package:flutter_novel_app/data/api/auth_service.dart';
import 'package:flutter_novel_app/data/model/novel_model.dart'; //! ini di cek lagi
import 'package:shared_preferences/shared_preferences.dart';


class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLogin = false;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLogin => _isLogin;

  // 🔹 Constructor untuk memeriksa login saat pertama kali aplikasi dibuka
  AuthProvider() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    print('DEBUG: Token di SharedPreferences -> $token'); // ✅ Debugging

    if (token != null && token.isNotEmpty) {
      _isLogin = true;
    } else {
      _isLogin = false;
    }
    notifyListeners();
  }

  Future<bool> register(String name,String userName, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await ApiAuth().register(name,userName, email, password);
      if (user.token!.isNotEmpty) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Error during registration: $e');
    }
  }

  Future<bool> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    final loginResponse = await ApiAuth().login(email, password,context);

    if (loginResponse != null && loginResponse.token.isNotEmpty) {

      loginSucces();
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("Login gagal: Email belum terverifikasi . Silakan verifikasi."),
        ),
      );
    }

    return false;
  }


  Future<void> updateName(String newName) async {
    final success = await ApiAuth().updateUserName(newName);
    if (success) {
      await fetchUserProfile(); // ambil ulang data user terbaru
    }
  }
  Future<void> logout(BuildContext context) async {
    await ApiAuth().logout();


    Navigator.pushNamedAndRemoveUntil(
      context,
      '/main', // Ganti dengan route login atau register kamu
      (route) => false,
    );

    notifyListeners();
  }

  Future<void> fetchUserProfile() async {
    _user = await ApiAuth().getUser();
    notifyListeners();
  }

  void loginSucces() {
    _isLogin = true;
    notifyListeners();
  }
}
