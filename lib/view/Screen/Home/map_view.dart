import 'dart:async';
import 'package:chatting/view/Screen/business/businessintro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_marker/marker_icon.dart';
import 'package:google_place/google_place.dart' as PlaceAPI;
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:chatting/Helper/color.dart';
import 'package:chatting/logic/BusinessInfoGet/business_info_get_cubit.dart';
import 'package:chatting/logic/Google_Search/cubit/map_search_cubit.dart';
import 'package:chatting/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:permission_handler/permission_handler.dart';

import 'package:sizer/sizer.dart';

class Map_view extends StatefulWidget {
  const Map_view({Key key}) : super(key: key);

  @override
  _Map_viewState createState() => _Map_viewState();
}

class _Map_viewState extends State<Map_view> {
  TextEditingController search = TextEditingController();
  Completer<GoogleMapController> _controller = Completer();

  List<Marker> _markers = [];
  List<PlaceAPI.SearchResult> MarkerDataList;
  bool hiden_show = false;
  bool isloading = false;
  int list_item;
  double lat = 0;
  double lng = 0;
  String myID;
  int dataindex = 0;
  Position position = Position();
  int markerIdCounter = 1;
  List<String> Image = [];
  List<PlaceAPI.AutocompletePrediction> predictions = [];
  bool connectionChecker = false;
  bool areaSearch = false;
  int oldindex = 1;
  int radius = 2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getmyuid();
    Permission.location.request().isGranted;
  }

  void getmyuid() async {
    setState(() {
      myID = sharedPreferences.getString('uid');
    });
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
                                      for (var i = 0;
                                          i < state.GetDataFormGoogle.length;
                                          i++) {
                                        final GoogleMapController controller =
                                            await _controller.future;

                                        controller.animateCamera(
                                            CameraUpdate.newCameraPosition(
                                                CameraPosition(
                                          zoom: 12,
                                          target: LatLng(
                                              state.GetDataFormGoogle[0]
                                                  .geometry.location.lat,
                                              state.GetDataFormGoogle[0]
                                                  .geometry.location.lng),
                                        )));
                                        var counter = markerIdCounter++;

                                        final Marker marker = Marker(
                                            markerId:
                                                MarkerId('marker_$counter'),
                                            position: LatLng(
                                                state.GetDataFormGoogle[i]
                                                    .geometry.location.lat,
                                                state.GetDataFormGoogle[i]
                                                    .geometry.location.lng),
                                            onTap: () {
                                              setState(() {
                                                hiden_show = true;
                                              });
                                            },
                                            icon:
                                                BitmapDescriptor.defaultMarker);

                                        setState(() {
                                          _markers.add(marker);
                                        });
                                      }
                                    }
                                    if (state is MoveSearch) {
                                      for (var i = 0;
                                          i < state.MoveSearchs.length;
                                          i++) {
                                        var counter = markerIdCounter++;
                                        print(state.MoveSearchs[i].placeId
                                            .trim());
                                        final Marker marker = Marker(
                                            markerId:
                                                MarkerId('marker_$counter'),
                                            position: LatLng(
                                                state.MoveSearchs[i].geometry
                                                    .location.lat,
                                                state.MoveSearchs[i].geometry
                                                    .location.lng),
                                            onTap: () {
                                              setState(() {
                                                hiden_show = true;
                                              });
                                            },
                                            infoWindow: InfoWindow(
                                                title:
                                                    state.MoveSearchs[i].name,
                                                snippet: state.MoveSearchs[i]
                                                    .formattedAddress),
                                            icon:
                                                BitmapDescriptor.defaultMarker);

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
                                    if (state is MoveSearch) {
                                      return GoogleMap(
                                        onCameraMove: ((position) {
                                          setState(() {
                                            areaSearch = true;
                                            lat = position.target.latitude;
                                            lng = position.target.longitude;
                                          });
                                        }),
                                        initialCameraPosition: CameraPosition(
                                          target: LatLng(snapshot.data.latitude,
                                              snapshot.data.longitude),
                                          zoom: 14,
                                        ),
                                        // onTap: MaponTap,
                                        mapType: MapType.normal,
                                        zoomControlsEnabled: false,
                                        myLocationEnabled: true,
                                        myLocationButtonEnabled: false,
                                        markers: Set.of(_markers),
                                        onMapCreated:
                                            (GoogleMapController controller) {
                                          _controller.complete(controller);
                                        },
                                      );
                                    }
                                    if (state is GetDataformGoogle) {
                                      // print(position);

                                      return GoogleMap(
                                        onCameraMove: (position) {
                                          setState(() {
                                            areaSearch = true;
                                            lat = position.target.latitude;
                                            lng = position.target.longitude;
                                          });
                                        },
                                        initialCameraPosition: CameraPosition(
                                          target: LatLng(snapshot.data.latitude,
                                              snapshot.data.longitude),
                                          zoom: 14,
                                        ),
                                        //onTap: MaponTap,
                                        mapType: MapType.normal,
                                        zoomControlsEnabled: false,
                                        myLocationEnabled: true,
                                        myLocationButtonEnabled: false,
                                        markers: Set.of(_markers),
                                        onMapCreated:
                                            (GoogleMapController controller) {
                                          _controller.complete(controller);
                                        },
                                      );
                                    } else {
                                      return GoogleMap(
                                        initialCameraPosition: CameraPosition(
                                          target: LatLng(snapshot.data.latitude,
                                              snapshot.data.longitude),
                                          zoom: 14,
                                        ),
                                        //onTap: MaponTap,
                                        onCameraMove: (position) =>
                                            print(position),
                                        mapType: MapType.normal,
                                        zoomControlsEnabled: false,
                                        myLocationEnabled: true,
                                        myLocationButtonEnabled: false,
                                        markers: Set.of(_markers),
                                        onMapCreated:
                                            (GoogleMapController controller) {
                                          _controller.complete(controller);
                                        },
                                      );
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
                                            color: Theme.of(context)
                                                .secondaryHeaderColor
                                                .withOpacity(0.6),
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
                                              isloading = true;
                                              String searchkey = value;
                                              _markers = [];
                                              predictions = [];
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
                                                    itemCount: state
                                                        .GetDataFormGoogle
                                                        .length,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    onPageChanged:
                                                        (index) async {
                                                      // New Marker
                                                      final GoogleMapController
                                                          controller =
                                                          await _controller
                                                              .future;

                                                      controller.animateCamera(
                                                          CameraUpdate
                                                              .newCameraPosition(
                                                                  CameraPosition(
                                                        zoom: 15,
                                                        target: LatLng(
                                                            state
                                                                .GetDataFormGoogle[
                                                                    index]
                                                                .geometry
                                                                .location
                                                                .lat,
                                                            state
                                                                .GetDataFormGoogle[
                                                                    index]
                                                                .geometry
                                                                .location
                                                                .lng),
                                                      )));
                                                      var counter =
                                                          markerIdCounter++;

                                                      final Marker marker =
                                                          Marker(
                                                              markerId: MarkerId(
                                                                  'marker_$counter'),
                                                              position: LatLng(
                                                                  state
                                                                      .GetDataFormGoogle[
                                                                          index]
                                                                      .geometry
                                                                      .location
                                                                      .lat,
                                                                  state
                                                                      .GetDataFormGoogle[
                                                                          index]
                                                                      .geometry
                                                                      .location
                                                                      .lng),
                                                              onTap: () {
                                                                setState(() {
                                                                  hiden_show =
                                                                      true;
                                                                });
                                                              },
                                                              icon:
                                                                  await MarkerIcon
                                                                      .svgAsset(
                                                                assetName:
                                                                    "assets/svg/place.svg",
                                                                context:
                                                                    context,
                                                                size: 30.sp,
                                                              ));

                                                      // New Marker End
                                                      if (oldindex != index) {
                                                        final Marker marker = Marker(
                                                            markerId: MarkerId(state
                                                                .GetDataFormGoogle[
                                                                    oldindex]
                                                                .placeId
                                                                .toString()),
                                                            position: LatLng(
                                                                state
                                                                    .GetDataFormGoogle[
                                                                        oldindex]
                                                                    .geometry
                                                                    .location
                                                                    .lat,
                                                                state
                                                                    .GetDataFormGoogle[
                                                                        oldindex]
                                                                    .geometry
                                                                    .location
                                                                    .lng),
                                                            icon: BitmapDescriptor
                                                                .defaultMarker);

                                                        setState(() {
                                                          _markers[oldindex] =
                                                              marker;
                                                        });
                                                      }
                                                      setState(() {
                                                        _markers[index] =
                                                            marker;
                                                        oldindex = index;
                                                      });
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
                              child: lottie.Lottie.asset(
                                  "assets/image/mapani.json"),
                            );
                          }
                        }));
              } else {
                return Center(
                  child: lottie.Lottie.asset(
                    "assets/image/nointernet.json",
                    width: 70.w,
                  ),
                );
              }
            } else {
              return Center(
                child: lottie.Lottie.asset("assets/image/mapani.json",
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
        GoogleGeocoding("AIzaSyBuXdZID9cJRjTQ_DKW6rMIBsWYHSDIFjw");
    var risult = await googleGeocoding.geocoding
        .getReverse(LatLon(value.latitude, value.longitude));

    print(risult.results[1].placeId);
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      zoom: 14,
      target: LatLng(risult.results[1].geometry.location.lat,
          risult.results[1].geometry.location.lng),
    )));
    // Add Marker in Maps
    var counter = markerIdCounter++;
    final Marker marker = Marker(
        markerId: MarkerId('marker_$counter'),
        position: LatLng(risult.results[1].geometry.location.lat,
            risult.results[1].geometry.location.lng),
        onTap: () {
          // Marker Clickable
          setState(() {
            hiden_show = true;
          });
        },
        infoWindow: InfoWindow(snippet: risult.results[0].formattedAddress),
        icon: BitmapDescriptor.defaultMarker);

    setState(() {
      _markers.add(marker);
    });

    // setState(() {
    //   hiden_show = true;
    //   context
    //       .read<BusinessInfoGetCubit>()
    //       .GetDataFormGoogleGet(
    //           id: risult.results[1].placeId.trim(),
    //           name: risult
    //               .results[1].formattedAddress
    //               .replaceAll(" ", ''));
    // });
  }

  void autoCompleteSearch(String value) async {
    try {
      final googlePlace =
          PlaceAPI.GooglePlace("AIzaSyBuXdZID9cJRjTQ_DKW6rMIBsWYHSDIFjw");

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
