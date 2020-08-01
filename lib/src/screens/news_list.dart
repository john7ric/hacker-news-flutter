import 'package:flutter/material.dart';
import 'package:hacker_news/src/blocs/stories_bloc.dart';
import 'package:hacker_news/src/widgets/list_item.dart';
import 'package:provider/provider.dart';

class NewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, StoriesBloc bloc, child) {
          bloc.fetchTopIds();
          return Container(
            child: buildList(bloc),
          );
        },
      ),
    );
  }
}

Widget buildList(StoriesBloc bloc) {
  /// builds a list from fetched ids
  /// loads each tile by feching item for ids
  ///
  return StreamBuilder(
      stream: bloc.topIds,
      builder: (context, AsyncSnapshot<List<int>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(30),
                  child: Container(
                    width: double.infinity,
                    child: ListItem(snapshot.data[index]),
                  ),
                );
              });
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      });
}
