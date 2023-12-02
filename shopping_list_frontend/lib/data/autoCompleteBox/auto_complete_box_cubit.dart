import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_frontend/data/autoCompleteBox/autocomplete_state.dart';
import 'package:shopping_list_frontend/data/itemList/http_requests.dart';

class AutoCompleteBoxCubit extends Cubit<ItemAutoCompleteBoxState> {
  AutoCompleteBoxCubit()
      : super(ItemAutoCompleteBoxState(
            categories: [""], category: "", itemsSeen: {}, quantity: 1));

  void setQuantity(int newQuantity) {
    if (newQuantity == state.quantity) return;

    emit(ItemAutoCompleteBoxState(
        categories: state.categories,
        category: state.category,
        itemsSeen: state.itemsSeen,
        quantity: newQuantity));
  }

  void setCategory(String newCategory) {
    emit(ItemAutoCompleteBoxState(
        categories: state.categories,
        category: newCategory,
        itemsSeen: state.itemsSeen,
        quantity: state.quantity));
  }

  void addCategory(String newCategory) {
    var newCategories = [...state.categories];

    if (!newCategories.contains(newCategory)) {
      newCategories.add(newCategory);
    }

    emit(ItemAutoCompleteBoxState(
        categories: newCategories,
        category: newCategory,
        itemsSeen: state.itemsSeen,
        quantity: state.quantity));
  }

  void removeCategory(String categoryToRemove) {
    if (state.categories.length < 2) {
      return;
    }
    var newCategories = [...state.categories];

    if (newCategories.remove(categoryToRemove)) {
      final newCategory = state.category == categoryToRemove
          ? (newCategories.isEmpty ? "" : newCategories[0])
          : state.category;

      emit(ItemAutoCompleteBoxState(
          categories: newCategories,
          category: newCategory,
          itemsSeen: state.itemsSeen,
          quantity: state.quantity));
    }
  }

  void updateCategories(List<String> newCategories) {
    emit(ItemAutoCompleteBoxState(
        categories: newCategories,
        category: state.category == ""
            ? (newCategories.isEmpty ? "" : newCategories[0])
            : state.category,
        itemsSeen: state.itemsSeen,
        quantity: state.quantity));
  }

  void updateItemsSeenListFromServer() async {
    final response = await fetchItemsSeen();

    if (response.statusCode == 200) {
      emit(ItemAutoCompleteBoxState(
          categories: state.categories,
          category: state.category,
          itemsSeen: response.data!,
          quantity: state.quantity));
    }
  }

  String get category => state.category;
  int get quantity => state.quantity;
}
