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

  Future<void> deleteComment(int reviewId,int commentId) async {
    try {
      await _dio.delete('/reviews/$reviewId/comments/$commentId');
    } catch (e) {
      throw Exception('Gagal menghapus komentar: $e');
    }
  }

  Future<void> likeComment(int reviewId, int commentId) async {
    try {
      final response = await _dio.post(
        '/reviews/$reviewId/comments/$commentId/like',
      );

      if (response.statusCode != 200) {
        throw Exception('Gagal like komentar');
      }
    } catch (e) {
      throw Exception('Gagal like komentar: $e');
    }
  }


}
