import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:chatting/Helper/color.dart';
import 'package:chatting/logic/BusinessInfoGet/business_info_get_cubit.dart';
import 'package:chatting/logic/Google_Search/cubit/map_search_cubit.dart';
import 'package:chatting/main.dart';
import 'package:chatting/view/Screen/business/businessintro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:google_geocoding/google_geocoding.dart' as geocode;
import 'package:google_place/google_place.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart' as lottic;
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

class Map_view extends StatefulWidget {
  const Map_view({Key key}) : super(key: key);

  @override
  _Map_viewState createState() => _Map_viewState();
}

class _Map_viewState extends State<Map_view> {
  TextEditingController search = TextEditingController();

  MapController mapController;
  String AccessToken =
      "pk.eyJ1IjoieW1vaGFtbWEiLCJhIjoiY2w1cGp0MzB2MW5xbDNibWcxdHU0bDlheSJ9.rHiBh8YgCZ55X53N6rGR5g";
  List<Marker> _markers = [];
  List<SearchResult> MarkerDataList;
  bool hiden_show = false;
  bool isloading = false;
  int list_item;
  double lat = 0;
  double lng = 0;
  String myID;
  Position position = Position();
  int markerIdCounter = 1;
  List<String> Image = [];
  List<AutocompletePrediction> predictions = [];
  bool connectionChecker = false;
  bool areaSearch = false;
  int oldindex = 0;
  int radius = 2;
  int clickindex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mapController = MapController();
    getmyuid();
    Permission.location.request().isGranted;
  }

  void getmyuid() async {
    setState(() {
      myID = sharedPreferences.getString('uid');
    });
  }

  void _onMapCreated(MapController controller) {
    mapController = controller;
  }

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

    return LoadingOverlay(
      isLoading: isloading,
      progressIndicator:
          CupertinoActivityIndicator(color: Theme.of(context).iconTheme.color),
      child: FutureBuilder<bool>(
          future: InternetConnectionChecker().hasConnection,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == true) {
                return Scaffold(
                    body: FutureBuilder<Position>(
                        future: determinePosition(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Stack(
                              children: [
                                BlocConsumer<MapSearchCubit, MapSearchState>(
                                  listener: ((context, state) async {
                                    if (state is GetDataformGoogle) {
                                      setState(() {
                                        isloading = false;
                                        MarkerDataList =
                                            state.GetDataFormGoogle;
                                      });
                                      mapController.move(
                                          latlng.LatLng(
                                              state.GetDataFormGoogle[0]
                                                  .geometry.location.lat,
                                              state.GetDataFormGoogle[0]
                                                  .geometry.location.lng),
                                          10);
                                      for (var i = 1;
                                          i < state.GetDataFormGoogle.length;
                                          i++) {
                                        print(i);
                                        final marker = Marker(
                                            height: 10.w,
                                            width: 10.w,
                                            point: latlng.LatLng(
                                                state.GetDataFormGoogle[i]
                                                    .geometry.location.lat,
                                                state.GetDataFormGoogle[i]
                                                    .geometry.location.lng),
                                            builder: (_) {
                                              return GestureDetector(
                                                onTap: () {},
                                                child: Container(
                                                  key: Key(state
                                                      .GetDataFormGoogle[i]
                                                      .placeId),
                                                  child: Stack(
                                                    children: [
                                                      SvgPicture.asset(
                                                          "assets/svg/uns.svg"),
                                                      Positioned(
                                                          top: 0,
                                                          left: 0,
                                                          bottom: 0,
                                                          right: 0,
                                                          child: Container(
                                                            height: 7.w,
                                                            width: 7.w,
                                                            color: Colors
                                                                .transparent,
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              i.toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      14.sp,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });

                                        setState(() {
                                          _markers.add(marker);
                                        });
                                      }
                                    }
                                    if (state is MoveSearch) {
                                      for (var i = 0;
                                          i < state.MoveSearchs.length;
                                          i++) {}
                                    }
                                    if (state is error) {
                                      setState(() {
                                        isloading = false;
                                      });
                                    }
                                  }),
                                  builder: (context, state) {
                                    if (state is MoveSearch) {
                                      return FlutterMap(
                                          mapController: mapController,
                                          options: MapOptions(
                                              enableMultiFingerGestureRace:
                                                  true,
                                              maxZoom: 20,
                                              zoom: 15,
                                              center: latlng.LatLng(
                                                  double.parse(
                                                      "${snapshot.data.latitude}"),
                                                  double.parse(
                                                      "${snapshot.data.longitude}"))),
                                          nonRotatedLayers: [
                                            TileLayerOptions(
                                                urlTemplate:
                                                    "https://api.mapbox.com/styles/v1/ymohamma/{id}/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoieW1vaGFtbWEiLCJhIjoiY2w1cGp0MzB2MW5xbDNibWcxdHU0bDlheSJ9.rHiBh8YgCZ55X53N6rGR5g",
                                                additionalOptions: {
                                                  'accessToken':
                                                      "pk.eyJ1IjoieW1vaGFtbWEiLCJhIjoiY2w1cGp0MzB2MW5xbDNibWcxdHU0bDlheSJ9.rHiBh8YgCZ55X53N6rGR5g",
                                                  'id': isDarkMode
                                                      ? "cl5rxs3tm000716o62ghzo53f"
                                                      : "cl5rzovmv00gn14o10pke1m7a"
                                                }),
                                            MarkerLayerOptions(
                                                markers: _markers),
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
                                          ]);
                                    }
                                    if (state is GetDataformGoogle) {
                                      return FlutterMap(
                                          mapController: mapController,
                                          options: MapOptions(
                                              enableMultiFingerGestureRace:
                                                  true,
                                              onPositionChanged:
                                                  ((position, hasGesture) {
                                                print(position.center.latitude);
                                              }),
                                              maxZoom: 20,
                                              zoom: 15,
                                              center: latlng.LatLng(
                                                  double.parse(
                                                      "${snapshot.data.latitude}"),
                                                  double.parse(
                                                      "${snapshot.data.longitude}"))),
                                          nonRotatedLayers: [
                                            TileLayerOptions(
                                                urlTemplate:
                                                    "https://api.mapbox.com/styles/v1/ymohamma/{id}/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoieW1vaGFtbWEiLCJhIjoiY2w1cGp0MzB2MW5xbDNibWcxdHU0bDlheSJ9.rHiBh8YgCZ55X53N6rGR5g",
                                                additionalOptions: {
                                                  'accessToken':
                                                      "pk.eyJ1IjoieW1vaGFtbWEiLCJhIjoiY2w1cGp0MzB2MW5xbDNibWcxdHU0bDlheSJ9.rHiBh8YgCZ55X53N6rGR5g",
                                                  'id': isDarkMode
                                                      ? "cl5rxs3tm000716o62ghzo53f"
                                                      : "cl5rzovmv00gn14o10pke1m7a"
                                                }),
                                            MarkerLayerOptions(
                                                markers: _markers),
                                          ]);
                                    } else {
                                      return FlutterMap(
                                          mapController: mapController,
                                          options: MapOptions(
                                              maxZoom: 20,
                                              zoom: 15,
                                              center: latlng.LatLng(
                                                  double.parse(
                                                      "${snapshot.data.latitude}"),
                                                  double.parse(
                                                      "${snapshot.data.longitude}"))),
                                          nonRotatedLayers: [
                                            TileLayerOptions(
                                                urlTemplate:
                                                    "https://api.mapbox.com/styles/v1/ymohamma/{id}/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoieW1vaGFtbWEiLCJhIjoiY2w1cGp0MzB2MW5xbDNibWcxdHU0bDlheSJ9.rHiBh8YgCZ55X53N6rGR5g",
                                                additionalOptions: {
                                                  'accessToken':
                                                      "pk.eyJ1IjoieW1vaGFtbWEiLCJhIjoiY2w1cGp0MzB2MW5xbDNibWcxdHU0bDlheSJ9.rHiBh8YgCZ55X53N6rGR5g",
                                                  'id': isDarkMode
                                                      ? "cl5rxs3tm000716o62ghzo53f"
                                                      : "cl5rzovmv00gn14o10pke1m7a"
                                                }),
                                            MarkerLayerOptions(
                                                markers: _markers),
                                          ]);
                                    }
                                  },
                                ),

                                ////
                                ///
                                ///
                                ///
                                ///area Search
                                if (areaSearch) ...[
                                  Positioned(
                                      top: 30.w,
                                      left: 0,
                                      right: 0,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 35.w),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              context
                                                  .read<MapSearchCubit>()
                                                  .MapMoveSearchdata(
                                                    Address: search.text,
                                                    lat: lat,
                                                    lng: lng,
                                                  )
                                                  .then((value) {
                                                lat = 0;
                                                lng = 0;
                                                areaSearch = false;
                                                hiden_show = false;
                                              });
                                            });
                                          },
                                          child: Container(
                                            height: 10.w,
                                            decoration: BoxDecoration(
                                                color: isDarkMode
                                                    ? HexColor.fromHex(
                                                        "#696969")
                                                    : HexColor.fromHex(
                                                        "#EEEEEF"),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.sp)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.search,
                                                  size: 12.sp,
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color,
                                                ),
                                                Text(
                                                  "Search Area",
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: Theme.of(context)
                                                          .iconTheme
                                                          .color),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                                ],
                                ////
                                ///
                                ///
                                ///
                                ///Auto Complate Listview
                                ///

                                if (predictions.isNotEmpty) ...[
                                  Positioned(
                                    top: 30.w,
                                    left: 0,
                                    right: 0,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5.w),
                                      child: Container(
                                        height: 40.h,
                                        decoration: BoxDecoration(
                                            color: isDarkMode
                                                ? HexColor.fromHex("#696969")
                                                    .withOpacity(.6)
                                                : HexColor.fromHex("#EEEEEF")
                                                    .withOpacity(.6),
                                            borderRadius:
                                                BorderRadius.circular(10.sp)),
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: predictions.length,
                                            itemBuilder: (context, index) {
                                              return ListTile(
                                                leading: const CircleAvatar(
                                                  backgroundColor: Colors.grey,
                                                  child: Icon(
                                                    Icons.pin_drop,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    hiden_show = true;

                                                    context
                                                        .read<MapSearchCubit>()
                                                        .MapSearchdata(
                                                            address:
                                                                predictions[
                                                                        index]
                                                                    .description
                                                                    .replaceAll(
                                                                        " ",
                                                                        "%"),
                                                            lat:
                                                                snapshot.data
                                                                    .latitude,
                                                            lng: snapshot
                                                                .data.longitude,
                                                            radius: radius)
                                                        .then((value) {
                                                      predictions = [];
                                                    });
                                                  });
                                                },
                                                title: Text(
                                                  predictions[index]
                                                      .description
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .iconTheme
                                                          .color,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              );
                                            }),
                                      ),
                                    ),
                                  ),
                                ],

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
                                            top: 30,
                                            bottom: 10,
                                            left: 20,
                                            right: 20),
                                        child: TextFormField(
                                          cursorColor:
                                              Theme.of(context).iconTheme.color,
                                          onChanged: (value) {
                                            setState(() {
                                              hiden_show = false;
                                            });
                                            if (value.isNotEmpty) {
                                              setState(() {
                                                autoCompleteSearch(value);
                                              });
                                            } else {
                                              if (predictions.length > 0 &&
                                                  mounted) {
                                                setState(() {
                                                  predictions = [];
                                                });
                                              }
                                            }
                                          },
                                          controller: search,
                                          validator: (value) => value.isEmpty
                                              ? "Name can't be blank"
                                              : null,
                                          onFieldSubmitted: (value) {
                                            setState(() {
                                              hiden_show = false;
                                              isloading = true;
                                              String searchkey = value;
                                              _markers = [];
                                              predictions = [];
                                              markerIdCounter = 0;
                                              BlocProvider.of<
                                                          BusinessInfoGetCubit>(
                                                      context)
                                                  .isClosed;
                                              context
                                                  .read<MapSearchCubit>()
                                                  .MapSearchdata(
                                                      address: searchkey
                                                          .replaceAll(" ", "%"),
                                                      lat: snapshot
                                                          .data.latitude,
                                                      lng: snapshot
                                                          .data.longitude,
                                                      radius: radius);
                                            });
                                          },
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .iconTheme
                                                  .color,
                                              fontSize: 12.sp),
                                          decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                                onPressed: () {
                                                  showAdaptiveActionSheet(
                                                    context: context,
                                                    title: const Text(
                                                        'Set Search Perimeter'),
                                                    androidBorderRadius: 30,
                                                    actions: <
                                                        BottomSheetAction>[
                                                      BottomSheetAction(
                                                          title: const Text(
                                                              'Near me'),
                                                          onPressed: () {
                                                            context.read<MapSearchCubit>().MapSearchdata(
                                                                address: search
                                                                    .text
                                                                    .replaceAll(
                                                                        " ", "%"),
                                                                lat: snapshot
                                                                    .data
                                                                    .latitude,
                                                                lng: snapshot
                                                                    .data
                                                                    .longitude,
                                                                radius: 3);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          }),
                                                      BottomSheetAction(
                                                          title: const Text(
                                                              'City'),
                                                          onPressed: () {
                                                            context.read<MapSearchCubit>().MapSearchdata(
                                                                address: search
                                                                    .text
                                                                    .replaceAll(
                                                                        " ", "%"),
                                                                lat: snapshot
                                                                    .data
                                                                    .latitude,
                                                                lng: snapshot
                                                                    .data
                                                                    .longitude,
                                                                radius: 10);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          }),
                                                      BottomSheetAction(
                                                          title: const Text(
                                                              'Country'),
                                                          onPressed: () {
                                                            context.read<MapSearchCubit>().MapSearchdata(
                                                                address: search
                                                                    .text
                                                                    .replaceAll(
                                                                        " ", "%"),
                                                                lat: snapshot
                                                                    .data
                                                                    .latitude,
                                                                lng: snapshot
                                                                    .data
                                                                    .longitude,
                                                                radius: 100);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          }),
                                                      BottomSheetAction(
                                                          title: const Text(
                                                              'No Limit'),
                                                          onPressed: () {
                                                            context.read<MapSearchCubit>().MapSearchdata(
                                                                address: search
                                                                    .text
                                                                    .replaceAll(
                                                                        " ", "%"),
                                                                lat: snapshot
                                                                    .data
                                                                    .latitude,
                                                                lng: snapshot
                                                                    .data
                                                                    .longitude,
                                                                radius: 1000);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          }),
                                                    ],
                                                    cancelAction: CancelAction(
                                                        title: const Text(
                                                            'Cancel')), // onPressed parameter is optional by default will dismiss the ActionSheet
                                                  );
                                                },
                                                icon: SvgPicture.asset(
                                                    'assets/svg/fi-rr-settings-sliders.svg',
                                                    color: Theme.of(context)
                                                        .iconTheme
                                                        .color)),
                                            prefixIcon: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    hiden_show = false;
                                                    isloading = true;
                                                    String searchkey =
                                                        search.text;
                                                    _markers = [];
                                                    predictions = [];
                                                    BlocProvider.of<
                                                                BusinessInfoGetCubit>(
                                                            context)
                                                        .close();

                                                    context
                                                        .read<MapSearchCubit>()
                                                        .MapSearchdata(
                                                            address: searchkey
                                                                .replaceAll(
                                                                    " ", "%"),
                                                            lat: snapshot
                                                                .data.latitude,
                                                            lng: snapshot
                                                                .data.longitude,
                                                            radius: radius);
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.search,
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color,
                                                )),
                                            hintText: "Search around",
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5),
                                            hintStyle: TextStyle(
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color,
                                                fontSize: 12.sp),
                                            fillColor: isDarkMode
                                                ? HexColor.fromHex("#696969")
                                                : HexColor.fromHex("#EEEEEF"),
                                            filled: true,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                    borderSide:
                                                        BorderSide.none),
                                            errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                borderSide: BorderSide.none),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
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
                                ///

                                hiden_show
                                    ? BlocConsumer<MapSearchCubit,
                                        MapSearchState>(
                                        listener: (context, state) {
                                          if (state is GetDataformGoogle) {}
                                        },
                                        builder: (context, state) {
                                          if (state is GetDataformGoogle) {
                                            return Positioned(
                                              bottom: 20.sp,
                                              left: 0,
                                              right: 0,
                                              child: Container(
                                                height: 75.w,
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 6.w),
                                                  child: PageView.builder(
                                                    controller: PageController(
                                                        initialPage: clickindex,
                                                        keepPage: true,
                                                        viewportFraction: 1),
                                                    itemCount: state
                                                        .GetDataFormGoogle
                                                        .length,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    onPageChanged:
                                                        (index) async {
                                                      // New Marker
                                                    },
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Container(
                                                            width: 90.w,
                                                            child: Card(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15.0),
                                                              ),
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            2.w),
                                                                child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      if (state
                                                                              .GetDataFormGoogle[index]
                                                                              .photos !=
                                                                          null) ...[
                                                                        Padding(
                                                                          padding: EdgeInsets.symmetric(
                                                                              horizontal: 2.w,
                                                                              vertical: 0),
                                                                          child:
                                                                              Theme(
                                                                            data:
                                                                                ThemeData(progressIndicatorTheme: ProgressIndicatorThemeData(color: Theme.of(context).iconTheme.color)),
                                                                            child:
                                                                                GalleryImage(
                                                                              numOfShowImages: imagelen(state.GetDataFormGoogle[index].photos.length),
                                                                              imageUrls: List.from(state.GetDataFormGoogle[index].photos.map((e) => "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=${e.photoReference}&key=AIzaSyBuXdZID9cJRjTQ_DKW6rMIBsWYHSDIFjw")),
                                                                              titleGallery: "Photo",
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                      ListTile(
                                                                          dense:
                                                                              true,
                                                                          minVerticalPadding:
                                                                              0,
                                                                          visualDensity: const VisualDensity(
                                                                              horizontal:
                                                                                  0,
                                                                              vertical:
                                                                                  -4),
                                                                          trailing:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.end,
                                                                            children: [
                                                                              SizedBox(
                                                                                height: 2.w,
                                                                              ),
                                                                              if (state.GetDataFormGoogle[index].openingHours != null) ...[
                                                                                if (state.GetDataFormGoogle[index].openingHours.openNow) ...[
                                                                                  Text(
                                                                                    "open",
                                                                                    style: TextStyle(fontSize: 12.sp, color: Colors.green),
                                                                                  )
                                                                                ] else ...[
                                                                                  Text(
                                                                                    "close",
                                                                                    style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                                                                                  )
                                                                                ]
                                                                              ]
                                                                            ],
                                                                          ),
                                                                          title:
                                                                              Text(
                                                                            state.GetDataFormGoogle[index].name,
                                                                            style: TextStyle(
                                                                                fontSize: 15.sp,
                                                                                color: Theme.of(context).iconTheme.color,
                                                                                fontWeight: FontWeight.bold),
                                                                          ),
                                                                          subtitle:
                                                                              Row(
                                                                            children: [
                                                                              if (state.GetDataFormGoogle[index].rating != null) ...[
                                                                                GFRating(
                                                                                  size: 12.sp,
                                                                                  value: double.parse(state.GetDataFormGoogle[index].rating.toString() ?? "0.0"),
                                                                                  color: Colors.orange,
                                                                                ),
                                                                              ] else ...[
                                                                                GFRating(
                                                                                  size: 12.sp,
                                                                                  value: 0.0,
                                                                                  color: Colors.orange,
                                                                                ),
                                                                              ],
                                                                              SizedBox(
                                                                                width: 2.sp,
                                                                              ),
                                                                              Text(
                                                                                "${state.GetDataFormGoogle[index].userRatingsTotal ?? "0"} review",
                                                                                style: TextStyle(color: Theme.of(context).iconTheme.color),
                                                                              )
                                                                            ],
                                                                          )),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              4.w,
                                                                        ),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Icon(
                                                                                  Icons.location_on,
                                                                                  size: 12.sp,
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 70.w,
                                                                                  child: Text(
                                                                                    state.GetDataFormGoogle[index].formattedAddress,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    style: TextStyle(
                                                                                      fontSize: 12.sp,
                                                                                      color: Theme.of(context).iconTheme.color,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            2.w,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceAround,
                                                                        children: [
                                                                          FutureBuilder<bool>(
                                                                              future: CheckBusinessSataus(id: state.GetDataFormGoogle[index].placeId.toString()),
                                                                              builder: (context, snapshot) {
                                                                                if (snapshot.hasData) {
                                                                                  if (snapshot.data == true) {
                                                                                    return Padding(
                                                                                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                                                                                      child: GestureDetector(
                                                                                        onTap: () {},
                                                                                        child: AnimatedContainer(
                                                                                          duration: Duration(milliseconds: 300),
                                                                                          height: 30.sp,
                                                                                          width: 30.w,
                                                                                          alignment: Alignment.center,
                                                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.sp), border: Border.all(color: Theme.of(context).iconTheme.color)),
                                                                                          child: Text(
                                                                                            "Connect Hangout",
                                                                                            style: TextStyle(fontSize: 12.sp, color: Theme.of(context).iconTheme.color),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  } else {
                                                                                    return Padding(
                                                                                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                                                                                      child: GestureDetector(
                                                                                        onTap: () {
                                                                                          Navigator.of(context).push(MaterialPageRoute(
                                                                                              builder: (context) => BusinessIntro(
                                                                                                    business: state.GetDataFormGoogle[index],
                                                                                                  )));
                                                                                        },
                                                                                        child: AnimatedContainer(
                                                                                          duration: Duration(milliseconds: 300),
                                                                                          height: 30.sp,
                                                                                          width: 60.w,
                                                                                          alignment: Alignment.center,
                                                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.sp), border: Border.all(color: Theme.of(context).iconTheme.color)),
                                                                                          child: Text(
                                                                                            "Create Hangout",
                                                                                            style: TextStyle(fontSize: 12.sp, color: Theme.of(context).iconTheme.color),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  }
                                                                                } else {
                                                                                  return CupertinoActivityIndicator();
                                                                                }
                                                                              }),
                                                                          Padding(
                                                                            padding:
                                                                                EdgeInsets.only(right: 2.w),
                                                                            child:
                                                                                GestureDetector(
                                                                              onTap: () {},
                                                                              child: Container(
                                                                                height: 30.sp,
                                                                                width: 15.w,
                                                                                alignment: Alignment.center,
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.blue,
                                                                                  borderRadius: BorderRadius.circular(8.sp),
                                                                                ),
                                                                                child: Icon(
                                                                                  Icons.directions_run,
                                                                                  color: Colors.white,
                                                                                  size: 18.sp,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ]),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Positioned(
                                                bottom: 20.sp,
                                                left: 0,
                                                right: 0,
                                                child: Container());
                                          }
                                        },
                                      )
                                    : Container()
                              ],
                            );
                          } else {
                            return Center(
                              child: lottic.Lottie.asset(
                                  "assets/image/mapani.json"),
                            );
                          }
                        }));
              } else {
                return Center(
                  child: lottic.Lottie.asset(
                    "assets/image/nointernet.json",
                    width: 70.w,
                  ),
                );
              }
            } else {
              return Center(
                child: lottic.Lottie.asset("assets/image/mapani.json",
                    width: 40.w),
              );
            }
          }),
    );
  }

  void MaponTap(value) async {
    _markers = [];
    //Get Place Id Form Google
    var googleGeocoding =
        geocode.GoogleGeocoding("AIzaSyBuXdZID9cJRjTQ_DKW6rMIBsWYHSDIFjw");
    var risult = await googleGeocoding.geocoding
        .getReverse(geocode.LatLon(value.latitude, value.longitude));

    // Add Marker in Maps
  }

  void autoCompleteSearch(String value) async {
    try {
      final googlePlace =
          GooglePlace("AIzaSyBuXdZID9cJRjTQ_DKW6rMIBsWYHSDIFjw");

      var result = await googlePlace.queryAutocomplete.get(value);

      if (result != null && result.predictions != null && mounted) {
        setState(() {
          predictions = result.predictions;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> CheckBusinessSataus({String id}) async {
    final data = await FirebaseFirestore.instance
        .collection("marker")
        .where("Business_Id", isEqualTo: id)
        .get();

    return data.docs.isNotEmpty;
  }

  int imagelen(int number) {
    if (number > 2) {
      return 3;
    } else if (number == 2) {
      return 2;
    } else if (number == 1) {
      return 1;
    }
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
