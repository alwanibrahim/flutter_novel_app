import 'package:flutter/foundation.dart';
import 'package:flutter_novel_app/data/api/novel_service.dart';
import 'package:flutter_novel_app/data/model/novel_model.dart';

class NovelProvider with ChangeNotifier {
  final NovelService _apiService = NovelService();

  List<NovelModel> _dataList = [];
  List<NovelModel> get dataList => _dataList;

  List<NovelModel> _dataListfeatured = [];
  List<NovelModel> get dataListfeature => _dataListfeatured;

  NovelModel? _novelDetail;
  NovelModel? get novelDetail => _novelDetail;

  List<NovelModel> _searchResults = [];
  List<NovelModel> get searchResults => _searchResults;

  bool _isFetched = false;
  bool get isFetched => _isFetched;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  final List<int> _favoriteNovelIds = [];

  List<int> get favoriteNovelIds => _favoriteNovelIds;

   List<NovelModel> get latestNovels {
    List<NovelModel> sorted = [..._dataList];
    sorted
        .sort((a, b) => b.createdAt.compareTo(a.createdAt)); // terbaru di atas
    return sorted;
  }

  Future<void> getNovel() async {
    if (_isFetched) return;
    _isFetched = true;
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
  Future<void> getNovelFeatured() async {
    if (_isFetched) return;
    _isFetched = true;
    _isLoading = true;
    notifyListeners();

    try {
      _dataList = await _apiService.getFeaturedNovels();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

   Future<List<NovelModel>> getFetchedNovels() async {
    await getNovel(); // Panggil getNovel() untuk pastikan data sudah di-fetch
    return _dataList; // Kembalikan data yang sudah di-fetch
  }

  Future<void> getNovelDetail(int id) async {
    _novelDetail = null;
    _isLoading = true;
    //  if (_isFetched) return;
    // _isFetched = true;
    notifyListeners();

    try {
      _novelDetail = await _apiService.fetchNovelById(id);
      _error = null;
    } catch (e) {
      _error = 'Gagal mengambil data';
    }

    _isLoading = false;
    notifyListeners();
  }
  //* ini adalah fitur search
    void searchNovels(String query) {
    final lowerQuery = query.toLowerCase();

    _searchResults = _dataList.where((novel) {
      final titleMatch = novel.title.toLowerCase().contains(lowerQuery);
      final authorMatch = novel.author.name.toLowerCase().contains(lowerQuery);
      final categoryMatch = novel.category.name.toLowerCase().contains(lowerQuery);

      return titleMatch || authorMatch || categoryMatch;
    }).toList();

    notifyListeners();
  }


   Future<void> toggleFavorite({
    required int novelId,
    required bool isCurrentlyFavorite,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (isCurrentlyFavorite) {
        await _apiService.removeFavorite(novelId);
        _favoriteNovelIds.remove(novelId);
      } else {
        await _apiService.pushFavorite(novelId);
        _favoriteNovelIds.add(novelId);
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }





  // providers/novel_provider.dart


  void clearSearch() {
    _searchResults = [];
    notifyListeners();
  }

   void resetDetail() {
    _novelDetail = null;
    _isFetched = false;
    notifyListeners();
  }
}
