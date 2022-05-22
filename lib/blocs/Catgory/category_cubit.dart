import 'package:bloc/bloc.dart';
import 'package:marka_app/Data/Api/API_Repository.dart';
import 'package:marka_app/Data/Models/CategoryModel.dart';
import 'package:marka_app/Data/Repositories/category_repository.dart';
import 'package:meta/meta.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository categoryRepository;
  List<CategoryModel> categories = [];
  CategoryCubit(this.categoryRepository) : super(CategoryInitial());

  List<CategoryModel> getAllCategories() {
    emit(CategoryLoaging(categories));
    categoryRepository.getCategories().then((categories) {
      if (categories.status == Status.error) {
        emit(FailToLoadCategoryData(const []));
      } else if (categories.status == Status.completed) {
        print("object");
        var list = categories.data
            .map((category) => CategoryModel.fromJson(category))
            .toList();
        emit(CategoryLoaded(list));
      } else {
        emit(CategoryLoaging(const []));
      }
    });

    return categories;
  }
}
