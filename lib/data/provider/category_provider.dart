import 'package:flutter/foundation.dart';
import 'package:flutter_novel_app/data/api/category_service.dart';
import 'package:flutter_novel_app/data/model/category_model.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryService _apiService = CategoryService();

  List<CategoryModel> _dataList = [];
  List<CategoryModel> get dataList => _dataList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> getCategory() async {
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
