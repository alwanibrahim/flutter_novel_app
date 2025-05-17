
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

}
