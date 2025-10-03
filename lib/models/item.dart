class Item {
  final int id;
  final String name;
  final int quantity;
  bool purchased;

  Item({
    required this.id,
    required this.name,
    required this.quantity,
    required this.purchased,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'] ?? 1,
      purchased: json['purchased'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "quantity": quantity,
        "purchased": purchased,
      };
}
