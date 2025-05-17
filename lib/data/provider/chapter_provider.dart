import 'package:flutter/material.dart';
import 'package:flutter_novel_app/data/api/chapter_service.dart';
import 'package:flutter_novel_app/data/model/novel_model.dart';

class ChapterProvider with ChangeNotifier {
  final ChapterService _chapterService = ChapterService();
  List<Chapter> _chapters = [];
  bool _isLoading = false;
  String? _error;

  bool _isFetched = false;
  bool get isFetched =>  _isFetched;

  List<Chapter> get chapters => _chapters;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get totalChapter => _chapters.length;

  Future<void> fetchChapters(int novelId) async {
    if (_isFetched) return; // Hanya fetch sekali

    _isFetched = true;
    _isLoading = true;
    notifyListeners();

    try {
      _chapters = await _chapterService.getChaptersByNovelId(novelId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
