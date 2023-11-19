import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_frontend/data/itemList/events.dart';
import 'package:shopping_list_frontend/data/itemList/http_requests.dart';
import 'package:shopping_list_frontend/data/itemList/item_list_status.dart';
import 'package:shopping_list_frontend/data/itemList/shopping_item.dart';
import 'package:shopping_list_frontend/data/itemList/state.dart';

class ItemListBloc extends Bloc<ItemListEvent, ItemListState> {
  ItemListBloc() : super(ItemListState(items: {}, status: ItemListStatus.ok)) {
    on<ItemAddedEvent>(_onItemAdded);
    on<ItemRemovedEvent>(_onItemCompleted);
    on<UpdateAllItemsEvent>(_updateAlItems);
  }

  Future<void> _onItemAdded(
    ItemAddedEvent event,
    Emitter<ItemListState> emit,
  ) async {
    var newState = ItemListState(items: state.items, status: ItemListStatus.ok);
    if (addToMap(newState.items, event.item)) {
      addItem(event.item);
    } else {
      newState.status = ItemListStatus.itemAlreadyInList;
    }

    emit(newState);
  }

  Future<void> _onItemCompleted(
    ItemRemovedEvent event,
    Emitter<ItemListState> emit,
  ) async {
    var newState = ItemListState(items: state.items, status: ItemListStatus.ok);
    if (removeFromMap(newState.items, event.item)) {
      removeItem(event.item);
    } else {
      newState.status = ItemListStatus.failedToRemoveItem;
    }

    emit(newState);
  }

  Future<void> _updateAlItems(
    UpdateAllItemsEvent event,
    Emitter<ItemListState> emit,
  ) async {
    final result = await fetchItems();

    if (result.statusCode == 200) {
      emit(ItemListState(items: result.data!, status: ItemListStatus.ok));
    }
  }
}
