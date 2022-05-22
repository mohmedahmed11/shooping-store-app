import 'package:marka_app/Data/Api/API_Repository.dart';
import 'package:marka_app/Data/Models/ProductModel.dart';
import 'package:marka_app/constants.dart';

class ProductRepository {
  final APIRepository apiRepository;

  ProductRepository(this.apiRepository);

  // Future<List<Product>> getAllBestSellerProducts() async {
  //   final products = await apiRepository.getAll('$baseUrlApi/best_seller');

  //   return []; //products.map((product) => Product.fromJson(product)).toList();
  //   // emit();
  // }

  Future<ApiResponse<List<dynamic>>> getAllBestSellerProducts() async {
    final products = await apiRepository.getAll('$baseUrlApi/best_seller');
    if (products.status == Status.completed) {
      return products;
    } else {
      return ApiResponse.error("no date");
    }
  }

  Future<ApiResponse<List<dynamic>>> getLeatesProducts() async {
    final products = await apiRepository.getAll('$baseUrlApi/latest');
    if (products.status == Status.completed) {
      return products;
    } else {
      return ApiResponse.error("no date");
    }
  }

  Future<ApiResponse<List<dynamic>>> getProductsBy(int categoryId) async {
    final products =
        await apiRepository.getAll('$baseUrlApi/products_list/$categoryId');
    if (products.status == Status.completed) {
      return products;
    } else {
      return ApiResponse.error("no date");
    }
  }

  Future<ApiResponse<List<dynamic>>> getSimilarProducts(int productId) async {
    final products =
        await apiRepository.getAll('$baseUrlApi/similar_products/$productId');
    if (products.status == Status.completed) {
      return products;
    } else {
      return ApiResponse.error("no date");
    }
  }
}
