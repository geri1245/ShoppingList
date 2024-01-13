import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:shopping_list_frontend/data/itemList/shopping_item.dart';

Uri getBackendUrl(String endpoint) {
  final baseUrl = (Platform.isAndroid || Platform.isIOS)
      ? 'http://10.0.2.2:3000'
      : 'http://localhost:3000';

  return Uri.parse("$baseUrl/$endpoint");
}

const serverTimeout = Duration(seconds: 2);

final client = http.Client();

class Response {
  Response({required this.items, required this.itemsSeen});

  ItemCategoryMap items;
  CategoryToItemsSeenMap itemsSeen;
}

class RequestResult<T> {
  RequestResult({required this.statusCode, this.errorMessage, this.data});

  bool isOk() => statusCode == 200;

  final int statusCode;
  final String? errorMessage;
  final T? data;
}

Future<RequestResult<Response>> fetchItems() async {
  try {
    final response =
        await http.get(getBackendUrl('get_items')).timeout(serverTimeout);

    if (response.statusCode == 200) {
      final responseMap = jsonDecode(response.body) as Map<String, dynamic>;
      final itemsJson = responseMap["items"] as List;
      final itemsSeenJson = responseMap["items_seen"] as Map<String, dynamic>;

      final decodedItems =
          itemsJson.map((e) => ShoppingItem.fromJson(e)).toList();
      final itemsMap = itemListToItemMap(decodedItems);
      CategoryToItemsSeenMap itemsSeenMap = {};

      for (var entry in itemsSeenJson.entries) {
        itemsSeenMap[entry.key] =
            (entry.value as List<dynamic>).map((e) => e.toString()).toList();
      }

      return RequestResult(
          statusCode: response.statusCode,
          data: Response(items: itemsMap, itemsSeen: itemsSeenMap));
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

    var response = await http.post(getBackendUrl('add_item'),
        headers: {"Content-Type": "application/json"}, body: body);

    return response.statusCode;
  } catch (e) {
    return -1;
  }
}

Future<int> removeItem(ShoppingItem item) async {
  try {
    var body = json.encode(item.toJson());

    var response = await http.post(getBackendUrl('delete_item'),
        headers: {"Content-Type": "application/json"}, body: body);

    return response.statusCode;
  } catch (e) {
    return -1;
  }
}
