import 'package:flutter/material.dart';
import 'package:flutter_novel_app/data/api/review_service.dart';
import 'package:flutter_novel_app/data/model/novel_model.dart';
import 'package:flutter_novel_app/data/model/review_model.dart';


class ReviewProvider with ChangeNotifier {
  final ReviewService _reviewService = ReviewService();

  List<Review> _reviews = [];
  List<Review> get reviews => _reviews;

  List<ReviewModel> _reviewsUlasan  = [];
  List<ReviewModel> get reviewsUlasan => _reviewsUlasan;

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  String? _error;
  String? get error => _error;

  Future<void> fetchReviews(int novelId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _reviews = await _reviewService.getReviewsByNovelId(novelId);
    } catch (e) {
      print('Error fetchReviews: $e');
      _reviews = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitReview(
      int novelId, String comment, int rating, bool isSpoiler) async {
    try {
      await _reviewService.submitReview(novelId, comment, rating, isSpoiler);
      await fetchReviews(novelId);
    } catch (e) {
      print("Error submitting review: $e");
    }
  }

   Future<void> loadMyReviews() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _reviewsUlasan = await _reviewService.fetchMyReviews();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}
