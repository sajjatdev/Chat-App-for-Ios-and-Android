import 'package:chatting/Helper/color.dart';
import 'package:chatting/view/Screen/Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

class Home_view extends StatefulWidget {
  static const String routeName = '/home';

  static Route route() {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName), builder: (_) => Home_view());
  }

  const Home_view({Key key}) : super(key: key);

  @override
  _Home_viewState createState() => _Home_viewState();
}

class _Home_viewState extends State<Home_view> {
  PageController pageController = PageController(initialPage: 0);
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  int currentindex = 0;
  final screen = [
    chat_view(),
    Map_view(),
    setting_view(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[currentindex],
      bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Container(
            height: 6.h,
            width: double.infinity,
            alignment: Alignment.center,
            color: Theme.of(context).secondaryHeaderColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          currentindex = 0;
                        });
                      },
                      icon: SvgPicture.asset(
                        currentindex == 0
                            ? 'assets/svg/chatin.svg'
                            : 'assets/svg/Chat.svg',
                        color: currentindex != 0
                            ? HexColor.fromHex('#8C8C8C')
                            : Theme.of(context).iconTheme.color,
                        width: currentindex == 0 ? 19.sp : null,
                      )),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          currentindex = 1;
                        });
                      },
                      icon: SvgPicture.asset(
                        currentindex == 1
                            ? 'assets/svg/locationsin.svg'
                            : 'assets/svg/Hangout.svg',
                        color: currentindex != 1
                            ? HexColor.fromHex('#8C8C8C')
                            : Theme.of(context).iconTheme.color,
                        width: currentindex == 1 ? 19.sp : null,
                      )),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          currentindex = 2;
                        });
                      },
                      icon: SvgPicture.asset(
                        currentindex == 2
                            ? 'assets/svg/Shapein.svg'
                            : 'assets/svg/Settings.svg',
                        color: currentindex != 2
                            ? HexColor.fromHex('#8C8C8C')
                            : Theme.of(context).iconTheme.color,
                        width: currentindex == 2 ? 19.sp : null,
                      )),
                ],
              ),
            ),
          )),
    );
  }
}
