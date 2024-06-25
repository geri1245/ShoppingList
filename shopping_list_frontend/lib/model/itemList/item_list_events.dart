import 'package:equatable/equatable.dart';
import 'package:shopping_list_frontend/model/itemList/shopping_item.dart';

sealed class ItemListEvent extends Equatable {
  const ItemListEvent();

  @override
  List<Object> get props => [];
}

final class ItemAddedEvent extends ItemListEvent {
  const ItemAddedEvent(this.item);

  final ShoppingItem item;
}

final class UpdateAllItemsEvent extends ItemListEvent {}

final class ItemRemovedEvent extends ItemListEvent {
  const ItemRemovedEvent({required this.item});

  final ShoppingItem item;
}

final class ErrorEvent extends ItemListEvent {
  const ErrorEvent(this.error);

  final String error;
}

final class StartAddingItemsEvent extends ItemListEvent {
  const StartAddingItemsEvent(this.category);

  final String category;
}

final class DeleteCategoryEvent extends ItemListEvent {
  const DeleteCategoryEvent(this.category);

  final String category;
}
