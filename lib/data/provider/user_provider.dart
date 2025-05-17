import 'package:flutter/material.dart';
import 'package:flutter_novel_app/data/api/user_service.dart';
import 'package:flutter_novel_app/data/model/novel_model.dart';


class UserProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchUser() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fetchedUser = await UserService().getUser();
      _user = fetchedUser;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
