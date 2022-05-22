part of 'category_cubit.dart';

@immutable
abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<CategoryModel> categories;

  CategoryLoaded(this.categories);
}

class CategoryLoaging extends CategoryState {
  final List<CategoryModel> categories;

  CategoryLoaging(this.categories);
}

class FailToLoadCategoryData extends CategoryState {
  final List<CategoryModel> categories;

  FailToLoadCategoryData(this.categories);
}
