import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_frontend/model/blocs/item_list_bloc.dart';
import 'package:shopping_list_frontend/model/itemList/item_list_events.dart';
import 'package:shopping_list_frontend/model/itemList/list_item.dart';
import 'package:shopping_list_frontend/model/state/item_list_state.dart';
import 'package:shopping_list_frontend/view/popups/confirmation_dialog.dart';
import 'package:shopping_list_frontend/view/tab_control.dart';
import 'package:shopping_list_frontend/view/popups/text_input_dialog.dart';

class MainPage extends StatefulWidget {
  const MainPage({required this.items, super.key});

  final ItemCategoryMap items;

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late StreamSubscription<bool> keyboardSubscription;
  bool keyboardHasJustClosed = false;

  TabController? _tabController;
  List<String> _tabs = [];

  void _addNewCategory() {
    getTextInputWithDialog(context, (newMainCategory) {
      if (newMainCategory.isNotEmpty) {
        // Add a placeholder item, so we still display the category correctly
        context.read<ItemListBloc>().add(
            AddItemEvent(Item.placeholderFromMainCategory(newMainCategory)));
      }
    });
  }

  void _deleteCurrentMainCategory() {
    final tabToDelete = _tabs.elementAt(_tabController!.index);
    showConfirmationDialog(context, "Delete $tabToDelete?").then(
      (proceedWithDelete) {
        if (proceedWithDelete == true) {
          // Delete the placeholder item, thus removing the main category
          context.read<ItemListBloc>().add(DeleteMainCategoryEvent(
                categoryToDelete: tabToDelete,
              ));
        }
      },
    );
  }

  void _refreshAllItems() {
    context.read<ItemListBloc>().add(UpdateAllItemsEvent());
  }

  // This has been copied from https://api.flutter.dev/flutter/widgets/NestedScrollView-class.html
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemListBloc, ItemListState>(
      buildWhen: (previous, current) {
        final equals = listEquals(
            previous.items.keys.toList(), current.items.keys.toList());
        return !equals;
      },
      builder: (context, state) {
        final items = state.items;
        final oldTabs = _tabs;
        _tabs = items.keys.toList();
        final tabBarElements =
            _tabs.map((String name) => Tab(text: name)).toList();
        _tabController =
            TabController(length: tabBarElements.length, vsync: this);

        if (oldTabs.length + 1 == _tabs.length) {
          _tabController!.animateTo(_tabs.length - 1);
        }

        return NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            // These are the slivers that show up in the "outer" scroll view.
            return <Widget>[
              SliverOverlapAbsorber(
                // This widget takes the overlapping behavior of the SliverAppBar,
                // and redirects it to the SliverOverlapInjector below. If it is
                // missing, then it is possible for the nested "inner" scroll view
                // below to end up under the SliverAppBar even when the inner
                // scroll view thinks it has not been scrolled.
                // This is not necessary if the "headerSliverBuilder" only builds
                // widgets that do not overlap the next sliver.
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  title: const Text('My lists'),
                  backgroundColor: Theme.of(context).primaryColor,
                  pinned: true,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: IconButton.outlined(
                          onPressed: _deleteCurrentMainCategory,
                          icon: const Icon(Icons.delete)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: IconButton.outlined(
                          onPressed: _addNewCategory,
                          icon: const Icon(Icons.add)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: IconButton.outlined(
                          color: Theme.of(context).primaryColor,
                          onPressed: _refreshAllItems,
                          icon: const Icon(Icons.refresh_rounded)),
                    ),
                  ],
                  // The "forceElevated" property causes the SliverAppBar to show
                  // a shadow. The "innerBoxIsScrolled" parameter is true when the
                  // inner scroll view is scrolled beyond its "zero" point, i.e.
                  // when it appears to be scrolled below the SliverAppBar.
                  // Without this, there are cases where the shadow would appear
                  // or not appear inappropriately, because the SliverAppBar is
                  // not actually aware of the precise position of the inner
                  // scroll views.
                  forceElevated: innerBoxIsScrolled,
                  bottom: TabBar(
                    isScrollable: true,
                    labelColor: Colors.black,
                    indicatorColor: Colors.lightBlue[300],
                    automaticIndicatorColorAdjustment: true,
                    controller: _tabController!,
                    // These are the widgets to put in each tab in the tab bar.
                    tabs: tabBarElements,
                  ),
                ),
              ),
            ];
          },
          body: TabControl(
            tabController: _tabController!,
            items: items,
            tabs: _tabs,
          ),
        );
      },
    );
  }
}
