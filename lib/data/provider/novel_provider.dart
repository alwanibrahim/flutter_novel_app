import 'package:flutter/foundation.dart';
import 'package:flutter_novel_app/data/api/novel_service.dart';
import 'package:flutter_novel_app/data/model/novel_model.dart';

class NovelProvider with ChangeNotifier {
  final NovelService _apiService = NovelService();

  List<NovelModel> _dataList = [];
  List<NovelModel> get dataList => _dataList;

  NovelModel? _novelDetail;
  NovelModel? get novelDetail => _novelDetail;


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
