import 'package:flutter/material.dart';
import 'package:shopping_list_frontend/view/popups/popup_menu.dart';

Future<String?> showStringListPopupMenu(BuildContext context,
    Offset tapPosition, Size screenSize, List<String> entries) async {
  return showGeneralPopupMenu(context, tapPosition, screenSize,
      <PopupMenuEntry<String>>[StringEntry(entries: entries)]);
}

class StringEntry extends PopupMenuEntry<String> {
  const StringEntry({required this.entries, super.key});

  final List<String> entries;

  @override
  State<StatefulWidget> createState() => StringEntryState();

  @override
  double get height => 100;

  @override
  bool represents(String? value) {
    return true;
  }
}

class StringEntryState extends State<StringEntry> {
  void _closePopup(String result) {
    Navigator.pop<String>(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.0,
      child: SingleChildScrollView(
        child: Column(
            children: widget.entries
                .map((element) => TextButton(
                      onPressed: () {
                        _closePopup(element);
                      },
                      child: Text(element),
                    ))
                .toList()),
      ),
    );
  }
}
