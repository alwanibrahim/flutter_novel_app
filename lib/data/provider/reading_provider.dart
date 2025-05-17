import 'package:flutter/material.dart';
import 'package:flutter_novel_app/data/api/novel_service.dart';
import 'package:flutter_novel_app/data/model/reading_model.dart';


class ReadingHistoryProvider extends ChangeNotifier {
  final NovelService _apiService =
      NovelService(); // pastikan ada instance Dio di sini

  List<ReadingModel> _readingHistory = [];
  bool _isLoading = false;
  String? _error;

  List<ReadingModel> get readingHistory => _readingHistory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchReadingHistory() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _readingHistory = await _apiService.getReadingHistory();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
