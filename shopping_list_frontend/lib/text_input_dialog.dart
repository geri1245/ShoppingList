import 'package:flutter/material.dart';

Future<String?> getTextInputWithDialog(BuildContext context) {
  final controller = TextEditingController();
  final textField = TextField(controller: controller, autofocus: true);

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            textField,
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    final text = controller.text.trim();
                    Navigator.pop(context, text);
                    // TODO: Does this need to be disposed? If so, its text should be copied, so it won't be disposed
                    // controller.dispose();
                  },
                  child: const Text('Add'),
                ),
                TextButton(
                  onPressed: () {
                    controller.dispose();
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
