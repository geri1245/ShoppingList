import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_frontend/data/itemList/events.dart';
import 'package:shopping_list_frontend/data/itemList/http_requests.dart';
import 'package:shopping_list_frontend/data/itemList/item_list_status.dart';
import 'package:shopping_list_frontend/data/itemList/shopping_item.dart';
import 'package:shopping_list_frontend/data/state/item_list_state.dart';

class ItemListBloc extends Bloc<ItemListEvent, ItemListState> {
  ItemListBloc()
      : super(ItemListState(
            items: {},
            status: ItemListStatus.ok,
            itemsSeen: {},
            categoryForWhichItemsAreBeingAdded: null)) {
    on<ItemAddedEvent>(_onItemAdded);
    on<ItemRemovedEvent>(_onItemCompleted);
    on<UpdateAllItemsEvent>(_updateAlItems);
  }

  Completer? _completer;

  Future<void> _onItemAdded(
    ItemAddedEvent event,
    Emitter<ItemListState> emit,
  ) async {
    var newState = ItemListState(
        items: state.items,
        status: ItemListStatus.ok,
        itemsSeen: state.itemsSeen,
        categoryForWhichItemsAreBeingAdded: null);

    if (addToMap(newState.items, event.item)) {
      final responseCode = await addItem(event.item);
      newState.status =
          responseCode == 200 ? ItemListStatus.ok : ItemListStatus.networkError;
    } else {
      newState.status = ItemListStatus.itemAlreadyInList;
    }

    emit(newState);
  }

  Future<void> _onItemCompleted(
    ItemRemovedEvent event,
    Emitter<ItemListState> emit,
  ) async {
    var newState = ItemListState(
        items: state.items,
        status: ItemListStatus.ok,
        itemsSeen: state.itemsSeen,
        categoryForWhichItemsAreBeingAdded: null);
    if (removeFromMap(newState.items, event.item)) {
      final responseCode = await removeItem(event.item);
      newState.status =
          responseCode == 200 ? ItemListStatus.ok : ItemListStatus.networkError;
    } else {
      newState.status = ItemListStatus.failedToRemoveItem;
    }

    emit(newState);
  }

  Future<void> _updateAlItems(
    UpdateAllItemsEvent event,
    Emitter<ItemListState> emit,
  ) async {
    final itemsResult = await fetchItems();

    if (_completer != null) {
      _completer?.complete();
      _completer = null;
    }

    if (itemsResult.statusCode == 200) {
      emit(ItemListState(
          items: itemsResult.data!.items,
          status: ItemListStatus.ok,
          itemsSeen: itemsResult.data!.itemsSeen,
          categoryForWhichItemsAreBeingAdded: null));
    } else {
      emit(ItemListState(
          items: state.items,
          status: ItemListStatus.networkError,
          itemsSeen: state.itemsSeen,
          categoryForWhichItemsAreBeingAdded: null));
    }
  }

  Future<void> updateAlItemsAsync() {
    add(UpdateAllItemsEvent());

    if (_completer != null) {
      _completer?.complete();
    }

    _completer = Completer();
    return _completer!.future;
  }

  List<String> getItemsSeenForCategory(String category) {
    return state.itemsSeen[category] ?? [];
  }
}
