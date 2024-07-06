class AddingItemsControlState {
  AddingItemsControlState({
    this.activeMainCategory,
    this.activeSubCategory,
    this.numberToAdd = 1,
  });

  final String? activeMainCategory;
  final String? activeSubCategory;
  final int numberToAdd;
}
