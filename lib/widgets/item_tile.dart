import 'package:flutter/material.dart';
import '../models/item.dart';

class ItemTile extends StatelessWidget {
  final Item item;
  final VoidCallback onToggle;

  ItemTile({
    required this.item,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onToggle,
      title: Text(
        item.name,
        style: TextStyle(
          decoration: item.purchased ? TextDecoration.lineThrough : null,
          color: item.purchased ? Colors.grey : Colors.black,
        ),
      ),
      subtitle: Text("Qtd: ${item.quantity}"),
      trailing: Checkbox(
        value: item.purchased,
        onChanged: (_) {
          onToggle();
        },
      ),
    );
  }
}
