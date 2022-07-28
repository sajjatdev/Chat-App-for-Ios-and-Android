import 'package:chatting/Helper/color.dart';

import 'package:chatting/logic/Phone_Update/phoneupdate_cubit.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:loading_overlay/loading_overlay.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:sizer/sizer.dart';

class NumberChange extends StatefulWidget {
  const NumberChange({Key key, this.myuid}) : super(key: key);
  final String myuid;
  @override
  State<NumberChange> createState() => _NumberChangeState();
}

class _NumberChangeState extends State<NumberChange> {
  PhoneController phoneNumberController = PhoneController(null);
  TextEditingController otp = TextEditingController();
  bool isphonenumber = false;
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return LoadingOverlay(
      isLoading: isloading,
      progressIndicator:
          CupertinoActivityIndicator(color: Theme.of(context).iconTheme.color),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 1,
          iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            "Change Number",
            style: TextStyle(color: Theme.of(context).iconTheme.color),
          ),
          centerTitle: true,
        ),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
            child: BlocListener<PhoneupdateCubit, PhoneupdateState>(
              listener: (context, state) {
                if (state is Loading) {
                  setState(() {
                    isloading = true;
                  });
                }
                if (state is otpSend) {
                  setState(() {
                    isloading = false;
                    isphonenumber = true;
                  });
                  var snackBar = SnackBar(content: Text('OTP Send'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                if (state is phone_invalid) {
                  setState(() {
                    isloading = false;
                    isphonenumber = false;
                  });
                  var snackBar = SnackBar(content: Text('Phone Invalid'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                if (state is Otpinvalid) {
                  setState(() {
                    isloading = false;
                    isphonenumber = true;
                  });
                  var snackBar = SnackBar(content: Text('OTP Invalid'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                if (state is OtpEx) {
                  setState(() {
                    isloading = false;
                    isphonenumber = false;
                  });
                  var snackBar = SnackBar(content: Text('OTP Expire'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                if (state is Errorphone) {
                  setState(() {
                    isloading = false;
                    isphonenumber = false;
                  });
                  var snackBar = SnackBar(content: Text('Try Again'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                if (state is VerifyDone) {
                  var snackBar = SnackBar(content: Text('Verify Success'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  FirebaseFirestore.instance
                      .collection('user')
                      .doc(widget.myuid)
                      .update({
                    "Phone_number": phoneNumberController.value
                  }).then((value) {
                    List<String> phoneKeyword = keyword_phones(
                        phones: phoneNumberController.value.toString());
                    FirebaseFirestore.instance
                        .collection("user")
                        .doc(widget.myuid)
                        .update({"Phone_keyword": phoneKeyword});
                    setState(() {
                      isloading = false;
                    });
                    Navigator.of(context).pop();
                  });
                }
              },
              child: Center(
                child: isphonenumber == true
                    ? TextField(
                        controller: otp,
                        textInputAction: TextInputAction.send,
                        keyboardType: TextInputType.phone,
                        cursorColor: Theme.of(context).iconTheme.color,
                        style: TextStyle(
                            fontSize: 15.sp,
                            color: Theme.of(context).iconTheme.color),
                        decoration: InputDecoration(
                            hintText: "Enter your code",
                            suffixIcon: IconButton(
                                onPressed: () {
                                  context
                                      .read<PhoneupdateCubit>()
                                      .OTP_Verify(code: otp.text);
                                },
                                icon: Icon(
                                  CupertinoIcons.arrow_right,
                                  color: Theme.of(context).iconTheme.color,
                                )),
                            filled: true,
                            fillColor: isDarkMode
                                ? HexColor.fromHex("#1a1a1c")
                                : HexColor.fromHex("#ffffff"),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10.sp))),
                      )

                    // context.read<PhoneupdateCubit>().Phone_number_Change(
                    //       number: phoneNumberController.text);

                    : PhoneFormField(
                        key: Key('phone-field'),
                        autofocus: true,
                        controller: phoneNumberController,
                        initialValue: null,
                        shouldFormat: true,
                        defaultCountry: IsoCode.CA,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).iconTheme.color)),
                        ),
                        validator: PhoneValidator.validMobile(),
                        countrySelectorNavigator:
                            CountrySelectorNavigator.bottomSheet(),
                        showFlagInInput: true,
                        flagSize: 16,
                        autofillHints: [AutofillHints.telephoneNumber],
                        enabled: true,
                        autovalidateMode: AutovalidateMode.always,
                      ),
              ),
            )),
      ),
    );
  }

  List<String> keyword_phones({String phones}) {
    List<String> keyword_phone = [];
    String phone = '';

    for (var i = 0; i < phones.length; i++) {
      phone += phones[i];
      keyword_phone.add(phone);
    }
    return keyword_phone;
  }
}
