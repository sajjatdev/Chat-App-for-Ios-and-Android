import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sizer/sizer.dart';

import '../../widget/widget.dart';

class welcome extends StatefulWidget {
  static const String routeName = '/welcome';

  static Route route() {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName), builder: (_) => welcome());
  }

  const welcome({Key key}) : super(key: key);

  @override
  _welcomeState createState() => _welcomeState();
}

class _welcomeState extends State<welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          bottom: 150.sp,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
            child: SvgPicture.asset(
              'assets/svg/s.svg',
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 30,
          left: 30,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "Be yourself at public gatherings from comfort of your home.",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/terms');
                      },
                      child: Text(
                        'Terms',
                        style: TextStyle(fontSize: 14.sp),
                      )),
                  Text(
                    '&',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/policy');
                      },
                      child: Text(
                        'Privacy policy',
                        style: TextStyle(fontSize: 14.sp),
                      )),
                ],
              ),
              SizedBox(
                height: 2.5.h,
              ),
              Button(
                buttonenable: true,
                onpress: () {
                  Navigator.of(context).pushNamed('/auth_phone');
                },
                Texts: "LOGIN WITH PHONE",
                widths: 80,
              ),
              SizedBox(
                height: 2.5.h,
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
