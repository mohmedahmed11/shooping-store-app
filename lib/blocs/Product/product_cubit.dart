import 'package:bloc/bloc.dart';
import 'package:marka_app/Data/Api/API_Repository.dart';
import 'package:marka_app/Data/Models/ProductModel.dart';
import 'package:marka_app/Data/Repositories/product_repository.dart';
import 'package:meta/meta.dart';

part 'product_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductRepository productsRepository;
  List<Product> products = [];
  ProductsCubit(this.productsRepository) : super(ProductsInitial());
}

class ProductsListCubit extends Cubit<ProductsListState> {
  final ProductRepository productsRepository;
  List<Product> products = [];
  ProductsListCubit(this.productsRepository) : super(ProductsInitialList());

  List<Product> getProductsBy(int categoryId) {
    emit(ProductsLoagingList(products));
    productsRepository.getProductsBy(categoryId).then((products) {
      if (products.status == Status.error) {
        emit(FailToLoadProductsDataList(const []));
      } else if (products.status == Status.completed) {
        print("object");
        var list =
            products.data.map((product) => Product.fromJson(product)).toList();
        emit(ProductsLoadedList(list));
      } else {
        emit(ProductsLoagingList(const []));
      }
    });

    return products;
  }
}

class ProductsBestSellerCubit extends Cubit<ProductsBestSellerState> {
  final ProductRepository productsRepository;
  List<Product> products = [];
  ProductsBestSellerCubit(this.productsRepository)
      : super(ProductsInitialBestSeller());

  List<Product> getAllBestSellerProducts() {
    emit(ProductsLoagingBestSeller(products));
    productsRepository.getAllBestSellerProducts().then((products) {
      if (products.status == Status.error) {
        emit(FailToLoadProductsDataBestSeller(const []));
      } else if (products.status == Status.completed) {
        print("object");
        var list =
            products.data.map((banner) => Product.fromJson(banner)).toList();
        emit(ProductsLoadedBestSallse(list));
      } else {
        emit(ProductsLoagingBestSeller(const []));
      }
    });

    return products;
  }
}

class ProductsLeatesCubit extends Cubit<ProductsLeatesState> {
  final ProductRepository productsRepository;
  List<Product> products = [];
  ProductsLeatesCubit(this.productsRepository) : super(ProductsInitialLeates());

  List<Product> getLeatesProducts() {
    emit(ProductsLoagingLeates(products));
    productsRepository.getLeatesProducts().then((products) {
      if (products.status == Status.error) {
        emit(FailToLoadProductsDataLeates(const []));
      } else if (products.status == Status.completed) {
        print("object");
        var list =
            products.data.map((product) => Product.fromJson(product)).toList();
        emit(ProductsLoadedLeates(list));
      } else {
        emit(ProductsLoagingLeates(const []));
      }
    });

    return products;
  }
}

class ProductsSimillerCubit extends Cubit<ProductsSimillerState> {
  final ProductRepository productsRepository;
  List<Product> products = [];
  ProductsSimillerCubit(this.productsRepository)
      : super(ProductsInitialSimiller());

  List<Product> getSimilarProducts(int productId) {
    emit(ProductsLoagingSimiller(products));
    productsRepository.getSimilarProducts(productId).then((products) {
      if (products.status == Status.error) {
        emit(FailToLoadProductsDataSimiller(const []));
      } else if (products.status == Status.completed) {
        print("object");
        var list =
            products.data.map((product) => Product.fromJson(product)).toList();
        emit(ProductsLoadedSimimler(list));
      } else {
        emit(ProductsLoagingSimiller(const []));
      }
    });

    return products;
  }
}
