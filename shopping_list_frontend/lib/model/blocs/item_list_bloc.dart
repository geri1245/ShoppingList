import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_frontend/model/itemList/item_list_events.dart';
import 'package:shopping_list_frontend/model/networking/http_requests.dart';
import 'package:shopping_list_frontend/model/itemList/item_list_status.dart';
import 'package:shopping_list_frontend/model/itemList/list_item.dart';
import 'package:shopping_list_frontend/model/state/item_list_state.dart';

class ItemListBloc extends Bloc<ItemListEvent, ItemListState> {
  ItemListBloc()
      : super(ItemListState(
            items: {}, status: ItemListStatus.ok, itemsSeen: {})) {
    on<AddItemEvent>(_onAddItemEvent);
    on<RemoveItemEvent>(_onRemoveItemEvent);
    on<UpdateAllItemsEvent>(_onUpdateAllItemsEvent);
    on<DeleteSubcategoryEvent>(_onDeleteSubcategoryEvent);
    on<DeleteMainCategoryEvent>(_onDeleteMainCategoryEvent);
  }

  Completer? _completer;

  Future<void> _onAddItemEvent(
    AddItemEvent event,
    Emitter<ItemListState> emit,
  ) async {
    final (newMap, couldAddItem) =
        addItemToCategoryMap(state.items, event.item);

    if (couldAddItem) {
      final responseCode = await addItem(event.item);
      final newStatus = switch (responseCode) {
        200 => ItemListStatus.ok,
        409 => ItemListStatus.failedToAddItem,
        _ => ItemListStatus.unknownError,
      };

      if (newStatus == ItemListStatus.ok) {
        emit(ItemListState.cloneWithChanges(state,
            status: newStatus, items: newMap));
      } else {
        emit(ItemListState.cloneWithChanges(state, status: newStatus));
      }
    } else {
      emit(ItemListState.cloneWithChanges(state,
          status: ItemListStatus.itemAlreadyInList));
    }
  }

  Future<void> _onRemoveItemEvent(
    RemoveItemEvent event,
    Emitter<ItemListState> emit,
  ) async {
    final (newMap, couldRemove) = removeFromMap(state.items, event.item);
    if (couldRemove) {
      final responseCode = await removeItem(event.item);
      final newStatus = switch (responseCode) {
        200 => ItemListStatus.ok,
        409 => ItemListStatus.failedToRemoveItem,
        _ => ItemListStatus.unknownError,
      };
      if (newStatus == ItemListStatus.ok) {
        emit(ItemListState.cloneWithChanges(state,
            status: newStatus, items: newMap));
      } else {
        emit(ItemListState.cloneWithChanges(state, status: newStatus));
      }
    } else {
      emit(ItemListState.cloneWithChanges(state,
          status: ItemListStatus.failedToRemoveItem));
    }
  }

  Future<void> _onUpdateAllItemsEvent(
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

  Future<void> _onDeleteSubcategoryEvent(
    DeleteSubcategoryEvent event,
    Emitter<ItemListState> emit,
  ) async {
    if (state.items[event.mainCategory]?[event.subCategory]?.length == 1) {
      var itemToRemove =
          state.items[event.mainCategory]![event.subCategory]![0];
      add(RemoveItemEvent(item: itemToRemove));
    } else {
      emit(ItemListState.cloneWithChanges(state,
          status: ItemListStatus.categoryNotEmptyOrDoesntExist));
    }
  }

  Future<void> _onDeleteMainCategoryEvent(
    DeleteMainCategoryEvent event,
    Emitter<ItemListState> emit,
  ) async {
    if (state.items[event.categoryToDelete]?.keys.length == 1) {
      final onlyElement =
          state.items[event.categoryToDelete]!.entries.elementAt(0);
      if (onlyElement.key.isEmpty &&
          onlyElement.value.length == 1 &&
          onlyElement.value.first.name.isEmpty) {
        return add(RemoveItemEvent(
            item: Item.placeholderFromMainCategory(event.categoryToDelete)));
      }
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

  List<String> getItemsSeenForCategory(
      {required String mainCategory, required String subCategory}) {
    return state.itemsSeen[mainCategory]?[subCategory] ?? [];
  }
}
