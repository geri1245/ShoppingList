import 'package:shopping_list_frontend/model/itemList/shopping_item.dart';

class ItemAutoCompleteBoxState {
  ItemAutoCompleteBoxState(
      {required this.categories,
      required this.category,
      required this.itemsSeen,
      required this.quantity});

  final List<String> categories;
  final CategoryToItemsSeenMap itemsSeen;
  final String category;
  final int quantity;

  ItemAutoCompleteBoxState.cloneWithChanges(ItemAutoCompleteBoxState other,
      {List<String>? categories,
      CategoryToItemsSeenMap? itemsSeen,
      String? category,
      int? quantity})
      : this(
            categories: categories ?? other.categories,
            category: category ?? other.category,
            itemsSeen: itemsSeen ?? other.itemsSeen,
            quantity: quantity ?? other.quantity);
}
