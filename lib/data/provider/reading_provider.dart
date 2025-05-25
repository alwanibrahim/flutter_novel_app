import 'package:flutter/material.dart';
import 'package:flutter_novel_app/data/api/novel_service.dart';
import 'package:flutter_novel_app/data/model/reading_model.dart';

class ReadingHistoryProvider extends ChangeNotifier {
  final NovelService _apiService = NovelService();

  List<ReadingModel> _readingHistory = [];
  bool _isLoading = false;
  String? _error;

  List<ReadingModel> get readingHistory => _readingHistory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get totalCompletedNovels {
    return _readingHistory
        .where((history) => history.progressPercentage >= 100)
        .length;
  }

  double get estimatedReadingTimeInHours {
    const double avgHoursPerNovel = 5.0;

    // Ambil semua progress dari reading history
    double totalProgress = _readingHistory.fold(
      0.0,
      (sum, history) => sum + (history.progressPercentage / 100),
    );

    return (totalProgress * avgHoursPerNovel);
  }

  //*ini versi di bulat kan ya ges ya

  int get estimatedReadingTimeRounded {
    return estimatedReadingTimeInHours.floor();
  }

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
   Future<void> removeHistory(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.deleteReadingHistory(id);
      // misalnya kamu punya list history dan ingin menghapusnya dari list juga
      // _historyList.removeWhere((item) => item.id == id);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeAllHistory() async {
    try {
      await NovelService().deleteAllReadingHistory();
      _readingHistory.clear(); // Kosongkan list lokal
      notifyListeners();
    } catch (e) {
      throw Exception('Gagal hapus semua: $e');
    }
  }


}
