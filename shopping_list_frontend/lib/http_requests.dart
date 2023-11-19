import 'package:shopping_list_frontend/item_list_cubit.dart';
import 'package:shopping_list_frontend/shopping_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const backendUrl = 'http://localhost:3000';
const serverTimeout = Duration(seconds: 2);

final client = http.Client();

class RequestResult<T> {
  RequestResult({required this.statusCode, this.errorMessage, this.data});

  bool isOk() => statusCode == 200;

  final int statusCode;
  final String? errorMessage;
  final T? data;
}

Future<RequestResult<ItemCategoryMap>> fetchItems() async {
  try {
    final response = await http
        .get(Uri.parse('$backendUrl/get_items'))
        .timeout(serverTimeout);

    if (response.statusCode == 200) {
      List items = jsonDecode(response.body) as List;
      final decodedItems = items.map((e) => ShoppingItem.fromJson(e)).toList();
      final itemsMap = itemListToItemMap(decodedItems);
      return RequestResult(statusCode: response.statusCode, data: itemsMap);
    } else {
      return RequestResult(
          statusCode: response.statusCode, errorMessage: response.body);
    }
  } catch (e) {
    return RequestResult(statusCode: -1, errorMessage: e.toString());
  }
}

Future<int> addItem(ShoppingItem item) async {
  try {
    var body = json.encode(item.toJson());

    var response = await http.post(Uri.parse('$backendUrl/add_item'),
        headers: {"Content-Type": "application/json"}, body: body);

    return response.statusCode;
  } catch (e) {
    return -1;
  }
}

Future<int> removeItem(ShoppingItem item) async {
  try {
    var body = json.encode(item.toJson());

    var response = await http.post(Uri.parse('$backendUrl/delete_item'),
        headers: {"Content-Type": "application/json"}, body: body);

    return response.statusCode;
  } catch (e) {
    return -1;
  }
}
