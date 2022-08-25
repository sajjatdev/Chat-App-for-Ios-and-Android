import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Terms extends StatefulWidget {
  static const String routeName = '/terms';

  static Route route() {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName), builder: (_) => Terms());
  }

  const Terms({Key key}) : super(key: key);

  @override
  _TermsState createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        title: Text(
          'Terms',
          style: TextStyle(color: Theme.of(context).iconTheme.color),
        ),
        elevation: 1,
        backgroundColor: Theme.of(context).secondaryHeaderColor,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Terms & Conditions",
                style: TextStyle(
                    fontSize: 21.sp,
                    color: Theme.of(context).iconTheme.color,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Last Updated: 2022-02-08",
                  style: TextStyle(color: Theme.of(context).iconTheme.color),
                )),
          ),
        ],
      ),
    );
  }
}
