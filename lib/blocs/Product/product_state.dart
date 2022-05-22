part of 'product_cubit.dart';

@immutable
abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

@immutable
abstract class ProductsListState {}

class ProductsInitialList extends ProductsListState {}

@immutable
abstract class ProductsBestSellerState {}

class ProductsInitialBestSeller extends ProductsBestSellerState {}

@immutable
abstract class ProductsLeatesState {}

class ProductsInitialLeates extends ProductsLeatesState {}

@immutable
abstract class ProductsSimillerState {}

class ProductsInitialSimiller extends ProductsSimillerState {}

// products list state
class ProductsLoadedList extends ProductsListState {
  final List<Product> products;

  ProductsLoadedList(this.products);
}

class ProductsLoagingList extends ProductsListState {
  final List<Product> products;

  ProductsLoagingList(this.products);
}

class FailToLoadProductsDataList extends ProductsListState {
  final List<Product> products;

  FailToLoadProductsDataList(this.products);
}

// products best seller state

class ProductsLoadedBestSallse extends ProductsBestSellerState {
  final List<Product> products;

  ProductsLoadedBestSallse(this.products);
}

class ProductsLoagingBestSeller extends ProductsBestSellerState {
  final List<Product> products;

  ProductsLoagingBestSeller(this.products);
}

class FailToLoadProductsDataBestSeller extends ProductsBestSellerState {
  final List<Product> products;

  FailToLoadProductsDataBestSeller(this.products);
}

// products leates state
class ProductsLoadedLeates extends ProductsLeatesState {
  final List<Product> products;

  ProductsLoadedLeates(this.products);
}

class ProductsLoagingLeates extends ProductsLeatesState {
  final List<Product> products;

  ProductsLoagingLeates(this.products);
}

class FailToLoadProductsDataLeates extends ProductsLeatesState {
  final List<Product> products;

  FailToLoadProductsDataLeates(this.products);
}

// products Similler state
class ProductsLoadedSimimler extends ProductsSimillerState {
  final List<Product> products;

  ProductsLoadedSimimler(this.products);
}

class ProductsLoagingSimiller extends ProductsSimillerState {
  final List<Product> products;

  ProductsLoagingSimiller(this.products);
}

class FailToLoadProductsDataSimiller extends ProductsSimillerState {
  final List<Product> products;

  FailToLoadProductsDataSimiller(this.products);
}
