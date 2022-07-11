import 'dart:async';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:chatting/Helper/color.dart';
import 'package:chatting/Helper/config.dart';
import 'package:chatting/logic/Google_Search/cubit/map_search_cubit.dart';
import 'package:chatting/logic/business_location/business_location_cubit.dart';
import 'package:chatting/main.dart';
import 'package:chatting/model/Google%20Map%20/Map_Search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Map_view extends StatefulWidget {
  const Map_view({Key key}) : super(key: key);

  @override
  _Map_viewState createState() => _Map_viewState();
}

class _Map_viewState extends State<Map_view> {
  TextEditingController search = TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();
  List<Google_map_search> MarkerDataList;
  bool hiden_show = false;
  bool isloading = false;
  int list_item;
  double lat = 0;
  double lng = 0;
  String myID;
  int dataindex = 0;

  int markerIdCounter = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getmyuid();

    Permission.location.request().isGranted;
  }

  void getmyuid() {
    setState(() {
      myID = sharedPreferences.getString('uid');
    });
  }

  void _setMarker(point, state) {}

  // Future<void> gotoSearchedPlace() async {
  //   final mapdata = context.watch<MapSearchCubit>().state;

  //   if (mapdata is GetDataformGoogle) {
  //     for (var i = 0; i < mapdata.GetDataFormGoogle.length; i++) {
  //       final GoogleMapController controller = await _controller.future;

  //       controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
  //         zoom: 12,
  //         target: LatLng(mapdata.GetDataFormGoogle[i].geometry.location.lat,
  //             mapdata.GetDataFormGoogle[i].geometry.location.lng),
  //       )));

  //       _setMarker(LatLng(mapdata.GetDataFormGoogle[i].geometry.location.lat,
  //           mapdata.GetDataFormGoogle[i].geometry.location.lng),mapdata);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    final locationbloc = context.watch<BusinessLocationCubit>().state;
    if (locationbloc is Has_Location) {
      setState(() {
        lat = double.parse(locationbloc.latitude);
        lng = double.parse(locationbloc.longitude);
      });
    }
    return LoadingOverlay(
      isLoading: isloading,
      progressIndicator:
          CupertinoActivityIndicator(color: Theme.of(context).iconTheme.color),
      child: Scaffold(
          body: Stack(
        children: [
          BlocConsumer<MapSearchCubit, MapSearchState>(
            listener: ((context, state) async {
              if (state is GetDataformGoogle) {
                setState(() {
                  isloading = false;
                  MarkerDataList = state.GetDataFormGoogle;
                });
                for (var i = 1; i <= state.GetDataFormGoogle.length; i++) {
                  final GoogleMapController controller =
                      await _controller.future;

                  controller.animateCamera(
                      CameraUpdate.newCameraPosition(CameraPosition(
                    zoom: 12,
                    target: LatLng(
                        state.GetDataFormGoogle[i].geometry.location.lat,
                        state.GetDataFormGoogle[i].geometry.location.lng),
                  )));
                  var counter = markerIdCounter++;

                  final Marker marker = Marker(
                      markerId: MarkerId('marker_$counter'),
                      position: LatLng(
                          state.GetDataFormGoogle[i].geometry.location.lat,
                          state.GetDataFormGoogle[i].geometry.location.lng),
                      onTap: () {
                        setState(() {
                          dataindex = i;
                          debugPrint(i.toString());
                        });
                      },
                      infoWindow: InfoWindow(
                          title: state.GetDataFormGoogle[i].name,
                          snippet: state.GetDataFormGoogle[i].formattedAddress),
                      icon: BitmapDescriptor.defaultMarker);

                  setState(() {
                    _markers.add(marker);
                  });
                }
              }
              if (state is error) {
                setState(() {
                  isloading = false;
                });
              }
            }),
            builder: (context, state) {
              if (state is GetDataformGoogle) {
                // gotoSearchedPlace();
                return GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(lat, lng),
                    zoom: 14,
                  ),
                  onTap: (value) {
                    print(value.latitude);
                  },
                  mapType: MapType.normal,
                  zoomControlsEnabled: false,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  markers: _markers,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                );
              } else {
                return GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(23.8103, 90.3795),
                    zoom: 14,
                  ),
                  mapType: MapType.normal,
                  zoomControlsEnabled: false,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                );
              }
            },
          ),

          ///
          ///
          ///
          ///
          ///
          ///
          ///
          ///
          /// search box
          ///
          ///

          Positioned(
            top: 25.sp,
            left: 0,
            right: 0,
            child: Container(
                height: 25.w,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 30, bottom: 10, left: 20, right: 20),
                  child: TextFormField(
                    controller: search,
                    validator: (value) =>
                        value.isEmpty ? "Name can't be blank" : null,
                    onFieldSubmitted: (value) {
                      setState(() {
                        isloading = true;
                        String searchkey = value;
                        _markers = {};
                        print(searchkey);
                        context.read<MapSearchCubit>().MapSearchdata(
                            Address: searchkey.replaceAll(" ", "%"));
                      });
                    },
                    style: TextStyle(
                        color: Theme.of(context).iconTheme.color,
                        fontSize: 12.sp),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
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
                              color: Theme.of(context).iconTheme.color)),
                      prefixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isloading = true;
                              String searchkey = search.text;
                              _markers = {};
                              print(searchkey);
                              context.read<MapSearchCubit>().MapSearchdata(
                                  Address: searchkey.replaceAll(" ", "%"));
                            });
                          },
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
                )),
          ),
          ////
          ///
          ///
          ///
          ///
          ///
          ///
          ///
          ///
          ///
          ///
          ///
          ///
          ///Intro Data sheet
          ///
          ///

          dataindex > 0 && MarkerDataList.isNotEmpty
              ? SlidingUpPanel(
                  backdropEnabled: true,
                  parallaxEnabled: true,
                  parallaxOffset: .5,
                  backdropColor: Theme.of(context).iconTheme.color,
                  color: Theme.of(context).secondaryHeaderColor,
                  panel: Column(children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=${MarkerDataList[dataindex].photos[1].photoReference}&key=$GOOGLEMAPAPI"),
                      ),
                      title: Text(
                        MarkerDataList[dataindex].photos[1].photoReference,
                        style: TextStyle(
                            fontSize: 15.sp,
                            color: Theme.of(context).iconTheme.color),
                      ),
                      subtitle: Text(
                        MarkerDataList[dataindex].formattedAddress,
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: Theme.of(context).iconTheme.color),
                      ),
                    )
                  ]),
                )
              : Container(),
        ],
      )),
    );
  }
}
