import 'package:flutter/material.dart';
import 'package:hacker_news/src/blocs/stories_bloc.dart';
import 'package:provider/provider.dart';

class RefreshControl extends StatelessWidget {
  final Widget child;
  RefreshControl({this.child});
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, StoriesBloc bloc, _) {
        return RefreshIndicator(
          child: child,
          onRefresh: () async {
            await bloc.clearCache();
            await bloc.fetchTopIds();
          },
        );
      },
    );
  }
}
