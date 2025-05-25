
import 'package:dio/dio.dart';
import 'package:flutter_novel_app/data/api/helper/dio_client.dart';
import 'package:flutter_novel_app/data/model/novel_model.dart';

class ChapterService {
  final Dio _dio = DioClient.dio;

Future<List<Chapter>> getChaptersByNovelId(int novelId) async {
    try {
      final response = await _dio.get('/novels/$novelId/chapters');

      if (response.statusCode == 200 && response.data['status'] == true) {
        List<dynamic> data = response.data['data'];

        return data.map((json) => Chapter.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load chapters');
      }
    } catch (e) {
      throw Exception('Error fetching chapters: $e');
    }
  }

  Future<Response> getReadingHistoryByNovelId(int novelId) async {
    try {
      final response = await _dio.get('/reading-history/$novelId');
      return response;
    } catch (e) {
      rethrow;
    }
  }


  Future<Response> postReadingHistory({
    required int id,
    required int chapterNumber,
    required int lastPageRead,
    required double progressPercentage,
  }) async {
    final data = {
      "chapter_number": chapterNumber,
      "last_page_read": lastPageRead,
      "progress_percentage": progressPercentage,
    };

    try {
      final response = await _dio.post('/reading-history/$id', data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> editReadingHistory({
    required int id,
    required int chapterNumber,
    required int lastPageRead,
    required double progressPercentage,
  }) async {
    final data = {
      "chapter_number": chapterNumber,
      "last_page_read": lastPageRead,
      "progress_percentage": progressPercentage,
    };

    try {
      final response = await _dio.put('/reading-history/$id', data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

}
