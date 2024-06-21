import 'package:shopping_list_frontend/model/itemList/item_list_status.dart';
import 'package:shopping_list_frontend/model/itemList/shopping_item.dart';

class ItemListState {
  ItemListState(
      {required this.items, required this.status, required this.itemsSeen});

  final ItemCategoryMap items;
  final CategoryToItemsSeenMap itemsSeen;
  ItemListStatus status;

  ItemListState.cloneWithChanges(ItemListState other,
      {ItemCategoryMap? items,
      CategoryToItemsSeenMap? itemsSeen,
      ItemListStatus? status})
      : this(
            items: items ?? other.items,
            itemsSeen: itemsSeen ?? other.itemsSeen,
            status: status ?? other.status);
}
