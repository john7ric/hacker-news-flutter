import 'package:flutter/material.dart';
import 'package:hacker_news/src/models/item_model.dart';
import 'package:hacker_news/src/widgets/loading_container.dart';

class Comment extends StatelessWidget {
  /// comment widget to show single comment object
  /// which inturn recursively renders its children

  Comment(
      {@required this.itemId, @required this.cacheMap, @required this.depth});

  final Map<int, Future<ItemModel>> cacheMap;
  final int itemId;
  final int depth;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: cacheMap[itemId],
        builder: (context, AsyncSnapshot<ItemModel> snapshot) {
          if (!snapshot.hasData) {
            return LoadingView();
          }
          final item = snapshot.data;
          final List<Widget> children = [
            ListTile(
              contentPadding:
                  EdgeInsets.only(left: (depth * 16.0), right: 16.0),
              title: item.text == '' ? Text('deleted') : Text('${item.text}'),
              subtitle: item.by != '' ? Text('${item.by}') : Text(''),
            )
          ];

          ///recursive rendering sets of rendering the same loop inside all kid comments
          ///to produce a nested list of comment threads

          snapshot.data.kids?.forEach((kidId) {
            final comment = Comment(
              itemId: kidId,
              cacheMap: cacheMap,
              depth: (depth + 1),
            );
            children.add(comment);
          });
          return Column(
            children: children,
          );
        },
      ),
    );
  }
}
