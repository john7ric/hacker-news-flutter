import 'package:flutter/material.dart';
import 'package:hacker_news/src/blocs/comments_bloc.dart';
import 'package:hacker_news/src/blocs/stories_bloc.dart';
import 'package:hacker_news/src/screens/news_detail.dart';
import 'package:hacker_news/src/screens/news_list.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<StoriesBloc>(create: (context) => StoriesBloc()),
        Provider<CommentsBloc>(create: (context) => CommentsBloc())
      ],
      child: MaterialApp(
        title: 'News',
        home: NewsList(),
        onGenerateRoute: routes,
      ),
    );
  }

  Route routes(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(
        builder: (context) {
          // StoriesBloc bloc = Provider.of<StoriesBloc>(context);
          // bloc.fetchTopIds();
          return NewsList();
        },
      );
    } else {
      int itemId = int.parse(settings.name.replaceFirst("/", ''));
      return MaterialPageRoute(
        builder: (context) {
          CommentsBloc bloc = Provider.of<CommentsBloc>(context);
          bloc.fetchItemWithComments(itemId);
          return NewsDetail(itemId: itemId);
        },
      );
    }
  }
}
