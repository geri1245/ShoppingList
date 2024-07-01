import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_frontend/model/blocs/adding_items_control_cubit.dart';

class NumberInput extends StatelessWidget {
  const NumberInput({required this.currentValue, super.key});

  final int currentValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => context
              .read<AddingItemsControlCubit>()
              .updateQuantity(currentValue - 1),
          icon: const Icon(
            Icons.remove,
            color: Colors.lightBlue,
          ),
        ),
        Text(currentValue.toString()),
        IconButton(
          onPressed: () => context
              .read<AddingItemsControlCubit>()
              .updateQuantity(currentValue + 1),
          icon: const Icon(
            Icons.add,
            color: Colors.lightBlue,
          ),
        ),
      ],
    );
  }
}
