import 'package:dio/dio.dart';
import 'package:flutter_novel_app/data/api/helper/dio_client.dart';
import 'package:flutter_novel_app/data/model/novel_model.dart';

class NovelService {
  final Dio _dio = DioClient.dio;

  Future<List<NovelModel>> fetchData() async {
    try {
      final response = await _dio.get('/novels');

    print("Status Code: ${response.statusCode}");
    print("Full Response: ${response.data}");

      List result =
          response.data['data']['data']; // sesuaikan dengan struktur JSON kamu
      return result.map((item){
         try {
          return NovelModel.fromJson(item);
        } catch (e) {
          print("Error parsing item: $item\nError: $e");
          return null; // atau bisa di-skip saja
        }
      })
          .whereType<NovelModel>()
          .toList();
      
    } catch (e, stackTrace) {
       print("Error occurred: $e");
      print("Stack trace: $stackTrace");
      throw Exception('Gagal ambil data: $e');
    }
  }
}
