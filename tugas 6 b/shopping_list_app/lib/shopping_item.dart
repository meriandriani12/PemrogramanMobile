enum ShoppingCategory {
  food,
  drink,
  electronics,
  other,
}

class ShoppingItem {
  final String name;
  final int quantity;
  final ShoppingCategory category;
  bool isPurchased;

  ShoppingItem({
    required this.name,
    required this.quantity,
    required this.category,
    this.isPurchased = false,
  });

  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      name: json['name'],
      quantity: json['quantity'],
      category: ShoppingCategory.values[json['category']],
      isPurchased: json['isPurchased'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'category': category.index,
      'isPurchased': isPurchased,
    };
  }
}
