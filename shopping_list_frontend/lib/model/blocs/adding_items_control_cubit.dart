import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_frontend/model/state/adding_items_control_state.dart';

class AddingItemsControlCubit extends Cubit<AddingItemsControlState> {
  AddingItemsControlCubit() : super(AddingItemsControlState());

  void startAddingItems(String category) {
    var newState =
        AddingItemsControlState(activeCategory: category, numberToAdd: 1);
    emit(newState);
  }

  void stopAddingItems() {
    var newState = AddingItemsControlState(activeCategory: null);
    emit(newState);
  }

  void updateQuantity(int newQuantity) {
    var newState = AddingItemsControlState(
        activeCategory: state.activeCategory, numberToAdd: newQuantity);
    emit(newState);
  }

  AddingItemsControlState getState() => state;
}
