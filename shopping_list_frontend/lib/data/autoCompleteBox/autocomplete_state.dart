import 'package:shopping_list_frontend/data/itemList/shopping_item.dart';

class ItemAutoCompleteBoxState {
  ItemAutoCompleteBoxState(
      {required this.categories,
      required this.category,
      required this.itemsSeen,
      required this.quantity});

  List<String> categories;
  final CategoryToItemsSeenMap itemsSeen;
  String? category;
  int quantity;
}
