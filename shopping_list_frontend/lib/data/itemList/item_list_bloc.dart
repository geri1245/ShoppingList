import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_frontend/data/autoCompleteBox/auto_complete_box_cubit.dart';
import 'package:shopping_list_frontend/data/itemList/events.dart';
import 'package:shopping_list_frontend/data/itemList/http_requests.dart';
import 'package:shopping_list_frontend/data/itemList/item_list_status.dart';
import 'package:shopping_list_frontend/data/itemList/shopping_item.dart';
import 'package:shopping_list_frontend/data/itemList/state.dart';

class ItemListBloc extends Bloc<ItemListEvent, ItemListState> {
  ItemListBloc()
      : super(
            ItemListState(items: {}, itemSeen: {}, status: ItemListStatus.ok)) {
    on<ItemAddedEvent>(_onItemAdded);
    on<ItemRemovedEvent>(_onItemCompleted);
    on<UpdateAllItemsEvent>(_updateAlItems);
  }

  AutoCompleteBoxCubit autoCompleteBoxCubit = AutoCompleteBoxCubit();

  Future<void> _onItemAdded(
    ItemAddedEvent event,
    Emitter<ItemListState> emit,
  ) async {
    var newState = ItemListState(
        items: state.items,
        itemSeen: state.itemSeen,
        status: ItemListStatus.ok);
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
    var newState = ItemListState(
        items: state.items,
        itemSeen: state.itemSeen,
        status: ItemListStatus.ok);
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
    final [
      itemsResult as RequestResult<ItemCategoryMap>,
      itemsSeenResult as RequestResult<CategoryToItemsSeenMap>
    ] = await Future.wait([fetchItems(), fetchItemsSeen()]);

    if (itemsResult.statusCode == 200) {
      // Update the categories list with the keys
      autoCompleteBoxCubit.updateCategories(itemsResult.data!.keys.toList());

      // We don't care too much about this going wrong right now, not that important
      CategoryToItemsSeenMap itemsSeen =
          itemsSeenResult.statusCode == 200 ? itemsSeenResult.data! : {};
      emit(ItemListState(
          items: itemsResult.data!,
          itemSeen: itemsSeen,
          status: ItemListStatus.ok));
    }
  }
}
