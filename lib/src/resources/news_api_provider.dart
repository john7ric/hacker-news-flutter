import 'dart:convert';

import 'package:hacker_news/src/models/item_model.dart';
import 'package:http/http.dart' show Client;

final _root = 'https://hacker-news.firebaseio.com/v0';

class NewsApiProvider {
  /// API classs for hacker news data calls
  Client client = Client();

  getTopItems() async {
    /// get top items id list
    final response = await client.get('$_root/maxitem.json');
    final ids = json.decode(response.body);
    return ids;
  }

  getItemDetails(int id) async {
    /// get details of an item

    final response = await client.get('$_root/item/$id.json');
    final parsedJson = json.decode(response.body);
    return ItemModel.fromJSON(parsedJson);
  }
}
