import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_frontend/shopping_item.dart';

typedef ItemCategoryMap = Map<String, List<ShoppingItem>>;

void addToMap(ItemCategoryMap map, ShoppingItem item) {
  if (!map.containsKey(item.category)) {
    map[item.category] = [item];
  } else {
    map[item.category]?.add(item);
  }
}

ItemCategoryMap itemListToItemMap(List<ShoppingItem> items) {
  ItemCategoryMap retVal = {};

  for (var item in items) {
    addToMap(retVal, item);
  }

  return retVal;
}

class ItemListCubit extends Cubit<ItemCategoryMap> {
  ItemListCubit() : super(<String, List<ShoppingItem>>{});

  void add(String category, ShoppingItem item) {
    if (!state.containsKey(item.category)) {
      state[item.category] = [item];
    } else {
      state[item.category]?.add(item);
    }
    emit(state);
  }

  void remove(String category, String name) {}
  void updateFromServer() {}
}
