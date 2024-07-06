import 'package:flutter/material.dart';

const itemHorizontalPadding = EdgeInsets.symmetric(horizontal: 8);
const dialogPadding = EdgeInsets.symmetric(horizontal: 24, vertical: 12);

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: dialogPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(message),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: itemHorizontalPadding,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text("Please no! 😢"),
                  ),
                ),
                Padding(
                  padding: itemHorizontalPadding,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text('Yeehaw! 🤠'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool?> showConfirmationDialog(BuildContext context, String message) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) => ConfirmationDialog(
      message: message,
    ),
  );
}
