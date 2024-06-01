import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_frontend/data/state/local_app_state.dart';

class LocalAppStateCubit extends Cubit<LocalAppState> {
  LocalAppStateCubit() : super(LocalAppState());

  void startAddingItems(String category) {
    var newState = LocalAppState(
        categoryForWhichItemsAreBeingAdded: category, numberToAdd: 1);
    emit(newState);
  }

  void stopAddingItems() {
    var newState = LocalAppState(categoryForWhichItemsAreBeingAdded: null);
    emit(newState);
  }

  void updateQuantity(int newQuantity) {
    var newState = LocalAppState(
        categoryForWhichItemsAreBeingAdded:
            state.categoryForWhichItemsAreBeingAdded,
        numberToAdd: newQuantity);
    emit(newState);
  }

  LocalAppState getState() => state;
}
