import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:shopping_list_frontend/model/itemList/list_item.dart';

const port = kReleaseMode ? '12568' : '3000';

Uri getBackendUrl(String endpoint) {
  if (kReleaseMode) {
    return Uri.parse('http://10.8.0.1:$port/$endpoint');
  }

  final baseUrl = (Platform.isAndroid || Platform.isIOS)
      ? 'http://10.0.2.2:$port' // This is the emulator's "localhost"
      : 'http://localhost:$port';

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
      final responseMap =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      final itemsJson = responseMap["items"] as List;
      final itemsSeenJson = responseMap["items_seen"] as List;

      final decodedItems = itemsJson.map((e) => Item.fromJson(e)).toList();
      final itemsMap = itemListToItemMap(decodedItems);

      final decodedItemsSeen =
          itemsSeenJson.map((e) => ItemWithoutQuantity.fromJson(e)).toList();
      final itemsSeenMap = itemsSeenToItemsSeenMap(decodedItemsSeen);

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

Future<int> addItem(Item item) async {
  try {
    var body = json.encode(item.toJson());

    var response = await http
        .post(getBackendUrl('add_item'),
            headers: {"Content-Type": "application/json"}, body: body)
        .timeout(serverTimeout);

    return response.statusCode;
  } catch (e) {
    return -1;
  }
}

Future<int> removeItem(Item item) async {
  try {
    var body = json.encode(item.toJson());

    var response = await http
        .post(getBackendUrl('delete_item'),
            headers: {"Content-Type": "application/json"}, body: body)
        .timeout(serverTimeout);

    return response.statusCode;
  } catch (e) {
    return -1;
  }
}
