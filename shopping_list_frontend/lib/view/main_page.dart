import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_frontend/model/blocs/local_app_state_cubit.dart';
import 'package:shopping_list_frontend/model/blocs/item_list_bloc.dart';
import 'package:shopping_list_frontend/model/state/local_app_state.dart';
import 'package:shopping_list_frontend/view/autocomplete_box.dart';
import 'package:shopping_list_frontend/view/topic_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Future<void> _onPagePullRefreshed(BuildContext context) {
    return context.read<ItemListBloc>().updateAlItems();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _onPagePullRefreshed(context),
      child: BlocProvider(
        create: (context) => LocalAppStateCubit(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            BlocBuilder<LocalAppStateCubit, LocalAppState>(
              builder: (BuildContext context, state) {
                if (state.activeCategory != null) {
                  return AutocompleteBox(
                      autocompleteEntries: context
                          .read<ItemListBloc>()
                          .getItemsSeenForCategory(state.activeCategory!));
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            const Expanded(
              child: TopicPage(),
            )
          ],
        ),
      ),
    );
  }
}
