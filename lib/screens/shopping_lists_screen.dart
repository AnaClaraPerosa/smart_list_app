import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/item.dart';
import 'profile_screen.dart';

class ShoppingListsScreen extends StatefulWidget {
  final ApiService api;
  ShoppingListsScreen({required this.api});

  @override
  State<ShoppingListsScreen> createState() => _ShoppingListsScreenState();
}

class _ShoppingListsScreenState extends State<ShoppingListsScreen> {
  List<dynamic> _lists = [];
  bool _loading = false;
  final _listController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchLists();
  }

  void _fetchLists() async {
    setState(() => _loading = true);
    final lists = await widget.api.getShoppingLists();
    setState(() {
      _lists = lists;
      _loading = false;
    });
  }

  void _addList() async {
    final name = _listController.text.trim();
    if (name.isEmpty) return;
    final success = await widget.api.createShoppingList(name);
    if (success) {
      _listController.clear();
      _fetchLists();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Falha ao criar lista")));
    }
  }

  void _editList(int id, String currentName) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Editar Lista"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isEmpty) return;
              final success = await widget.api.editShoppingList(id, newName);
              if (success) _fetchLists();
              Navigator.pop(context);
            },
            child: Text("Salvar"),
          )
        ],
      ),
    );
  }

  void _deleteList(int id) async {
    final success = await widget.api.deleteShoppingList(id);
    if (success) _fetchLists();
  }

  void _openItems(int listId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ItemsScreen(api: widget.api, shoppingListId: listId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Suas Listas de Compras",
            style: TextStyle(
              color: Colors.blue[800],
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: Colors.blue[800]),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfileScreen(api: widget.api),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _listController,
                    decoration: InputDecoration(
                      labelText: "Novo Item",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addList,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, // Cor do texto
                    backgroundColor: Colors.blue,   // Cor de fundo do botão
                  ),
                  child: Text("Adicionar"),
                ),
              ],
            ),
            SizedBox(height: 20),
            _loading
                ? CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _lists.length,
                      itemBuilder: (context, index) {
                        final item = _lists[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(
                              item['name'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue[700],
                              ),
                            ),
                            onTap: () => _openItems(item['id']),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.orange),
                                  onPressed: () =>
                                      _editList(item['id'], item['name']),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteList(item['id']),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

// ItemsScreen estilizado
class ItemsScreen extends StatefulWidget {
  final ApiService api;
  final int shoppingListId;
  ItemsScreen({required this.api, required this.shoppingListId});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  List<Item> _items = [];
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  void _fetchItems() async {
    setState(() => _loading = true);
    final items = await widget.api.getItems(widget.shoppingListId);
    setState(() {
      _items = items;
      _loading = false;
    });
  }

  void _addItem() async {
    final name = _nameController.text.trim();
    final quantity = int.tryParse(_quantityController.text) ?? 1;
    if (name.isEmpty) return;
    final item =
        await widget.api.createItem(widget.shoppingListId, name, quantity);
    if (item != null) {
      _nameController.clear();
      _quantityController.clear();
      _fetchItems();
    }
  }

  void _togglePurchased(Item item) async {
    final success = await widget.api.togglePurchased(widget.shoppingListId, item);
    if (success) _fetchItems();
  }

  void _editItem(Item item) {
    _nameController.text = item.name;
    _quantityController.text = item.quantity.toString();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Editar Item"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Nome"),
            ),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: "Quantidade"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text("Cancelar")),
          ElevatedButton(
            onPressed: () async {
              final newName = _nameController.text.trim();
              final newQty = int.tryParse(_quantityController.text) ?? item.quantity;
              final success =
                  await widget.api.editItem(widget.shoppingListId, item, newName, newQty);
              if (success) _fetchItems();
              Navigator.pop(context);
            },
            child: Text("Salvar"),
          ),
        ],
      ),
    );
  }

  void _deleteItem(Item item) async {
    final success = await widget.api.deleteItem(widget.shoppingListId, item.id);
    if (success) _fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Itens da Lista",
            style: TextStyle(
              color: Colors.blue[800],
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Nome do item",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: 60,
                  child: TextField(
                    controller: _quantityController,
                    decoration: InputDecoration(
                      labelText: "Qtd",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addItem,
                  child: Text("Adicionar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 22, 79, 150),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            _loading
                ? CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(
                              item.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue[700],
                              ),
                            ),
                            subtitle: Text("Quantidade: ${item.quantity}"),
                            leading: Checkbox(
                              value: item.purchased,
                              onChanged: (_) => _togglePurchased(item),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    icon: Icon(Icons.edit, color: Colors.orange),
                                    onPressed: () => _editItem(item)),
                                IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _deleteItem(item)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
