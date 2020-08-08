import 'package:flutter/material.dart';
import 'package:hacker_news/src/blocs/stories_bloc.dart';
import 'package:hacker_news/src/models/item_model.dart';
import 'package:hacker_news/src/widgets/loading_container.dart';
import 'package:provider/provider.dart';

class ListItem extends StatelessWidget {
  final int id;
  ListItem(this.id);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, StoriesBloc bloc, _) {
        bloc.fetchItem(id);
        return StreamBuilder(
          stream: bloc.items,
          builder:
              (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
            if (snapshot.hasData) {
              return FutureBuilder(
                future: snapshot.data[id],
                builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
                  if (!itemSnapshot.hasData) {
                    return LoadingView();
                  }

                  ItemModel item = itemSnapshot.data;
                  return ListTile(
                    onTap: () => Navigator.pushNamed(context, '/${item.id}'),
                    title: Text('${item.title}'),
                    subtitle: Text('${item.score} votes'),
                    trailing: Column(
                      children: <Widget>[
                        Icon(Icons.comment),
                        Text('${item.descendants}')
                      ],
                    ),
                  );
                },
              );
            } else {
              return LoadingView();
            }
          },
        );
      },
    );
  }
}
