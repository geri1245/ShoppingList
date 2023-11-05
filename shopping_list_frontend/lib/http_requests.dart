import 'package:shopping_list_frontend/shopping_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<ShoppingItem>> fetchItems() async {
  final response = await http.get(Uri.parse('http://localhost:3000/get_items'));

  if (response.statusCode == 200) {
    List items = jsonDecode(response.body) as List;
    var decodedItems = items.map((e) => ShoppingItem.fromJson(e)).toList();
    return decodedItems;
  } else {
    throw Exception('Failed to load items');
  }
}

Future<int> addItem(ShoppingItem item) async {
  var body = json.encode(item.toJson());

  var response = await http.post(Uri.parse('http://localhost:3000/add_item'),
      headers: {"Content-Type": "application/json"}, body: body);

  return response.statusCode;
}

Future<int> removeItem(ShoppingItem item) async {
  var body = json.encode(item.toJson());

  var response = await http.post(Uri.parse('http://localhost:3000/delete_item'),
      headers: {"Content-Type": "application/json"}, body: body);

  return response.statusCode;
}
