import 'package:dio/dio.dart';
import 'package:flutter_novel_app/data/api/helper/dio_client.dart';
import 'package:flutter_novel_app/data/model/category_model.dart';

class CategoryService {
  final Dio _dio = DioClient.dio;

  Future<List<CategoryModel>> fetchData() async {
    try {
      final response = await _dio.get('/categories');
      List result =
          response.data['data']; // sesuaikan dengan struktur JSON kamu
      return result.map((item) => CategoryModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Gagal ambil data: $e');
    }
  }



}

