enum ItemListStatus {
  ok,
  loading,
  unknownError,
  networkError,
  itemAlreadyInList,
  failedToAddItem,
  failedToRemoveItem
}

String statusToErrorMessage(ItemListStatus status) {
  switch (status) {
    case ItemListStatus.unknownError:
      return "Something went wrong... Sorry 😢";
    case ItemListStatus.networkError:
      return "Couldn't connect to server 🔎❌🖥️";
    case ItemListStatus.itemAlreadyInList:
      return "This item is already in the list.";
    case ItemListStatus.failedToAddItem:
      return "Something happened while trying to add the item to the list.";
    case ItemListStatus.failedToRemoveItem:
      return "Failed to remove item from the list.";
    case ItemListStatus.loading:
      return "Waiting for server reply";
    case ItemListStatus.ok:
      return "Everything is fine";
  }
}
