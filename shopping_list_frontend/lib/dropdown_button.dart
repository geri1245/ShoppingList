import 'package:flutter/material.dart';

class CategoryDropdownButton extends StatefulWidget {
  const CategoryDropdownButton({required this.categories, super.key});

  final List<String> categories;

  @override
  State<CategoryDropdownButton> createState() => _DropdownButtonState();
}

class _DropdownButtonState extends State<CategoryDropdownButton> {
  @override
  void initState() {
    super.initState();
    selectedCategory = widget.categories.first;
  }

  late String selectedCategory;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedCategory,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        setState(() {
          selectedCategory = value!;
        });
      },
      items: widget.categories.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
