import 'package:hacker_news/src/models/item_model.dart';
import 'package:hacker_news/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class CommentsBloc {
  final _commentsFetcher = PublishSubject<int>();
  final _commentsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();
  final _repository = Repository();

  //sinks
  Function(int) get fetchItemWithComments => _commentsFetcher.sink.add;

  //streams
  Stream<Map<int, Future<ItemModel>>> get itemWithComments =>
      _commentsOutput.stream;

  /// scanstreamtransformer to returns recursively fetched data
  _commentsTransformer() {
    return ScanStreamTransformer<int, Map<int, Future<ItemModel>>>(
        (cache, int id, index) {
      print('comments transformer called $index times');
      cache[id] = _repository.fetchItem(id);
      cache[id].then((ItemModel model) {
        model.kids?.forEach((kidId) {
          fetchItemWithComments(kidId);
        });
      });
      return cache;
    }, <int, Future<ItemModel>>{});
  }

  CommentsBloc() {
    _commentsFetcher.stream
        .transform(_commentsTransformer())
        .pipe(_commentsOutput);
  }

  dispose() {
    _commentsFetcher.close();
    _commentsOutput.close();
  }
}
