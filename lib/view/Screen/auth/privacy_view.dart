import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:sizer/sizer.dart';

class privacy_policy extends StatefulWidget {
  static const String routeName = '/policy';

  static Route route() {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => privacy_policy());
  }

  const privacy_policy({Key key}) : super(key: key);

  @override
  _privacy_policyState createState() => _privacy_policyState();
}

class _privacy_policyState extends State<privacy_policy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        title: Text(
          'Privacy Policy',
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
                "Privacy Policy",
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
