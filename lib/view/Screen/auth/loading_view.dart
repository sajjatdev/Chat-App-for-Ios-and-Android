import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loading_view extends StatelessWidget {
  static const String routeName = '/loading';

  static Route route() {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => Loading_view());
  }

  const Loading_view({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CupertinoActivityIndicator()),
    );
  }
}
