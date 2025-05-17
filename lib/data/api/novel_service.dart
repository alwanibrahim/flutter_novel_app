import 'package:dio/dio.dart';
import 'package:flutter_novel_app/data/api/helper/dio_client.dart';
import 'package:flutter_novel_app/data/model/novel_model.dart';
import 'package:flutter_novel_app/data/model/reading_model.dart';
import 'package:flutter_novel_app/data/model/saved_model.dart';
import 'package:hive/hive.dart';

class NovelService {
  final Dio _dio = DioClient.dio;

  Future<List<NovelModel>> fetchData() async {
    try {
      final response = await _dio.get('/novels');

      print("Status Code: ${response.statusCode}");
      print("Full Response: ${response.data}");

      List result =
          response.data['data']['data']; // sesuaikan dengan struktur JSON kamu
      return result
          .map((item) {
            try {
              return NovelModel.fromJson(item);
            } catch (e) {
              print("Error parsing item: $item\nError: $e");
              return null; // atau bisa di-skip saja
            }
          })
          .whereType<NovelModel>()
          .toList();
    } catch (e, stackTrace) {
      print("Error occurred: $e");
      print("Stack trace: $stackTrace");
      throw Exception('Gagal ambil data: $e');
    }
  }

  Future<NovelModel> fetchNovelById(int id) async {
    try {
      final response = await _dio.get('/novels/$id');
      print(response.data);

      if (response.statusCode == 200 && response.data['status'] == true) {
        return NovelModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to load novel');
      }
    } catch (e) {
      throw Exception('Error fetching novel: $e');
    }
  }

  Future<List<NovelModel>> searchNovels(String query) async {
    final response = await _dio.get('/novels/search', queryParameters: {
      'query': query,
    });
    return (response.data as List).map((e) => NovelModel.fromJson(e)).toList();
  }

  Future<List<NovelModel>> fetchNovelsByCategory(int categoryId) async {
    final response = await _dio.get('/novels/category/$categoryId');

    final jsonData = response.data;
    final novelListJson = jsonData['data'];

    if (novelListJson == null || novelListJson is! List) {
      // Bisa juga logging error kalau perlu
      return []; // Kembalikan list kosong jika tidak valid
    }

    return (novelListJson as List).map((e) => NovelModel.fromJson(e)).toList();
  }

  Future<List<SavedNovel>> fetchNovelsByIdsFromHive() async {
    try {
      final favoriteBox = Hive.box('favoriteBox');

      final storedIds = favoriteBox.get('novels')?.cast<int>() ?? [];

      if (storedIds.isEmpty) return [];

      final response = await _dio.post(
        '/novels/by-ids',
        data: {'ids': storedIds},
      );

      print('${response.data}');

      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((json) => SavedNovel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load novels');
      }
    } catch (e) {
      throw Exception('Error fetching novels: $e');
    }
  }

   Future<void> pushFavorite(int novelId) async {
    try {
       await _dio.post('/novels/$novelId/favorite');

    } catch (e) {
      throw Exception('Gagal menyimpan favorite: $e');
    }
  }

  Future<void> removeFavorite(int novelId) async {
    try {
      await _dio.delete('/novels/$novelId/favorite');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Favorit tidak ditemukan di server.');
      }
      throw Exception('Gagal menghapus favorite: $e');
    }
  }

   Future<FavoriteStatus?> checkFavoriteStatus(int novelId) async {
    try {
      final response =
          await _dio.get('/novels/$novelId/favorite/check');
      if (response.statusCode == 200 && response.data['status'] == true) {
        return FavoriteStatus.fromJson(response.data['data']);
      } else {
        return null;
      }
    } catch (e) {
      print('Error checking favorite status: $e');
      return null;
    }
  }

  Future<List<NovelModel>> getFavorites() async {
    final response = await _dio.get('/favorites');

    if (response.statusCode == 200 && response.data['status'] == true) {
     List data = response.data['data'];
      return data
          .map((json) => NovelModel.fromJson(json['novel']))
          .toList();

    } else {
      throw Exception('Gagal mengambil data favorite');
    }
  }

   Future<List<ReadingModel>> getReadingHistory() async {
    try {
      final response = await _dio.get('/reading-history');
      final List data = response.data['data'];
      return data.map((json) => ReadingModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch reading history: $e');
    }
  }
}
