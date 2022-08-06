import 'package:chatting/view/Screen/business/setupBusinessProfile/setup.dart';
import 'package:chatting/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:sizer/sizer.dart';
import 'package:yelp_fusion_client/models/business_endpoints/business_details.dart';

class BusinessIntro extends StatelessWidget {
  const BusinessIntro({Key key, this.business}) : super(key: key);
  final BusinessDetails business;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 20.sp),
        child: Container(
          height: 100.h,
          width: 100.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.w),
                child: Container(
                    height: 45.w,
                    width: 45.w,
                    child: Image.asset(
                      "assets/image/lightbg.png",
                      color: Theme.of(context).iconTheme.color,
                    )),
              ),
              SizedBox(
                height: 20.sp,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.sp),
                child: Text(
                  "Have you heard of Hangout Spots?",
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 20.w,
              ),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/image/contact-list.png",
                          width: 10.w,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        SizedBox(
                          width: 50.w,
                          child: Text(
                            "Drop in on conversations, Whether it is at your local coffee shop or half way around there Canada and US",
                            style: TextStyle(
                                color: Theme.of(context).iconTheme.color),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.w,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/image/contact.png",
                          width: 10.w,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        SizedBox(
                          width: 50.w,
                          child: Text(
                            "By just having username you can continue to send message without revealing your phone number ",
                            style: TextStyle(
                                color: Theme.of(context).iconTheme.color),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.w,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/image/route.png",
                          width: 10.w,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        SizedBox(
                          width: 50.w,
                          child: Text(
                            "Be in multiple place from the comfort of your home.",
                            style: TextStyle(
                                color: Theme.of(context).iconTheme.color),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Spacer(),
              Button(
                buttonenable: true,
                onpress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SetupBusiness(
                            business: business,
                          )));
                },
                widths: 70,
                Texts: "Proceed",
              ),
              SizedBox(
                height: 5.w,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 70.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.sp),
                      border: Border.all(
                          width: 2, color: Theme.of(context).iconTheme.color)),
                  child: Text(
                    "Cancel",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
