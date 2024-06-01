import 'package:flutter/material.dart';

class TextInputDialog extends StatefulWidget {
  const TextInputDialog({super.key});

  @override
  State<TextInputDialog> createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<TextInputDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(controller: _controller, autofocus: true),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    final text = _controller.text.trim();
                    Navigator.pop(context, text);
                  },
                  child: const Text('Add'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<String?> getTextInputWithDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => const TextInputDialog(),
  );
}
