import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/item.dart';

class ApiService {
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:3000',
  );

  String? accessToken;
  String? client;
  String? uid;

  // LOGIN
  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/sign_in'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      accessToken = response.headers['access-token'];
      client = response.headers['client'];
      uid = response.headers['uid'];
      return true;
    }
    return false;
  }

  Map<String, String> get authHeaders => {
        "access-token": accessToken ?? "",
        "client": client ?? "",
        "uid": uid ?? "",
        "Content-Type": "application/json",
      };

  // SIGNUP
  Future<bool> signup(String email, String password, String passwordConfirmation) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation
      }),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  // LOGOUT
  Future<bool> logout() async {
    final response = await http.delete(
      Uri.parse('$baseUrl/auth/sign_out'),
      headers: authHeaders,
    );
    if (response.statusCode == 200 || response.statusCode == 204) {
      // limpa tokens
      accessToken = null;
      client = null;
      uid = null;
      return true;
    }
    return false;
  }

  // ATUALIZAR USUÁRIO
  Future<bool> updateUser({String? email, String? password, String? passwordConfirmation}) async {
    final body = <String, String>{};
    if (email != null) body['email'] = email;
    if (password != null) body['password'] = password;
    if (passwordConfirmation != null) body['password_confirmation'] = passwordConfirmation;

    final response = await http.put(
      Uri.parse('$baseUrl/auth'),
      headers: authHeaders,
      body: jsonEncode(body),
    );
    return response.statusCode == 200;
  }

  // DELETAR USUÁRIO
  Future<bool> deleteUser() async {
    final response = await http.delete(
      Uri.parse('$baseUrl/auth'),
      headers: authHeaders,
    );
    if (response.statusCode == 200 || response.statusCode == 204) {
      accessToken = null;
      client = null;
      uid = null;
      return true;
    }
    return false;
  }


  // SHOPPING LISTS
  Future<List> getShoppingLists() async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/v1/shopping_lists"),
      headers: authHeaders,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  Future<bool> createShoppingList(String name) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/v1/shopping_lists"),
      headers: authHeaders,
      body: jsonEncode({"name": name}),
    );
    return response.statusCode == 201;
  }

  Future<bool> deleteShoppingList(int id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/api/v1/shopping_lists/$id"),
      headers: authHeaders,
    );
    return response.statusCode == 204;
  }

  Future<bool> editShoppingList(int id, String name) async {
    final response = await http.put(
      Uri.parse("$baseUrl/api/v1/shopping_lists/$id"),
      headers: authHeaders,
      body: jsonEncode({"name": name}),
    );
    return response.statusCode == 200;
  }

  // ITENS
  Future<List<Item>> getItems(int shoppingListId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/v1/shopping_lists/$shoppingListId/items"),
      headers: authHeaders,
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Item.fromJson(e)).toList();
    }
    return [];
  }

  Future<Item?> createItem(int shoppingListId, String name, int quantity) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/v1/shopping_lists/$shoppingListId/items"),
      headers: authHeaders,
      body: jsonEncode({"item": {"name": name, "quantity": quantity}}),
    );

    if (response.statusCode == 201) {
      return Item.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<bool> editItem(int shoppingListId, Item item, String newName, int newQuantity) async {
    final response = await http.put(
      Uri.parse("$baseUrl/api/v1/shopping_lists/$shoppingListId/items/${item.id}"),
      headers: authHeaders,
      body: jsonEncode({"item": {"name": newName, "quantity": newQuantity}}),
    );
    return response.statusCode == 200;
  }

  Future<bool> togglePurchased(int shoppingListId, Item item) async {
    final response = await http.put(
      Uri.parse("$baseUrl/api/v1/shopping_lists/$shoppingListId/items/${item.id}"),
      headers: authHeaders,
      body: jsonEncode({"item": {"purchased": !item.purchased}}),
    );

    return response.statusCode == 200;
  }

  Future<bool> deleteItem(int shoppingListId, int itemId) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/api/v1/shopping_lists/$shoppingListId/items/$itemId"),
      headers: authHeaders,
    );
    return response.statusCode == 204;
  }
}
