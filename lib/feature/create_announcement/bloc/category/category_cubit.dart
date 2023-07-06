import 'package:bloc/bloc.dart';

import '../../../../data/app_repository.dart';
import '../../../../models/category.dart';
import '../../data/categories_manager.dart';
import '../../data/creating_announcement_manager.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoriesManager categoriesManager;

  CategoryCubit({required this.categoriesManager}) : super(CategoryInitial());

  void loadCategories() async {
    emit(CategoryLoadingState());
    try{
      await categoriesManager.loadCategories();
      emit(CategorySuccessState(categories: categoriesManager.categories));
    } catch (e) {
      emit(CategoryFailState());
      rethrow;
    }
  }
}
