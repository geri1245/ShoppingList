import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_frontend/model/itemList/item_list_events.dart';
import 'package:shopping_list_frontend/model/networking/http_requests.dart';
import 'package:shopping_list_frontend/model/itemList/item_list_status.dart';
import 'package:shopping_list_frontend/model/itemList/shopping_item.dart';
import 'package:shopping_list_frontend/model/state/item_list_state.dart';

class ItemListBloc extends Bloc<ItemListEvent, ItemListState> {
  ItemListBloc()
      : super(ItemListState(
            items: {}, status: ItemListStatus.ok, itemsSeen: {})) {
    on<ItemAddedEvent>(_onItemAdded);
    on<ItemRemovedEvent>(_onItemCompleted);
    on<UpdateAllItemsEvent>(_updateAlItems);
    on<DeleteCategoryEvent>(_onCategoryDeleted);
  }

  Completer? _completer;

  Future<void> _onItemAdded(
    ItemAddedEvent event,
    Emitter<ItemListState> emit,
  ) async {
    var newState = ItemListState(
        items: state.items,
        status: ItemListStatus.ok,
        itemsSeen: state.itemsSeen);

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
        itemsSeen: state.itemsSeen);
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

    // This is only needed for the pull to refresh indicator, so it's not an issue if we are a little early with it
    // The http request has already arrived and that should be slower than emitting the new state anyway
    if (_completer != null) {
      _completer?.complete();
      _completer = null;
    }

    if (itemsResult.statusCode == 200) {
      emit(ItemListState(
          items: itemsResult.data!.items,
          status: ItemListStatus.ok,
          itemsSeen: itemsResult.data!.itemsSeen));
    } else {
      emit(ItemListState(
          items: state.items,
          status: ItemListStatus.networkError,
          itemsSeen: state.itemsSeen));
    }
  }

  Future<void> _onCategoryDeleted(
    DeleteCategoryEvent event,
    Emitter<ItemListState> emit,
  ) async {
    if (state.items.containsKey(event.category) &&
        state.items[event.category]!.length == 1) {
      var itemToRemove = state.items[event.category]![0];
      add(ItemRemovedEvent(item: itemToRemove));
    } else {
      emit(ItemListState.cloneWithChanges(state,
          status: ItemListStatus.categoryNotEmptyOrDoesntExist));
    }
  }

  Future<void> updateAlItems() {
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
