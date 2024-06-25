import 'package:flutter/material.dart';

Future<T?> showGeneralPopupMenu<T>(BuildContext context, Offset tapPosition,
    Size screenSize, List<PopupMenuEntry<T>> entries) async {
  return showMenu(
    context: context,
    items: entries,
    position: RelativeRect.fromRect(
        tapPosition & const Size(40, 40), // smaller rect, the touch area
        Offset.zero & screenSize // Bigger rect, the entire screen
        ),
  );
}
