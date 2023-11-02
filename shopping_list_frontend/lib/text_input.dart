import 'package:flutter/material.dart';

class TextInputField extends StatefulWidget {
  const TextInputField(this.myFunction, {super.key});

  final void Function(String)? myFunction;

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _TextInputFieldState extends State<TextInputField> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: myController,
        onSubmitted: (value) {
          if (widget.myFunction != null) {
            widget.myFunction!(value);
            myController.clear();
          }
        },
      ),
    );
  }
}
