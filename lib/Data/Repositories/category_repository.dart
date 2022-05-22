import 'package:marka_app/Data/Api/API_Repository.dart';
import 'package:marka_app/constants.dart';

import '../Models/CategoryModel.dart';

class CategoryRepository {
  final APIRepository apiRepository;

  CategoryRepository(this.apiRepository);

  Future<ApiResponse<List<dynamic>>> getCategories() async {
    final categories = await apiRepository.getAll('$baseUrlApi/categories');
    if (categories.status == Status.completed) {
      return categories;
    } else {
      return ApiResponse.error("no date");
    }
  }
}
