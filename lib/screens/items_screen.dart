import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/item.dart';
import '../widgets/item_tile.dart';

class ItemsScreen extends StatefulWidget {
  final ApiService api;
  final int shoppingListId;

  ItemsScreen({required this.api, required this.shoppingListId});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  List<Item> _items = [];
  bool _loading = true;

  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();

  void _loadItems() async {
    setState(() => _loading = true);
    final data = await widget.api.getItems(widget.shoppingListId);
    setState(() {
      _items = data;
      _loading = false;
    });
  }

  void _addItem() async {
    final name = _nameController.text.trim();
    final quantity = int.tryParse(_quantityController.text.trim()) ?? 1;

    if (name.isEmpty) return;

    final newItem = await widget.api.createItem(widget.shoppingListId, name, quantity);
    if (newItem != null) {
      setState(() => _items.add(newItem));
      _nameController.clear();
      _quantityController.clear();
      Navigator.pop(context);
    }
  }

  void _togglePurchased(Item item) async {
    final success = await widget.api.togglePurchased(widget.shoppingListId, item);
    if (success) {
      setState(() => item.purchased = !item.purchased);
    }
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Adicionar Item"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: "Nome")),
            TextField(controller: _quantityController, decoration: InputDecoration(labelText: "Quantidade"), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancelar")),
          ElevatedButton(onPressed: _addItem, child: Text("Adicionar")),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Itens da Lista"),
        actions: [IconButton(icon: Icon(Icons.refresh), onPressed: _loadItems)],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (_, index) {
                final item = _items[index];
                return GestureDetector(
                  onTap: () => _togglePurchased(item),
                  child: ItemTile(item: item),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
