import 'package:flutter/foundation.dart';
import 'package:flutter_novel_app/data/api/author_service.dart';
import 'package:flutter_novel_app/data/model/author_model.dart';

class AuthorProvider with ChangeNotifier {
  final AuthorService _apiService = AuthorService();

  List<AuthorModel> _dataList = [];
  List<AuthorModel> get dataList => _dataList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> getNovel() async {
    _isLoading = true;
    notifyListeners();

    try {
      _dataList = await _apiService.fetchData();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
