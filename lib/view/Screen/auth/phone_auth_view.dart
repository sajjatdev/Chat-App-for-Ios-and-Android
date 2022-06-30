import 'package:chatting/logic/Phone_number_auth/phoneauth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sizer/sizer.dart';
import '../../widget/widget.dart';

class Auth_phone extends StatefulWidget {
  static const String routeName = '/auth_phone';

  static Route route() {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName), builder: (_) => Auth_phone());
  }

  const Auth_phone({Key key}) : super(key: key);

  @override
  _Auth_phoneState createState() => _Auth_phoneState();
}

class _Auth_phoneState extends State<Auth_phone> {
  String phone_number;
  String initialCountry = 'CA';
  bool buttonanable = false;
  TextEditingController phoneNumberController = TextEditingController();
  PhoneNumber number = PhoneNumber(isoCode: 'CA');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
      //   backgroundColor: Theme.of(context).secondaryHeaderColor,
      // ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Login via Phone",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                "Add your phone number. We'll send you a verification code so we know you're real.",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.normal),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: InternationalPhoneNumberInput(
                  initialValue: number,
                  textFieldController: phoneNumberController,
                  countries: const ['CA', 'US', 'BD'],
                  formatInput: true,
                  selectorConfig: const SelectorConfig(
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  inputBorder: const OutlineInputBorder(),
                  onInputChanged: (number) {
                    setState(() {
                      phone_number = number.toString();
                      print(phone_number);
                    });

                    if (phone_number.length > 8) {
                      setState(() {
                        buttonanable = true;
                      });
                    } else {
                      buttonanable = false;
                    }
                  }),
            ),
            const Spacer(
              flex: 2,
            ),
            Button(
              buttonenable: buttonanable,
              onpress: () async {
                if (phone_number.isNotEmpty) {
                  BlocProvider.of<PhoneauthBloc>(context).add(PhoneNumberVerify(
                      phoneNumber: phone_number));
                  Navigator.of(context)
                      .pushNamed('/otp', arguments: phone_number);
                } 
              },
              Texts: "SEND OTP",
              widths: 80,
            ),
            SizedBox(
              height: 5.w,
            )
          ],
        ),
      ),
    );
  }
}
