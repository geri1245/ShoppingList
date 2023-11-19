import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_frontend/data/autoCompleteBox/autocomplete_state.dart';

class AutoCompleteBoxCubit extends Cubit<ItemAutoCompleteBoxState> {
  AutoCompleteBoxCubit(String category)
      : super(ItemAutoCompleteBoxState(category: category, quantity: 1));

  void setQuantity(int newQuantity) {
    emit(ItemAutoCompleteBoxState(
        category: state.category, quantity: newQuantity));
  }

  void setCategory(String newCategory) {
    emit(ItemAutoCompleteBoxState(
        category: newCategory, quantity: state.quantity));
  }

  String get category => state.category;
  int get quantity => state.quantity;
}
