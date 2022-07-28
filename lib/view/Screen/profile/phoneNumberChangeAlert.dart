import 'package:chatting/view/Screen/profile/numberchange.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class PhoneChangeAlert extends StatefulWidget {
  const PhoneChangeAlert({Key key, this.myuid}) : super(key: key);
  final String myuid;

  @override
  State<PhoneChangeAlert> createState() => _PhoneChangeAlertState();
}

class _PhoneChangeAlertState extends State<PhoneChangeAlert> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset("assets/svg/phonechange.json"),
            Text(
              "You can change your Chatter number here. Your account and all your cloud data - messages, media, contacts, etc. will be moved to the new number ",
              style: TextStyle(
                  color: Theme.of(context).iconTheme.color.withOpacity(0.5),
                  fontSize: 12.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10.h,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NumberChange(
                          myuid: widget.myuid,
                        )));
              },
              child: Container(
                height: 6.h,
                width: 100.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Theme.of(context).secondaryHeaderColor,
                    borderRadius: BorderRadius.circular(10.sp)),
                child: Text(
                  "Change Number",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15.sp,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
