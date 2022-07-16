import 'package:chatting/logic/business_create/business_create_cubit.dart';
import 'package:chatting/main.dart';
import 'package:chatting/view/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_place/google_place.dart';
import 'package:sizer/sizer.dart';

class SetupBusiness extends StatefulWidget {
  const SetupBusiness({Key key, this.business}) : super(key: key);
  final SearchResult business;
  @override
  State<SetupBusiness> createState() => _SetupBusinessState();
}

class _SetupBusinessState extends State<SetupBusiness> {
  String myuid = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void getmyUID() {
    setState(() {
      myuid = sharedPreferences.getString('uid');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Hangout Setup",
            style: TextStyle(color: Theme.of(context).iconTheme.color),
          )),
      body: SafeArea(
        child: Container(
          width: 100.w,
          height: 100.h,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              children: [
                SizedBox(
                  height: 10.w,
                ),
                CircleAvatar(
                  radius: 30.sp,
                  backgroundColor: Theme.of(context).iconTheme.color,
                  backgroundImage: NetworkImage(
                      "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=${widget.business.photos[0].photoReference}&key=AIzaSyBuXdZID9cJRjTQ_DKW6rMIBsWYHSDIFjw"),
                ),
                SizedBox(
                  height: 10.w,
                ),
                Text(
                  widget.business.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).iconTheme.color),
                ),
                SizedBox(
                  height: 2.5.w,
                ),
                Text(
                  widget.business.formattedAddress,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15.sp,
                      color: Theme.of(context).iconTheme.color),
                ),
                SizedBox(
                  height: 20.w,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your resonsiblity",
                          style: TextStyle(
                              color: Theme.of(context).iconTheme.color,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5.w,
                        ),
                        Text(
                          "1.This hangout is only open within business hours.",
                          style: TextStyle(
                              fontSize: 13.sp,
                              color: Theme.of(context).iconTheme.color),
                        ),
                        SizedBox(
                          height: 4.w,
                        ),
                        Text(
                          '2.Monitor for posts that are"offensive" in nature.',
                          style: TextStyle(
                              fontSize: 13.sp,
                              color: Theme.of(context).iconTheme.color),
                        ),
                        SizedBox(
                          height: 4.w,
                        ),
                        Text(
                          '2.Take appropriate actions against those who violate rule #2.',
                          style: TextStyle(
                              fontSize: 13.sp,
                              color: Theme.of(context).iconTheme.color),
                        )
                      ],
                    ),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    if (widget.business.photos != null) {
                      context
                          .read<BusinessCreateCubit>()
                          .Create_Business(
                            address: widget.business.formattedAddress,
                            description: "",
                            latitude: double.parse(
                                "${widget.business.geometry.location.lat}"),
                            longitude: double.parse(
                                "${widget.business.geometry.location.lng}"),
                            imageURl:
                                "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=${widget.business.photos[0].photoReference}&key=AIzaSyBuXdZID9cJRjTQ_DKW6rMIBsWYHSDIFjw",
                            Business_Name: widget.business.name,
                            Business_Id: widget.business.placeId,
                            owner: myuid,
                            type: 'business',
                          )
                          .then((value) {
                        Navigator.of(context)
                            .pushReplacementNamed('/messageing', arguments: {
                          'otheruid': widget.business.placeId,
                          'type': 'business',
                        });
                      });
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 60.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.sp),
                        border: Border.all(
                            width: 2,
                            color: Theme.of(context).iconTheme.color)),
                    child: Text(
                      "I am Business Owner",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.w,
                ),
                Button(
                  onpress: () {},
                  buttonenable: true,
                  widths: 60,
                  Texts: "I am NOT Business Owner",
                ),
                SizedBox(
                  height: 10.w,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
