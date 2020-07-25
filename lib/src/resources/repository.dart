import 'news_api_provider.dart';
import 'news_db_provider.dart';

class Repository {
  /// repository class for handling items fetching

  NewsApiProvider apiProvider = NewsApiProvider();
  NewsDbProvider dbProvider = NewsDbProvider();

  fetchTopIds() {
    /// proxy fetch top id call to api provider
    /// as there is no caching
    return apiProvider.getTopItems();
  }

  fetchItem(int id) {
    ///checking if item already cached inside db else
    /// fetches and returnd the item and also store in
    /// to the sqlite instance
    var item = dbProvider.fetchItem(id);
    if (item != null) {
      return item;
    }
    item = apiProvider.getItemDetails(id);
    dbProvider.addItem(item);
    return item;
  }
}
