import 'package:shopping_list_frontend/data/itemList/item_list_status.dart';
import 'package:shopping_list_frontend/data/itemList/shopping_item.dart';

class ItemListState {
  ItemListState({required this.items, required this.status});

  final ItemCategoryMap items;
  ItemListStatus status;

  // @override
  // bool operator ==(Object other) {
  //   if (other.runtimeType != runtimeType) {
  //     return false;
  //   }

  //   var isEqual = mapEquals(items, (other as ItemListState).items);

  //   return isEqual;
  // }

  // @override
  // int get hashCode {
  //   final List<Object?> values = <Object?>[];

  //   for (var mapEntry in items.entries) {
  //     values.add(mapEntry.key);
  //     for (var item in mapEntry.value) {
  //       values.add(item);
  //     }
  //   }

  //   return Object.hashAll(values);
  // }
}
