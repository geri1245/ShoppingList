class LocalAppState {
  LocalAppState({
    this.activeCategory,
    this.numberToAdd = 1,
  });

  final String? activeCategory;
  final int numberToAdd;
}
