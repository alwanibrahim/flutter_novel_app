import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_novel_app/data/api/helper/shared_preference_service.dart';

class DioClient {
  static final Dio dio = Dio(BaseOptions(
    baseUrl: dotenv.env['API_URL'] ?? 'https://www.mamamnovel.suarafakta.my.id',
    headers: {
      'Accept': 'application/json',
    },
  ))
    ..interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await LocalStorage.getToken();
        if (token != null && token.isNotEmpty) {
          print("Token digunakan: $token");
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ))
    ..interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
    ));
}
