import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_novel_app/data/api/helper/dio_client.dart';
import 'package:flutter_novel_app/data/model/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiAuth {
  final Dio _dio = DioClient.dio;

 Future<LoginResponse?> login(
      String email, String password, BuildContext context) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      print("Response Data: ${response.data}");

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final loginResponse = LoginResponse.fromJson(response.data);

        if (loginResponse.token.isNotEmpty) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', loginResponse.token);
          await prefs.setString('email', email);
          await prefs.setInt('user_id', loginResponse.userId); // Tambahkan ini

          print(
              "Token dan user_id disimpan: ${loginResponse.token}, ${loginResponse.userId}");

          if (!loginResponse.isVerified) {
            // Kirim OTP
            await _dio.post(
              '/send-otp',
              data: {'email': email},
            );

            // Arahkan ke halaman verifikasi OTP
            Navigator.pushNamed(context, '/verify');
            return null;
          }

          // Kalau sudah terverifikasi, arahkan ke halaman utama
          Navigator.pushReplacementNamed(context, '/main');
          return loginResponse;
        } else {
          print("Token kosong!");
        }
      }

      return null;
    } on DioException catch (e) {
      print("DioError di login: ${e.response?.data ?? e.message}");
      return null;
    } catch (e) {
      print("Error di login: $e");
      return null;
    }
  }


  Future<User> register(
      String name, String userName, String email, String password) async {
    try {
      // 1. Panggil endpoint /register
      final response = await _dio.post(
        '/register',
        data: {
          'name': name,
          'username': userName,
          'email': email,
          'password': password,
          'password_confirmation': password,
        },
        options: Options(headers: {
          'Accept': 'application/json',
        }),
      );

      if (response.statusCode == 201) {
        final data = response.data['data'];

        if (data['user'] != null && data['token'] != null) {
          final user = User.fromJson({
            ...data['user'],
            'token': data['token'],
          });

          // 2. Simpan token
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', user.token!);
          print("Token received: ${user.token}");

          // 3. Kirim OTP via endpoint /send-otp (butuh token auth)
          await _dio.post(
            '/send-otp',
            options: Options(
              headers: {
                'Accept': 'application/json',
                'Authorization': 'Bearer ${user.token}',
              },
            ),
          );
          print("OTP sent to ${user.email}");

          return user;
        } else {
          throw Exception('Invalid response structure: ${response.data}');
        }
      } else {
        throw Exception('Error during registration: ${response.data}');
      }
    } on DioException catch (e) {
      throw Exception(
          'Error during registration: ${e.response?.data ?? e.message}');
    }
  }

  Future<bool> verifyOtp(String otp, String token) async {
    try {
      final response = await _dio.post(
        '/verify-otp',
        data: {'otp': otp},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      throw Exception(
          'OTP verification failed: ${e.response?.data ?? e.message}');
    }
  }


  Future<dynamic> getUser() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token'); // Ambil token

      if (token == null || token.isEmpty) {
        print("Token tidak ditemukan.");
        return null;
      }

      var response = await _dio.get(
        '/user',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      print("User Response: ${response.data}");

      if (response.statusCode == 200) {
        return User.fromJson(response.data['data']['user']);
      }
      return null;
    } on DioException catch (e) {
      print("DioError di getUser: ${e.response?.data ?? e.message}");
      return null;
    } catch (e) {
      print("Error di getUser: $e");
      return null;
    }
  }

  Future<bool> updateUserName(String newName) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        print("Token tidak ditemukan.");
        return false;
      }

      final response = await _dio.put(
        '/user',
        data: {'name': newName},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      print("Update Response: ${response.data}");

      return response.statusCode == 200;
    } on DioException catch (e) {
      print("DioError updateUserName: ${e.response?.data ?? e.message}");
      return false;
    } catch (e) {
      print("Error updateUserName: $e");
      return false;
    }
  }

    Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    final dio = DioClient.dio;
    try {
      await dio.post(
        '/logout',

      );
    } catch (e) {
      // Biarkan kosong atau tambahkan log jika perlu
      print('Logout error: $e');
    }

    // Hapus token dari SharedPreferences
    await prefs.remove('token');
  }
}
