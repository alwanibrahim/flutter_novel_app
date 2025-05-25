import 'package:dio/dio.dart';
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

  Future<Map<String, dynamic>?> fetchReadingHistory(int novelId) async {
    try {
      final response =
          await _chapterService.getReadingHistoryByNovelId(novelId);
      if (response.statusCode == 200 && response.data['data'] != null) {
        return response.data['data'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }



   Future<void> postReadingHistory({
    required int id,
    required int chapterNumber,
    required int lastPageRead,
    required double progressPercentage,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _chapterService.postReadingHistory(
        id: id,
        chapterNumber: chapterNumber,
        lastPageRead: lastPageRead,
        progressPercentage: progressPercentage,
      );
    } on DioError catch (e) {
      _error = e.response?.data.toString() ?? e.message;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
   Future<void> editReadingHistory({
    required int id,
    required int chapterNumber,
    required int lastPageRead,
    required double progressPercentage,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _chapterService.editReadingHistory(
        id: id,
        chapterNumber: chapterNumber,
        lastPageRead: lastPageRead,
        progressPercentage: progressPercentage,
      );
    } on DioError catch (e) {
      _error = e.response?.data.toString() ?? e.message;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
