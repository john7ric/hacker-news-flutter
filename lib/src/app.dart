import 'package:flutter/material.dart';
import 'package:hacker_news/src/blocs/stories_bloc.dart';
import 'package:hacker_news/src/screens/news_list.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => StoriesBloc(),
      child: MaterialApp(
        title: 'News',
        home: NewsList(),
      ),
    );
  }
}
