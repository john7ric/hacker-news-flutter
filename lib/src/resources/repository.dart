import 'package:hacker_news/src/models/item_model.dart';

import 'news_api_provider.dart';
import 'news_db_provider.dart';

class Repository {
  /// repository class for handling items fetching

  List<Source> sources = [newsDBProvider, NewsApiProvider()];
  List<Cache> caches = [newsDBProvider];

  Future<List<int>> fetchTopIds() {
    /// proxy fetch top id call to api provider
    /// as there is no caching
    return sources[1].fetchTopIds();
  }

  Future<ItemModel> fetchItem(int id) async {
    ///checking if item already cached inside db else
    /// fetches and return the item and also store in
    /// to the sqlite instance
    var source;
    var item;
    for (source in sources) {
      item = await source.fetchItem(id);
      if (item != null) {
        break;
      }
    }

    for (var cache in caches) {
      if (cache != source) {
        cache.addItem(item);
      }
    }
    return item;
  }

  clearCache() async {
    for (var cache in caches) {
      await cache.clearCache();
    }
  }
}

abstract class Source {
  Future<ItemModel> fetchItem(int id);
  Future<List<int>> fetchTopIds();
}

abstract class Cache {
  Future<int> addItem(ItemModel item);
  Future<int> clearCache();
}
