class LocalAppState {
  LocalAppState({
    this.categoryForWhichItemsAreBeingAdded,
    this.numberToAdd = 1,
  });

  final String? categoryForWhichItemsAreBeingAdded;
  final int numberToAdd;
}
