import 'package:flutter/material.dart';
import 'package:shopping_list_frontend/view/popups/popup_menu.dart';

enum ItemLongTapAction {
  moveToAnotherCategory,
  delete,
}

Future<ItemLongTapAction?> showItemLongTapActionMenu(
    BuildContext context, Offset tapPosition, Size screenSize) async {
  return showGeneralPopupMenu(context, tapPosition, screenSize,
      <PopupMenuEntry<ItemLongTapAction>>[const ItemLongTapActionEntry()]);
}

class ItemLongTapActionEntry extends PopupMenuEntry<ItemLongTapAction> {
  // height doesn't matter, as long as we are not giving
  // initialValue to showMenu().
  @override
  final double height = 100;

  const ItemLongTapActionEntry({super.key});

  @override
  bool represents(ItemLongTapAction? value) =>
      value == ItemLongTapAction.moveToAnotherCategory ||
      value == ItemLongTapAction.delete;

  @override
  ItemLongTapActionEntryState createState() => ItemLongTapActionEntryState();
}

class ItemLongTapActionEntryState extends State<ItemLongTapActionEntry> {
  void _closePopup(ItemLongTapAction action) {
    Navigator.pop<ItemLongTapAction>(context, action);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextButton(
            onPressed: () =>
                _closePopup(ItemLongTapAction.moveToAnotherCategory),
            child: const Text('Change category')),
        TextButton(
            onPressed: () => _closePopup(ItemLongTapAction.delete),
            child: const Text('Delete')),
      ],
    );
  }
}
