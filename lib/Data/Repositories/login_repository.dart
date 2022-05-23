import 'package:marka_app/Data/Api/API_Repository.dart';
import 'package:marka_app/constants.dart';

class LoginRepository {
  final APIRepository apiRepository;

  LoginRepository(this.apiRepository);

  Future<ApiResponse<dynamic>> login(dynamic data) async {
    final responce = await apiRepository.post('$baseUrlApi/login', data);
    if (responce.status == Status.completed) {
      return responce;
    } else {
      return ApiResponse.error(responce.message);
    }
  }
}
