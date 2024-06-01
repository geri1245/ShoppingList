import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_frontend/data/state/autocomplete_state.dart';
import 'package:shopping_list_frontend/data/itemList/shopping_item.dart';

class AutoCompleteBoxCubit extends Cubit<ItemAutoCompleteBoxState> {
  AutoCompleteBoxCubit(
      List<String> categories, CategoryToItemsSeenMap itemsSeen)
      : super(ItemAutoCompleteBoxState(
            categories: categories,
            category: categories.firstOrNull,
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

  void updateAll(List<String> categories, CategoryToItemsSeenMap itemsSeen) {
    emit(ItemAutoCompleteBoxState(
        categories: categories,
        category: categories.firstOrNull,
        itemsSeen: itemsSeen,
        quantity: state.quantity));
  }

  String get category => state.category ?? "";
  int get quantity => state.quantity;
}
