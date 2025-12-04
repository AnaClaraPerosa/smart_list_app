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
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.checklist, color: Colors.blue, size: 26),
            SizedBox(width: 8),
            Text(
              "Sua Lista",
              style: TextStyle(
                color: Colors.blue[900],
                fontWeight: FontWeight.bold,
                fontSize: 24,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.blue),
            onPressed: _loadItems,
          ),
        ],
        iconTheme: IconThemeData(color: Colors.blue),
      ),

      body: _loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return ItemTile(
                  item: _items[index],
                  onToggle: () => _togglePurchased(_items[index]),
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
