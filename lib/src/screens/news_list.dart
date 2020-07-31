import 'package:flutter/material.dart';
import 'package:hacker_news/src/blocs/stories_bloc.dart';
import 'package:provider/provider.dart';

class NewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = StoriesBloc();
    bloc.fetchTopIds();
    return Scaffold(
      body: Container(
        child: buildList(bloc),
      ),
    );
  }
}

Widget buildList(StoriesBloc bloc) {
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
                    child:
                        Text('item ID fetched is  : ${snapshot.data[index]} '),
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
