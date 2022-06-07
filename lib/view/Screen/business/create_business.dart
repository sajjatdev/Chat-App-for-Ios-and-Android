import 'package:chatting/Helper/color.dart';
import 'package:chatting/logic/business_location/business_location_cubit.dart';
import 'package:chatting/view/widget/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class Create_business extends StatefulWidget {
  static const String routeName = '/create_business';

  static Route route() {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => Create_business());
  }

  const Create_business({Key key}) : super(key: key);

  @override
  State<Create_business> createState() => _Create_businessState();
}

class _Create_businessState extends State<Create_business> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BusinessLocationCubit>().state;

    if (state is Loading_location) {
      return Center(
        child: CupertinoActivityIndicator(
            color: Theme.of(context).iconTheme.color),
      );
    }
    if (state is Has_Location) {
      print(state.address);
      return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).iconTheme.color,
              ),
            )),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Create\nbusiness",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).iconTheme.color),
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  state.address,
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).iconTheme.color),
                ),
              ),
            ),
            SizedBox(
              height: 10.w,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Enter your business location to see if there is already Hangout spot created for your business.",
                style: TextStyle(color: HexColor.fromHex("#707070")),
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Result",
                style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).iconTheme.color),
              ),
            ),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection("marker").snapshots(),
                builder: (context, snapshot) {
              return Expanded(
                flex: 6,
                child: ListView.builder(
                    itemCount: 10,
                    shrinkWrap: true,
                    itemBuilder: (context, snapshot) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: GestureDetector(
                          onTap: () {},
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(),
                                  SizedBox(
                                    width: 2.5.w,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Starbucks",
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color),
                                      ),
                                      SizedBox(
                                        height: 2.w,
                                      ),
                                      SizedBox(
                                        width: 60.w,
                                        child: Text(
                                          state.address,
                                          style: TextStyle(
                                              fontSize: 10.sp,
                                              color:
                                                  HexColor.fromHex("#707070")),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: 2.5.w,
                                  ),
                                  Text(
                                    "Available",
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        color: HexColor.fromHex("#4479F6")),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              );
            }),
            Spacer(),
            Button(
              buttonenable: true,
              onpress: () {
                Navigator.of(context).pushReplacementNamed(
                    '/create_business_profile',
                    arguments: {
                      'address': state.address,
                      'latitude': state.latitude,
                      'longitude': state.longitude
                    });
              },
              Texts: "CREATE",
              widths: 80,
            )
          ]),
        ),
      );
    }
  }
}
