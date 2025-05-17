import 'package:dio/dio.dart';
import 'package:flutter_novel_app/data/api/helper/dio_client.dart';
import 'package:flutter_novel_app/data/model/author_model.dart';

class AuthorService {
  final Dio _dio = DioClient.dio;

  Future<List<AuthorModel>> fetchData() async {
    try {
      final response = await _dio.get('/authors');
      List result =
          response.data['data']; // sesuaikan dengan struktur JSON kamu
      return result.map((item) => AuthorModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Gagal ambil data: $e');
    }
  }
}
