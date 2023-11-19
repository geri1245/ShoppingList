class ShoppingItem {
  const ShoppingItem(
      {required this.category, required this.itemName, required this.count});

  final String category;
  final String itemName;
  final int count;

  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      category: json['category'] as String,
      itemName: json['name'] as String,
      count: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {"name": itemName, "quantity": count, "category": category};
  }
}
