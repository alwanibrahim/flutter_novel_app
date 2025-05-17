import 'package:dio/dio.dart';
import 'package:flutter_novel_app/data/api/helper/dio_client.dart';
import 'package:flutter_novel_app/data/model/novel_model.dart';

class UserService {
  final Dio _dio = DioClient.dio;

   Future<User> getUser() async {
    try {
      final response = await _dio.get(
        '/user',
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        return User.fromJson(response.data['data']);
      } else {
        throw Exception('Gagal mengambil data user');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
