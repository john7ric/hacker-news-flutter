import 'package:flutter/material.dart';
import 'package:hacker_news/src/blocs/comments_bloc.dart';
import 'package:hacker_news/src/models/item_model.dart';
import 'package:hacker_news/src/widgets/comment.dart';
import 'package:hacker_news/src/widgets/loading_container.dart';
import 'package:provider/provider.dart';

class NewsDetail extends StatelessWidget {
  final int itemId;

  NewsDetail({@required this.itemId});

  @override
  Widget build(BuildContext context) {
    CommentsBloc bloc = Provider.of<CommentsBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail page'),
      ),
      body: StreamBuilder(
        stream: bloc.itemWithComments,
        builder:
            (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
          if (!snapshot.hasData) {
            return LoadingView();
          }
          return FutureBuilder(
            future: snapshot.data[itemId],
            builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
              if (!itemSnapshot.hasData) {
                return LoadingView();
              }

              return buildListView(itemSnapshot.data, snapshot.data);
            },
          );
        },
      ),
    );
  }

  ListView buildListView(
      ItemModel storyItem, Map<int, Future<ItemModel>> cachemap) {
    final List<Widget> children = [buildTitle(storyItem)];
    final comments = storyItem.kids?.map((kidId) {
      return Comment(
        itemId: kidId,
        cacheMap: cachemap,
        depth: 1,
      );
    });
    children.addAll(comments);
    return ListView(
      children: children,
    );
  }

  Container buildTitle(ItemModel storyItem) {
    return Container(
      alignment: Alignment.topCenter,
      child: Text(
        '${storyItem.title}',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
