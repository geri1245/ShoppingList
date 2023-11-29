import 'package:equatable/equatable.dart';

class ShoppingItem extends Equatable {
  const ShoppingItem(
      {required this.category, required this.itemName, required this.count});

  final String category;
  final String itemName;
  final int count;

  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      itemName: json['name'] as String,
      count: json['quantity'] as int,
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {"name": itemName, "quantity": count, "category": category};
  }

  @override
  List<Object> get props => [category, itemName];
}

typedef ItemCategoryMap = Map<String, List<ShoppingItem>>;

bool addToMap(ItemCategoryMap map, ShoppingItem item) {
  if (!map.containsKey(item.category)) {
    map[item.category] = [item];
    return true;
  }

  if (!(map[item.category]?.contains(item) ?? true)) {
    map[item.category]?.add(item);
    return true;
  }

  return false;
}

bool removeFromMap(ItemCategoryMap map, ShoppingItem item) {
  if (map.containsKey(item.category)) {
    if (map[item.category]?.remove(item) ?? false) {
      // See if this was our last item in the current category, then remove the category
      if (map[item.category]!.isEmpty) {
        map.remove(item.category);
      }

      return true;
    }
  }

  return false;
}

ItemCategoryMap itemListToItemMap(List<ShoppingItem> items) {
  ItemCategoryMap retVal = {};

  for (var item in items) {
    addToMap(retVal, item);
  }

  return retVal;
}
