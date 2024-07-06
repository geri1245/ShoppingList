import 'package:equatable/equatable.dart';
import 'package:shopping_list_frontend/model/itemList/list_item.dart';

sealed class ItemListEvent extends Equatable {
  const ItemListEvent();

  @override
  List<Object> get props => [];
}

final class ItemAddedEvent extends ItemListEvent {
  const ItemAddedEvent(this.item);

  final Item item;
}

final class UpdateAllItemsEvent extends ItemListEvent {}

final class ItemRemovedEvent extends ItemListEvent {
  const ItemRemovedEvent({required this.item});

  final Item item;
}

final class ErrorEvent extends ItemListEvent {
  const ErrorEvent(this.error);

  final String error;
}

final class StartAddingItemsEvent extends ItemListEvent {
  const StartAddingItemsEvent(
      {required this.mainCategory, required this.subCategory});

  final String mainCategory;
  final String subCategory;
}

final class DeleteCategoryEvent extends ItemListEvent {
  const DeleteCategoryEvent(
      {required this.mainCategory, required this.subCategory});

  final String mainCategory;
  final String subCategory;
}
