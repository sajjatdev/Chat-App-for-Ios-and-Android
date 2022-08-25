import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Feed_Home extends StatefulWidget {
  static const String routeName = '/Feed_Home';

  static Route route() {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName), builder: (_) => Feed_Home());
  }

  const Feed_Home({Key key}) : super(key: key);

  @override
  State<Feed_Home> createState() => _Feed_HomeState();
}

class _Feed_HomeState extends State<Feed_Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            "Post",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 21.sp,
                color: Theme.of(context).iconTheme.color),
          )),
          body: CustomScrollView(slivers: [SliverAppBar( automaticallyImplyLeading: false,
          title: Text(
            "Post",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 21.sp,
                color: Theme.of(context).iconTheme.color),
          ))]),
    );
  }
}
