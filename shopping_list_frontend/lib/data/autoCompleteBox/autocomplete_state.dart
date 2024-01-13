import 'package:shopping_list_frontend/data/itemList/shopping_item.dart';

class ItemAutoCompleteBoxState {
  ItemAutoCompleteBoxState(
      {required this.categories,
      required this.category,
      required this.itemsSeen,
      required this.quantity});

  final List<String> categories;
  final CategoryToItemsSeenMap itemsSeen;
  final String? category;
  final int quantity;
}
