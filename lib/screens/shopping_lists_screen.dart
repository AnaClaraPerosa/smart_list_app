import 'package:flutter/material.dart';
import 'package:smart_list_app/screens/items_screen.dart';
import '../services/api_service.dart';
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
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: "Nome da lista",
            border: OutlineInputBorder(),
          ),
        ),
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
          ),
        ],
      ),
    );
  }

  void _deleteList(int id) async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Excluir Lista"),
        content: Text("Tem certeza que deseja excluir esta lista?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Excluir", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await widget.api.deleteShoppingList(id);
      if (success) _fetchLists();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.list_alt_rounded, color: Colors.blue[900], size: 28),
            SizedBox(width: 8),
            Text(
              "SmartList",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Colors.blue[900],
                fontFamily: "Roboto",
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: Colors.blue[900]),
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
            /// CAMPO + BOTÃO ADICIONAR (mais bonito)
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _listController,
                      decoration: InputDecoration(
                        labelText: "Nova Lista",
                        labelStyle: TextStyle(color: Colors.blue[900]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _addList,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Adicionar",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),

            SizedBox(height: 20),

            /// LISTA
            _loading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: _lists.length,
                      itemBuilder: (context, index) {
                        final item = _lists[index];

                        return Card(
                          elevation: 2,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),

                            /// ÍCONE SACOLINHA
                            leading: Icon(
                              Icons.shopping_bag,
                              size: 30,
                              color: Colors.blue[800],
                            ),

                            title: Text(
                              item['name'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue[900],
                              ),
                            ),

                            onTap: () {
                              // abre os itens
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ItemsScreen(
                                    api: widget.api,
                                    shoppingListId: item['id'],
                                  ),
                                ),
                              );
                            },

                            /// BOTÕES EDITAR / EXCLUIR
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.orange),
                                  onPressed: () => _editList(item['id'], item['name']),
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
