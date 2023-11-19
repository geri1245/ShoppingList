import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_frontend/data/autoCompleteBox/auto_complete_box_cubit.dart';

class CategoryDropdownButton extends StatefulWidget {
  const CategoryDropdownButton(
      {required this.categories, required this.selectedCategory, super.key});

  final List<String> categories;
  final String selectedCategory;

  @override
  State<CategoryDropdownButton> createState() => _DropdownButtonState();
}

class _DropdownButtonState extends State<CategoryDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      padding: const EdgeInsets.all(4),
      value: widget.selectedCategory,
      elevation: 16,
      dropdownColor: Colors.white,
      focusColor: Colors.white,
      // style: const TextStyle(color: Colors.deepPurple),
      // underline: Container(
      //   height: 2,
      //   color: Colors.deepPurpleAccent,
      // ),
      onChanged: (String? value) {
        context.read<AutoCompleteBoxCubit>().setCategory(value ?? "");
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
