class ShoppingItem {
  const ShoppingItem({required this.itemName, required this.count});

  final String itemName;
  final int count;

  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      itemName: json['name'] as String,
      count: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {"name": itemName, "quantity": count};
  }
}
