import 'package:flutter/material.dart';
import 'package:shopping_list_frontend/model/itemList/list_item.dart';
import 'package:shopping_list_frontend/view/item_tab.dart';

class TabControl extends StatelessWidget {
  const TabControl(
      {required this.tabController,
      required this.items,
      required this.tabs,
      super.key});

  final TabController tabController;
  final ItemCategoryMap items;
  final List<String> tabs;

  @override
  Widget build(BuildContext context) {
    if (tabs.isEmpty) {
      return Center(
        child: Image.asset(
          "images/travolta.gif",
          height: 240.0,
          width: 240.0,
        ),
      );
    }
    return TabBarView(
      controller: tabController,
      children: tabs.map((String tabName) {
        return SafeArea(
          top: false,
          bottom: false,
          child: Builder(
            // This Builder is needed to provide a BuildContext that is
            // "inside" the NestedScrollView, so that
            // sliverOverlapAbsorberHandleFor() can find the
            // NestedScrollView.
            builder: (BuildContext context) {
              return CustomScrollView(
                // The "controller" and "primary" members should be left
                // unset, so that the NestedScrollView can control this
                // inner scroll view.
                // If the "controller" property is set, then this scroll
                // view will not be associated with the NestedScrollView.
                // The PageStorageKey should be unique to this ScrollView;
                // it allows the list to remember its scroll position when
                // the tab view is not on the screen.
                key: PageStorageKey<String>(tabName),
                slivers: <Widget>[
                  SliverOverlapInjector(
                    // This is the flip side of the SliverOverlapAbsorber
                    // above.
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                  ),
                  // Placeholder, theoretically this will be displayed if the "Add new item" tab is selected
                  // but that tab should never be really be "selected", as it's just a button
                  if (!items.keys.contains(tabName))
                    const SliverToBoxAdapter(
                        child: Text("This tab seems to be empty..."))
                  else
                    SliverPadding(
                      padding: const EdgeInsets.all(8.0),
                      sliver: ItemTab(
                        mainCategoryName: tabName,
                      ),
                    ),
                ],
              );
            },
          ),
        );
      }).toList(),
    );
  }
}
