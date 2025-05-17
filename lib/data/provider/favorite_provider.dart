import 'package:flutter/material.dart';
import 'package:flutter_novel_app/data/api/novel_service.dart';
import 'package:flutter_novel_app/data/model/novel_model.dart';

class FavoriteProvider with ChangeNotifier {
  final NovelService _service = NovelService();

  List<NovelModel> _favorites = [];
  List<NovelModel> get favorites => _favorites;

  NovelModel? _novelDetail;
  NovelModel? get novelDetail => _novelDetail;

  bool _isFavorite = false;
  bool get isFavorite => _isFavorite;

  bool _loading = false;
  bool get loading => _loading;

  Future<void> checkFavorite(int novelId) async {
    _loading = true;
    notifyListeners();

    final result = await _service.checkFavoriteStatus(novelId);
    if (result != null) {
      _isFavorite = result.isFavorite;
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> fetchFavorites() async {
    _loading = true;
    notifyListeners();

    try {
      _favorites = await _service.getFavorites();
    } catch (e) {
      print("Error fetchFavorites: $e");
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> removeFavorite(int novelId) async {
  _loading = true;
  notifyListeners();

  try {
    await _service.removeFavorite(novelId);
    // Hapus dari list lokal supaya UI langsung update
    _favorites.removeWhere((novel) => novel.id == novelId);
  } catch (e) {
    print(e);
  }

  _loading = false;
  notifyListeners();
}
  Future<void> addFavorite(int novelId) async {
  _loading = true;
  notifyListeners();

  try {
    await _service.pushFavorite(novelId);
    // Hapus dari list lokal supaya UI langsung update
    _favorites.removeWhere((novel) => novel.id == novelId);
  } catch (e) {
    print(e);
  }

  _loading = false;
  notifyListeners();
}


// optional: toggle status di UI (kalau kamu pakai toggle juga)
  void toggleFavorite() {
    _isFavorite = !_isFavorite;
    notifyListeners();
  }
}
