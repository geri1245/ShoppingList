import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_frontend/model/state/local_app_state.dart';

class LocalAppStateCubit extends Cubit<LocalAppState> {
  LocalAppStateCubit() : super(LocalAppState());

  void startAddingItems(String category) {
    var newState = LocalAppState(activeCategory: category, numberToAdd: 1);
    emit(newState);
  }

  void stopAddingItems() {
    var newState = LocalAppState(activeCategory: null);
    emit(newState);
  }

  void updateQuantity(int newQuantity) {
    var newState = LocalAppState(
        activeCategory: state.activeCategory, numberToAdd: newQuantity);
    emit(newState);
  }

  LocalAppState getState() => state;
}
