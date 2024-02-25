import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart/feature/create_announcement/data/models/auto_filter.dart';
import 'package:smart/managers/categories_manager.dart';
import 'package:smart/models/item/subcategoryFilters.dart';
import 'package:smart/models/models.dart';
import 'package:smart/services/parameters_parser.dart';

part 'search_select_subcategory_state.dart';

class SearchSelectSubcategoryCubit extends Cubit<SearchSelectSubcategoryState> {
  final CategoriesManager categoriesManager;

  SearchSelectSubcategoryCubit(this.categoriesManager)
      : super(SearchSelectSubcategoryInitial());

  List<Category> categories = [];
  List<Subcategory> subcategories = [];
  List<Parameter> _parameters = [];

  String? _lastCategory;
  String? _lastSubcategory;

  SubcategoryFilters? subcategoryFilters;
  String? subcategoryId;

  List<Parameter> get parameters {
    final List<Parameter> added = [];

    if (autoFilter != null) {
      added.add(dotationFilter!);
      added.add(engineFilter!);
    }

    return _parameters + added;
  }

  AutoFilter? autoFilter;

  SelectParameter? dotationFilter;
  SelectParameter? engineFilter;

  void setAutoFilter(AutoFilter? newAutoFilter) {
    autoFilter = newAutoFilter;
    if (autoFilter != null) {
      dotationFilter = autoFilter!.dotation;
      engineFilter = autoFilter!.engine;
    }
  }

  bool needAddAutoSelectButton = false;

  void getCategories() async {
    emit(CategoryLoadingState());
    categories = await categoriesManager.loadCategories();
    emit(CategoriesGotState());
  }

  void setAutoSubcategory() async {
    needAddAutoSelectButton = true;
  }

  void getSubcategories({String? categoryId, String? subcategoryId}) async {
    if (categoryId != null && categoryId == _lastCategory ||
        subcategoryId != null && subcategoryId == _lastCategory) {
      return emit(SubcategoriesGotState());
    }
    emit(SubcategoriesLoadingState());
    _lastSubcategory = subcategoryId;
    _lastCategory = categoryId;

    needAddAutoSelectButton = false;
    autoFilter = null;
    if (categoryId != null) {
      subcategories =
          await categoriesManager.loadSubcategoriesByCategory(categoryId);
    } else {
      subcategories = await categoriesManager
          .tryToLoadSubcategoriesBuSubcategory(subcategoryId!);
    }

    emit(SubcategoriesGotState());
  }

  Future getSubcategoryFilters(String selectedSubcategoryId) async {
    emit(FiltersLoadingState());

    final res = await categoriesManager.getFilters(selectedSubcategoryId);
    _parameters = ParametersParser(res['parameters']).decodedParameters;

    subcategoryFilters = SubcategoryFilters(_parameters,
        hasMark: res['hasMark'], hasModel: res['hasModel']);
    subcategoryId = selectedSubcategoryId;
    print('got parameters: $_parameters');
    emit(FiltersGotState(_parameters));
    return parameters;
  }
}