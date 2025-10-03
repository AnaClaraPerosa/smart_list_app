import 'package:flutter/material.dart';
import '../models/item.dart';

class ItemTile extends StatelessWidget {
  final Item item;

  ItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name),
      subtitle: Text("Quantidade: ${item.quantity}"),
      trailing: Icon(
        item.purchased ? Icons.check_box : Icons.check_box_outline_blank,
        color: item.purchased ? Colors.green : null,
      ),
    );
  }
}
