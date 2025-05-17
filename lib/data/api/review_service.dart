import 'package:dio/dio.dart';
import 'package:flutter_novel_app/data/api/helper/dio_client.dart';
import 'package:flutter_novel_app/data/model/novel_model.dart';
import 'package:flutter_novel_app/data/model/review_model.dart';

class ReviewService {
  final Dio _dio = DioClient.dio;


  Future<List<Review>> getReviewsByNovelId(int novelId) async {
    try {
      final response = await _dio.get('/novels/$novelId/reviews');
      List<dynamic> data =
          response.data['data']; // atau sesuaikan dengan struktur response kamu

      return data.map((item) => Review.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Gagal mengambil data review: $e');
    }
  }

  Future<void> submitReview(
      int novelId, String comment, int rating, bool isSpoiler) async {
    await _dio.post('/novels/$novelId/reviews', data: {
      'comment': comment,
      'rating': rating,
      'is_spoiler': isSpoiler,
    });
  }

   Future<List<ReviewModel>> fetchMyReviews() async {
    try {
      final response = await _dio.get('/my-review');

      if (response.statusCode == 200 && response.data['status'] == true) {
        List<dynamic> reviewsJson = response.data['data'];
        return reviewsJson.map((json) => ReviewModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load reviews');
      }
    } catch (e) {
      throw Exception('Error fetching my reviews: $e');
    }
  }

}
