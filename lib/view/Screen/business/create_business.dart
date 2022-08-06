import 'package:chatting/Helper/color.dart';
import 'package:chatting/logic/business_location/business_location_cubit.dart';
import 'package:chatting/view/Screen/business/setupBusinessProfile/setup.dart';
import 'package:chatting/view/widget/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_place/google_place.dart';
import 'package:sizer/sizer.dart';
import 'package:yelp_fusion_client/models/business_endpoints/business_details.dart';

class Create_business extends StatefulWidget {
  static const String routeName = '/create_business';

  static Route route({BusinessDetails BUSINESSDATA}) {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => Create_business(
              BUSINESSDATA: BUSINESSDATA,
            ));
  }

  final BusinessDetails BUSINESSDATA;
  const Create_business({Key key, this.BUSINESSDATA}) : super(key: key);

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
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
                widget.BUSINESSDATA.location.displayAddress[0] +
                    " " +
                    widget.BUSINESSDATA.location.displayAddress[0],
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
          FutureBuilder<List<SearchResult>>(
              // future: AvailableBusines(),
              builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Expanded(
                flex: 6,
                child: ListView.builder(
                    itemCount: snapshot.data.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
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
                                  CircleAvatar(
                                    child: Image.network(
                                      snapshot.data[index].icon,
                                      color: Colors.white,
                                      scale: 4.sp,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 2.5.w,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data[index].name,
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
                                          snapshot.data[index].formattedAddress
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 10.sp,
                                              color:
                                                  HexColor.fromHex("#707070")),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  FutureBuilder<bool>(
                                      future: BusinessCheck(
                                          id: snapshot.data[index].placeId),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          if (snapshot.data) {
                                            return Text(
                                              "Connect",
                                              style: TextStyle(
                                                  fontSize: 10.sp,
                                                  color: HexColor.fromHex(
                                                      "#4479F6")),
                                            );
                                          } else {
                                            return Text(
                                              "Available",
                                              style: TextStyle(
                                                  fontSize: 10.sp,
                                                  color: HexColor.fromHex(
                                                      "#4479F6")),
                                            );
                                          }
                                        } else {
                                          return Center(
                                            child: CupertinoActivityIndicator(
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color),
                                          );
                                        }
                                      })
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              );
            } else {
              return Container();
            }
          }),
          Spacer(),
          Button(
            buttonenable: true,
            onpress: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SetupBusiness(
                        business: widget.BUSINESSDATA,
                      )));
            },
            Texts: "Hangout Setup",
            widths: 80,
          )
        ]),
      ),
    );
  }

  Future<bool> BusinessCheck({String id}) async {
    final result = await FirebaseFirestore.instance
        .collection("marker")
        .where("Business_Id", isEqualTo: id)
        .get();

    return result.docs.isNotEmpty;
  }

  // Future<List<SearchResult>> AvailableBusines() async {
  //   var stringList = widget.BUSINESSDATA.types.join("%");
  //   print(stringList);
  //   var googlePlace = GooglePlace("AIzaSyBuXdZID9cJRjTQ_DKW6rMIBsWYHSDIFjw");
  //   var result = await googlePlace.search.getTextSearch(
  //     stringList,
  //     location: Location(
  //         lng: widget.BUSINESSDATA.geometry.location.lng,
  //         lat: widget.BUSINESSDATA.geometry.location.lat),
  //   );

  //   return result.results;
  // }
}
