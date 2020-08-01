import 'dart:convert';

import 'package:hacker_news/src/models/item_model.dart';
import 'package:hacker_news/src/resources/repository.dart';
import 'package:http/http.dart' show Client;

final _root = 'https://hacker-news.firebaseio.com/v0';

class NewsApiProvider implements Source {
  /// API classs for hacker news data calls
  Client client = Client();

  Future<List<int>> fetchTopIds() async {
    /// get top items id list
    final response = await client.get('$_root/topstories.json');
    final ids = json.decode(response.body);
    return List<int>.from(ids);
  }

  Future<ItemModel> fetchItem(int id) async {
    /// get details of an item
    print('api is called for => $id');
    final response = await client.get('$_root/item/$id.json');
    final parsedJson = json.decode(response.body);
    return ItemModel.fromJSON(parsedJson);
  }
}
