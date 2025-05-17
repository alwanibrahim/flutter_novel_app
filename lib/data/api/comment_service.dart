import 'package:dio/dio.dart';
import 'package:flutter_novel_app/data/api/helper/dio_client.dart';
import 'package:flutter_novel_app/data/model/comment_model.dart';

class CommentService {
  final Dio _dio = DioClient.dio;

  Future<List<CommentModel>> fetchComments(int reviewId) async {
    final response = await _dio.get('/reviews/$reviewId/comments');
    final data = response.data['data'] as List;
    return data.map((json) => CommentModel.fromJson(json)).toList();
  }

   Future<void> postComment({
    required int reviewId,
    required String content,
  }) async {
    try {
      await _dio.post('/reviews/$reviewId/comments', data: {
        'content': content,
      });
    } catch (e) {
      throw Exception('Gagal mengirim komentar: $e');
    }
  }
}
