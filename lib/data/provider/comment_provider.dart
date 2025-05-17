import 'package:flutter/material.dart';
import 'package:flutter_novel_app/data/api/comment_service.dart';
import 'package:flutter_novel_app/data/model/comment_model.dart';


class CommentProvider with ChangeNotifier {
  final CommentService _service = CommentService();

  bool isLoading = false;
  List<CommentModel> _comments = [];

  List<CommentModel> get comments => _comments;

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
}
