import 'package:flutter/material.dart';
import 'package:flutter_novel_app/data/api/comment_service.dart';
import 'package:flutter_novel_app/data/model/comment_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CommentProvider with ChangeNotifier {
  final CommentService _service = CommentService();

  bool isLoading = false;
  List<CommentModel> _comments = [];
   CommentModel? _detail;

  List<CommentModel> get comments => _comments;
  CommentModel? get detail => _detail;

  
  Future<void> loadComments(int reviewId) async {
    isLoading = true;
    notifyListeners();

    try {
      _comments = await _service.fetchComments(reviewId);
    } catch (e) {
      _comments = [];
    }

    isLoading = false;
    notifyListeners();
  }

    Future<void> addComment(int reviewId, String content) async {
    isLoading = true;
    notifyListeners();
    try {
      await _service.postComment(reviewId: reviewId, content: content);
      await loadComments(reviewId);
    } catch (e) {
      print('Error addComment: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<int?> getCurrentUserId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('user_id');
}


   Future<void> deleteComment(int commentId, int reviewId) async {
    await _service.deleteComment(reviewId,commentId);
    await loadComments(reviewId);
  }
  Future<void> likeComment(int reviewId, int commentId) async {
    await _service.likeComment(reviewId, commentId);
    await loadComments(reviewId);
  }

}
