import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_frontend/data/autoCompleteBox/autocomplete_state.dart';
import 'package:shopping_list_frontend/data/itemList/shopping_item.dart';

class AutoCompleteBoxCubit extends Cubit<ItemAutoCompleteBoxState> {
  AutoCompleteBoxCubit(
      List<String> categories, CategoryToItemsSeenMap itemsSeen)
      : super(ItemAutoCompleteBoxState(
            categories: categories,
            category: null,
            itemsSeen: itemsSeen,
            quantity: 1));

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
          ? (newCategories.isEmpty ? null : newCategories[0])
          : state.category;

      emit(ItemAutoCompleteBoxState(
          categories: newCategories,
          category: newCategory,
          itemsSeen: state.itemsSeen,
          quantity: state.quantity));
    }
  }

  void updateCategories(List<String> newCategories) {
    var newSelectedCategory = state.category;

    if (newCategories.isEmpty) {
      newSelectedCategory = null;
    } else if (!newCategories.contains(newSelectedCategory)) {
      newSelectedCategory = newCategories[0];
    }

    emit(ItemAutoCompleteBoxState(
        categories: newCategories,
        category: newSelectedCategory,
        itemsSeen: state.itemsSeen,
        quantity: state.quantity));
  }

  String get category => state.category ?? "";
  int get quantity => state.quantity;
}
