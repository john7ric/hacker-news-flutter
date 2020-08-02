import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: buildContainer(),
          subtitle: buildContainer(),
        ),
      ],
    );
  }

  Container buildContainer() => Container(
        color: Colors.grey[200],
        height: 24.0,
        margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
      );
}
