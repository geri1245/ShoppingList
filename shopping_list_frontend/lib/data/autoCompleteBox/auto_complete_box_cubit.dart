import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_frontend/data/autoCompleteBox/autocomplete_state.dart';

class AutoCompleteBoxCubit extends Cubit<ItemAutoCompleteBoxState> {
  AutoCompleteBoxCubit(String category)
      : super(ItemAutoCompleteBoxState(
            categories: ["Default", "Shopping", "Ikea"],
            category: category,
            quantity: 1));

  void setQuantity(int newQuantity) {
    if (newQuantity == state.quantity) return;

    emit(ItemAutoCompleteBoxState(
        categories: state.categories,
        category: state.category,
        quantity: newQuantity));
  }

  void setCategory(String newCategory) {
    emit(ItemAutoCompleteBoxState(
        categories: state.categories,
        category: newCategory,
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
        quantity: state.quantity));
  }

  String get category => state.category;
  int get quantity => state.quantity;
}
