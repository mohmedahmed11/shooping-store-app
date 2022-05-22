import 'package:marka_app/Data/Api/API_Repository.dart';
import 'package:marka_app/constants.dart';

import '../Models/CategoryModel.dart';

class OrderRepository {
  final APIRepository apiRepository;

  OrderRepository(this.apiRepository);

  Future<ApiResponse<dynamic>> postOrder(dynamic data) async {
    final responce = await apiRepository.post('$baseUrlApi/order', data);
    if (responce.status == Status.completed) {
      return responce;
    } else {
      return ApiResponse.error("no date");
    }
  }
}
