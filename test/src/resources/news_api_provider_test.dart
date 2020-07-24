import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:hacker_news/src/resources/news_api_provider.dart';

main() {
  test('Test of fetchTopIds returning a list of IDS', () async {
    final newsApiProvider = NewsApiProvider();
    newsApiProvider.client = MockClient((Request r) async {
      expect(r.url.toString(),
          'https://hacker-news.firebaseio.com/v0/maxitem.json');
      // ignore: await_only_futures
      return await Response(json.encode([1, 2, 3, 4, 5]), 200);
    });

    final response = await newsApiProvider.getTopItems();
    expect(response, [1, 2, 3, 4, 5]);
  });

  test('Tests of the fetchItem call returns an Item with id key', () async {
    NewsApiProvider newsApiProvider = NewsApiProvider();
    newsApiProvider.client = MockClient((r) async {
      expect(r.url.toString(),
          'https://hacker-news.firebaseio.com/v0/item/999.json');
      final responseMap = {'id': 123};
      // ignore: await_only_futures
      final response = await Response(json.encode(responseMap), 200);
      return response;
    });

    final item = await newsApiProvider.getItemDetails(999);
    expect(item.id, 123);
  });
}
