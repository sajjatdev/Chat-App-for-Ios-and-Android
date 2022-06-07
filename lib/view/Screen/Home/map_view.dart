import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:chatting/Helper/color.dart';
import 'package:chatting/logic/business_location/business_location_cubit.dart';
import 'package:chatting/logic/markers/markers_cubit.dart';
import 'package:chatting/main.dart';
import 'package:chatting/view/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';

import 'package:sizer/sizer.dart';
import 'package:strings/strings.dart';

class Map_view extends StatefulWidget {
  const Map_view({Key key}) : super(key: key);

  @override
  _Map_viewState createState() => _Map_viewState();
}

class _Map_viewState extends State<Map_view> {
  bool hiden_show = false;
  int list_item;
  String myID;
  static const MAPBOX_ACCESS_TOKEN =
      'pk.eyJ1Ijoic2FqamF0NjYiLCJhIjoiY2wxNGwyNDZ5MHdqdjNrbjFzaXE0bTM3ZiJ9.Gfw4GbGdIbD7UlwaFlDHIA';
  static const MAPBOX_STYLE = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getmyuid();
  }

  void getmyuid() {
    setState(() {
      myID = sharedPreferences.getString('uid');
    });
  }

  @override
  Widget build(BuildContext context) {
    final _markerList = <Marker>[];
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    final state = context.watch<MarkersCubit>().state;
    final location = context.watch<BusinessLocationCubit>().state;

    if (state is has_marker && location is Has_Location) {
      for (var item = 0; item < state.marker_list.length; item++) {
        _markerList.add(Marker(
            height: 40,
            width: 40,
            point: LatLng(state.marker_list[item].latitude,
                state.marker_list[item].longitude),
            builder: (_) {
              return GestureDetector(
                  onTap: () {
                    setState(() {
                      hiden_show = true;

                      list_item = item;
                      print("Item is $item");
                    });
                  },
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: SvgPicture.asset(
                          'assets/svg/mark_location.svg',
                        ),
                      ),
                      Positioned(
                        left: 5,
                        right: 5,
                        bottom: 15,
                        top: 5,
                        child: Container(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                              radius: 10,
                              backgroundImage: NetworkImage(
                                  state.marker_list[item].ImageUrl)),
                        ),
                      )
                    ],
                  ));
            }));
      }

      return Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: FlutterMap(
                options: MapOptions(
                    maxZoom: 20,
                    zoom: 15,
                    center: LatLng(double.parse(location.latitude),
                        double.parse(location.longitude))),
                nonRotatedLayers: [
                  TileLayerOptions(
                      urlTemplate:
                          "https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}",
                      additionalOptions: {
                        'accessToken': MAPBOX_ACCESS_TOKEN,
                        'id':
                            isDarkMode ? "mapbox/dark-v10" : "mapbox/light-v10"
                      }),
                  MarkerLayerOptions(markers: _markerList),
                  MarkerLayerOptions(markers: [
                    // Marker(
                    //     height: 20,
                    //     width: 20,
                    //     point: LatLng(double.parse(location.latitude),
                    //         double.parse(location.longitude)),
                    //     builder: (_) {
                    //       return Container(
                    //         decoration: BoxDecoration(
                    //           // color: Colors.green,
                    //           borderRadius: BorderRadius.circular(20),
                    //         ),
                    //       );
                    //     })
                  ]),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 40.w,
                decoration: BoxDecoration(
                    color: Theme.of(context).secondaryHeaderColor),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 30, bottom: 10, left: 20, right: 20),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          " Hangouts",
                          style: TextStyle(
                              color: Theme.of(context).iconTheme.color,
                              fontSize: 21.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                            onPressed: () {
                              showAdaptiveActionSheet(
                                context: context,
                                title: const Text('Set Search Perimeter'),
                                androidBorderRadius: 30,
                                actions: <BottomSheetAction>[
                                  BottomSheetAction(
                                      title: const Text('Near me'),
                                      onPressed: () {}),
                                  BottomSheetAction(
                                      title: const Text('City'),
                                      onPressed: () {}),
                                  BottomSheetAction(
                                      title: const Text('Country'),
                                      onPressed: () {}),
                                  BottomSheetAction(
                                      title: const Text('No Limit'),
                                      onPressed: () {}),
                                ],
                                cancelAction: CancelAction(
                                    title: const Text(
                                        'Cancel')), // onPressed parameter is optional by default will dismiss the ActionSheet
                              );
                            },
                            icon: SvgPicture.asset(
                                'assets/svg/fi-rr-settings-sliders.svg',
                                color: Theme.of(context).iconTheme.color))
                      ],
                    ),
                    Container(
                      child: TextFormField(
                        validator: (value) =>
                            value.isEmpty ? "Name can't be blank" : null,
                        style: TextStyle(
                            color: Theme.of(context).iconTheme.color,
                            fontSize: 12.sp),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.close,
                                color: Theme.of(context).iconTheme.color,
                              )),
                          prefixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.search,
                                color: Theme.of(context).iconTheme.color,
                              )),
                          hintText: "Search around",
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          hintStyle: TextStyle(
                              color: Theme.of(context).iconTheme.color,
                              fontSize: 12.sp),
                          fillColor: isDarkMode
                              ? HexColor.fromHex("#696969")
                              : HexColor.fromHex("#EEEEEF"),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide.none),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide.none),
                        ),
                      ),
                    )
                  ]),
                ),
              ),
            ),
            list_item == null
                ? Container()
                : AnimatedPositioned(
                    duration: Duration(milliseconds: 200),
                    bottom: hiden_show ? 5.w : -60.w,
                    left: 8.w,
                    right: 8.w,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Theme.of(context).secondaryHeaderColor,
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      state.marker_list[list_item].ImageUrl),
                                ),
                                SizedBox(
                                  width: 3.w,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      capitalize(
                                          state.marker_list[list_item].title),
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color),
                                    ),
                                    SizedBox(
                                      height: 2.w,
                                    ),
                                    SizedBox(
                                      width: 50.w,
                                      child: Text(
                                        state.marker_list[list_item].Address,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.grey.shade400),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2.5.w,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        FirebaseFirestore.instance
                                            .collection("chat")
                                            .doc(state.marker_list[list_item]
                                                .business_id)
                                            .update({
                                          'customer': FieldValue.arrayUnion([
                                            myID,
                                          ])
                                        }).then((value) {
                                          FirebaseFirestore.instance
                                              .collection('user')
                                              .doc(myID)
                                              .collection("Friends")
                                              .doc(state.marker_list[list_item]
                                                  .business_id)
                                              .set({
                                            "Room_ID": state
                                                .marker_list[list_item]
                                                .business_id,
                                            "time": DateTime.now()
                                                .millisecondsSinceEpoch
                                                .toString(),
                                            "type": state
                                                .marker_list[list_item].type,
                                            "uid": state.marker_list[list_item]
                                                .business_id,
                                          });
                                          Navigator.of(context).pushNamed(
                                              '/messageing',
                                              arguments: {
                                                'mamber_list': state
                                                    .marker_list[list_item]
                                                    .customer,
                                                'type': state
                                                    .marker_list[list_item]
                                                    .type,
                                                'otheruid': state
                                                    .marker_list[list_item]
                                                    .business_id,
                                              });
                                        });
                                      },
                                      child: Container(
                                        height: 10.w,
                                        width: 50.w,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Text("Join",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .secondaryHeaderColor)),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
            AnimatedPositioned(
                duration: Duration(milliseconds: 200),
                bottom: hiden_show ? 32.w : -60.w,
                left: 65.w,
                right: 0,
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        hiden_show = false;
                      });
                    },
                    icon: Icon(Icons.close)))
          ],
        ),
      );
    }
    return Scaffold(
      body: Center(
          child: CupertinoActivityIndicator(
        color: Theme.of(context).iconTheme.color,
      )),
    );
  }
}
