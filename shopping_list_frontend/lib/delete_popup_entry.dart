import 'package:flutter/material.dart';

class DeletePopupEntry extends PopupMenuEntry<bool> {
  const DeletePopupEntry({super.key});

  @override
  State<StatefulWidget> createState() {
    return DeletePopupEntryState();
  }

  @override
  double get height => 10;

  @override
  bool represents(bool? value) {
    return false;
  }
}

class DeletePopupEntryState extends State<DeletePopupEntry> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(context, true),
      icon: const Icon(
        Icons.delete,
        color: Colors.lightBlue,
      ),
    );
  }
}
