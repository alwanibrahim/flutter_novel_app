import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_novel_app/data/api/user_service.dart';
import 'package:flutter_novel_app/data/model/novel_model.dart';
import 'package:image_picker/image_picker.dart';


class UserProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  XFile? _pickedImage;

  XFile? get pickedImage => _pickedImage;

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

  Future<void> updateUserWithImage({
    required int id,
    required String name,
    required String username,
    // required String email,
    required String phoneNumber,
    required String bio,
    Uint8List? profileImageBytes, // Ubah ini
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final updatedUser = await UserService().updateUserWithImage(
        id: id,
        name: name,
        username: username,
        // email: email,
        phoneNumber: phoneNumber,
        bio: bio,
        profileImageBytes:
            profileImageBytes, 
      );

      _user = updatedUser;
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


   void setPickedImage(XFile image) {
    _pickedImage = image;
    notifyListeners();
  }
}
