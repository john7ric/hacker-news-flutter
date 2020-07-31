import 'package:hacker_news/src/models/item_model.dart';
import 'package:hacker_news/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class StoriesBloc {
  /// bloc for handling fetching top Ids and Story items
  final _topIds = PublishSubject<List<int>>();
  final _itemsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();
  final _itemsFetcher = PublishSubject<int>();

  //getter to streams
  Stream<List<int>> get topIds => _topIds.stream;
  Stream<Map<int, Future<ItemModel>>> get items => _itemsOutput.stream;

  //getters to sink
  Function(int) get fetchItem => _itemsFetcher.sink.add;
  _scanTransformer() {
    return ScanStreamTransformer(
        (Map<int, Future<ItemModel>> cache, int id, _) {
      cache[id] = Repository().fetchItem(id);
      return cache;
    }, <int, Future<ItemModel>>{});
  }

  fetchTopIds() async {
    final topIds = await Repository().fetchTopIds();
    _topIds.sink.add(topIds);
  }

  StoriesBloc() {
    _itemsFetcher.stream.transform(_scanTransformer()).pipe(_itemsOutput);
  }

  dispose() {
    _topIds.close();
    _itemsOutput.close();
    _itemsFetcher.close();
  }
}
