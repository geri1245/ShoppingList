import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Item extends Equatable {
  const Item(
      {required this.name,
      required this.mainCategory,
      required this.subCategory,
      required this.count});

  final String name;
  final String mainCategory;
  final String subCategory;
  final int count;

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'] as String,
      count: json['quantity'] as int,
      mainCategory: json['main_category'] as String,
      subCategory: json['sub_category'] as String,
    );
  }

  factory Item.placeholderFromMainCategory(String mainCategory) {
    return Item(
      name: "",
      count: 0,
      mainCategory: mainCategory,
      subCategory: "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "quantity": count,
      "main_category": mainCategory,
      "sub_category": subCategory
    };
  }

  @override
  List<Object> get props => [name, mainCategory, subCategory];
}

class ItemWithoutQuantity extends Equatable {
  const ItemWithoutQuantity(
      {required this.name,
      required this.mainCategory,
      required this.subCategory});

  final String name;
  final String mainCategory;
  final String subCategory;

  factory ItemWithoutQuantity.fromJson(Map<String, dynamic> json) {
    return ItemWithoutQuantity(
      name: json['name'] as String,
      mainCategory: json['main_category'] as String,
      subCategory: json['sub_category'] as String,
    );
  }

  @override
  List<Object> get props => [name, mainCategory, subCategory];
}

typedef ItemCategoryMap = Map<String, Map<String, List<Item>>>;
typedef CategoryToItemsSeenMap = Map<String, Map<String, List<String>>>;

bool areSubCategoriesEqual(
    Map<String, List<Item>> lhs, Map<String, List<Item>> rhs) {
  final keys = lhs.keys.toList();
  if (!listEquals(keys, rhs.keys.toList())) {
    return false;
  }

  return keys.every((key) => listEquals(lhs[key], rhs[key]));
}

(ItemCategoryMap, bool) addItemToCategoryMap(ItemCategoryMap map, Item item) {
  final newMap = Map.of(map);
  if (!map.containsKey(item.mainCategory)) {
    newMap[item.mainCategory] = <String, List<Item>>{
      item.subCategory: [item]
    };

    return (newMap, true);
  }

  if (!newMap[item.mainCategory]!.containsKey(item.subCategory)) {
    newMap[item.mainCategory] = Map.of(map[item.mainCategory]!);
    newMap[item.mainCategory]![item.subCategory] = [item];

    return (newMap, true);
  }

  if (!newMap[item.mainCategory]![item.subCategory]!
      .any((element) => element.name == item.name)) {
    newMap[item.mainCategory] = Map.of(map[item.mainCategory]!);
    newMap[item.mainCategory]![item.subCategory] =
        List.of(map[item.mainCategory]![item.subCategory]!)..add(item);

    return (newMap, true);
  }

  return (map, false);
}

bool addItemToItemsSeenMap(
    CategoryToItemsSeenMap map, ItemWithoutQuantity item) {
  final currentItems = map.putIfAbsent(
    item.mainCategory,
    () => <String, List<String>>{},
  );

  if (!currentItems.containsKey(item.subCategory)) {
    currentItems[item.subCategory] = [item.name];
    return true;
  }

  final currentItemList = currentItems[item.subCategory]!;

  if (!currentItemList.any((element) => element == item.name)) {
    currentItemList.add(item.name);
    return true;
  }

  return false;
}

(ItemCategoryMap, bool) removeFromMap(ItemCategoryMap map, Item item) {
  final newMap = Map.of(map);
  if (newMap[item.mainCategory]?[item.subCategory]?.contains(item) ?? false) {
    newMap[item.mainCategory] = Map.of(map[item.mainCategory]!);
    newMap[item.mainCategory]![item.subCategory] =
        List.of(map[item.mainCategory]![item.subCategory]!)..remove(item);

    if (newMap[item.mainCategory]![item.subCategory]!.isEmpty) {
      newMap[item.mainCategory]!.remove(item.subCategory);
    }
    if (newMap[item.mainCategory]!.isEmpty) {
      newMap.remove(item.mainCategory);
    }

    return (newMap, true);
  }

  return (newMap, false);
}

void addItemToItems(ItemCategoryMap map, Item item) {
  map
      .putIfAbsent(item.mainCategory, () => <String, List<Item>>{})
      .putIfAbsent(item.subCategory, () => []);

  map[item.mainCategory]![item.subCategory]!.add(item);
}

ItemCategoryMap itemListToItemMap(List<Item> items) {
  ItemCategoryMap map = {};

  for (var item in items) {
    addItemToItems(map, item);
  }

  return map;
}

CategoryToItemsSeenMap itemsSeenToItemsSeenMap(
    List<ItemWithoutQuantity> items) {
  CategoryToItemsSeenMap map = {};

  for (var item in items) {
    addItemToItemsSeenMap(map, item);
  }

  return map;
}
