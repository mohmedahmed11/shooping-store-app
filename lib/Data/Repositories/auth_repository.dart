import 'package:marka_app/Data/Api/API_Repository.dart';
import 'package:marka_app/constants.dart';

class AuthRepository {
  final APIRepository apiRepository;

  AuthRepository(this.apiRepository);

  Future<ApiResponse<dynamic>> login(dynamic data) async {
    final responce = await apiRepository.post('$baseUrlApi/login', data);
    if (responce.status == Status.completed) {
      return responce;
    } else {
      return ApiResponse.error(responce.message);
    }
  }

  Future<ApiResponse<dynamic>> update(dynamic data) async {
    final responce = await apiRepository.post('$baseUrlApi/update_user', data);
    if (responce.status == Status.completed) {
      return responce;
    } else {
      return ApiResponse.error(responce.message);
    }
  }

  Future<ApiResponse<dynamic>> getUser(int id) async {
    final responce = await apiRepository.get('$baseUrlApi/user/$id');
    if (responce.status == Status.completed) {
      return responce;
    } else {
      return ApiResponse.error(responce.message);
    }
  }
}
