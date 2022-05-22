import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:marka_app/Data/Models/ResponceModel.dart';
import 'package:marka_app/constants.dart';

class APIRepository {
  late Dio dio;

  APIRepository() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: 20 * 1000, // 60 seconds,
      receiveTimeout: 20 * 1000,
    );

    dio = Dio(options);
  }

  Future<ApiResponse<List<dynamic>>> getAll(String path) async {
    //  ApiResponse.loading("loading");
    try {
      Response response = await dio.get(path);
      print(response.statusCode);

      return ApiResponse.completed(response.data);
    } catch (e) {
      print(e.toString());
      return ApiResponse.error("fail to LoadData");
    }
  }

//   var formData = FormData.fromMap({
//   'name': 'wendux',
//   'age': 25,
// });
// var response =

  Future<ApiResponse<dynamic>> post(String path, dynamic formData) async {
    //  ApiResponse.loading("loading");
    try {
      Response response = await dio.request(
        path,
        data: formData,
        options: Options(method: 'POST'),
      );

      print(response);

      ResponseModel data = ResponseModel.fromJson(response.data);
      if (data.status == true) {
        return ApiResponse.completed(data.data);
      } else {
        return ApiResponse.error("Fail To Send Data");
      }
    } catch (e) {
      print(e.toString());
      return ApiResponse.error("fail to LoadData");
    }
  }
}

class ApiResponse<T> {
  late Status status;
  late T data;
  late String message;

  ApiResponse.loading(this.message) : status = Status.loading;
  ApiResponse.completed(this.data) : status = Status.completed;
  ApiResponse.error(this.message) : status = Status.error;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum Status { loading, completed, error }
