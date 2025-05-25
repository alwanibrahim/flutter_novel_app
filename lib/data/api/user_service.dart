import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_novel_app/data/api/helper/dio_client.dart';
import 'package:flutter_novel_app/data/model/novel_model.dart';
import 'package:http_parser/http_parser.dart';

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

  Future<User> updateUserWithImage({
    required int id,
    required String name,
    required String username,
    required String phoneNumber,
    required String bio,
    Uint8List? profileImageBytes,
  }) async {
    try {
      final formMap = <String, dynamic>{
        'name': name,
        'username': username,
        'phone_number': phoneNumber,
        'bio': bio,
        '_method': 'PUT',
      };

      if (profileImageBytes != null) {
        formMap['profile_picture'] = MultipartFile.fromBytes(
          profileImageBytes,
          filename: 'profile.jpg',
          contentType: MediaType('image', 'jpeg'),
        );
      }

      final formData = FormData.fromMap(formMap);

      final response = await _dio.post('/users/$id', data: formData);
      return User.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Gagal update user dengan foto: $e');
    }
  }
  
}
