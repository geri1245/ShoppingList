import 'package:equatable/equatable.dart';
import 'package:shopping_list_frontend/model/itemList/list_item.dart';

sealed class ItemListEvent extends Equatable {
  const ItemListEvent();

  @override
  List<Object> get props => [];
}

final class AddItemEvent extends ItemListEvent {
  const AddItemEvent(this.item);

  final Item item;
}

final class UpdateAllItemsEvent extends ItemListEvent {}

final class RemoveItemEvent extends ItemListEvent {
  const RemoveItemEvent({required this.item});

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

final class DeleteSubcategoryEvent extends ItemListEvent {
  const DeleteSubcategoryEvent(
      {required this.mainCategory, required this.subCategory});

  final String mainCategory;
  final String subCategory;
}

final class DeleteMainCategoryEvent extends ItemListEvent {
  const DeleteMainCategoryEvent({required this.categoryToDelete});

  final String categoryToDelete;
}
