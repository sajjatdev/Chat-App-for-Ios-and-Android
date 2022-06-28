import 'package:chatting/Helper/color.dart';
import 'package:chatting/logic/Phone_number_auth/phoneauth_bloc.dart';
import 'package:chatting/logic/current_user/cunrrent_user_bloc.dart';
import 'package:chatting/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pinput/pin_put/pin_put.dart';

import 'package:sizer/sizer.dart';
import 'package:strings/strings.dart';

import '../../widget/widget.dart';

class OTP extends StatefulWidget {
  const OTP({Key key, this.number}) : super(key: key);

  static const String routeName = '/otp';

  static Route route({String number}) {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => OTP(
              number: number,
            ));
  }

  final String number;

  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  bool buttonloading = false;
  bool buttonEnable = false;

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.deepPurpleAccent),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: buttonloading,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: 100.h,
            width: 100.w,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 5, bottom: 5),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: SvgPicture.asset(
                            'assets/svg/left-arrow-4.svg',
                            color: HexColor.fromHex('#5F5F62'),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Align(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/svg/shield.svg',
                        color: Theme.of(context).iconTheme.color,
                        width: 40.w,
                        height: 40.w,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Verification",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Text(
                      "Enter your Send OTP",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.normal),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    child: PinPut(
                      textInputAction: TextInputAction.done,
                      fieldsCount: 6,
                      controller: _pinPutController,
                      onChanged: (value) {
                        if (value.length <= 5) {
                          setState(() {
                            buttonEnable = false;
                          });
                        } else {
                          setState(() {
                            buttonEnable = true;
                          });
                        }
                      },
                      focusNode: _pinPutFocusNode,
                      selectedFieldDecoration: _pinPutDecoration,
                      submittedFieldDecoration: _pinPutDecoration.copyWith(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      followingFieldDecoration: _pinPutDecoration.copyWith(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Button(
                    buttonenable: buttonEnable,
                    loadingbtn: false,
                    onpress: () async {
                      setState(() {
                        buttonloading = true;
                        buttonEnable = false;
                      });
                      BlocProvider.of<PhoneauthBloc>(context)
                          .add(VerifySMSCode(smscode: _pinPutController.text));
                      Navigator.of(context).pushNamed('/profile_Setup');
                    },
                    Texts: "VERIFY",
                    widths: 80,
                  ),
                  SizedBox(
                    height: 8.w,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
