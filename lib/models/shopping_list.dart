class ShoppingList {
  final int id;
  final String name;

  ShoppingList({required this.id, required this.name});

  factory ShoppingList.fromJson(Map<String, dynamic> json) {
    return ShoppingList(
      id: json['id'],
      name: json['name'],
    );
  }
}
