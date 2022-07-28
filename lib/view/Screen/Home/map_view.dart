import 'dart:async';
import 'package:chatting/Helper/enum.dart';
import 'package:map_launcher/map_launcher.dart' as direction;
import "dart:math" show pi;
import 'package:chatting/Helper/color.dart';
import 'package:chatting/Helper/mapstyle/light.dart';
import 'package:chatting/logic/BusinessInfoGet/business_info_get_cubit.dart';
import 'package:chatting/logic/Google_Search/cubit/map_search_cubit.dart';
import 'package:chatting/main.dart';
import 'package:chatting/view/Screen/business/businessintro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:google_geocoding/google_geocoding.dart' as geocode;
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  List<Marker> _markers = [];
  Completer<GoogleMapController> _controller = Completer();
  List<String> valueadd = [];
  List<SearchResult> MarkerDataList;
  bool hiden_show = false;
  bool isloading = false;
  int list_item;
  double lat = 0;
  double lng = 0;
  String myID;
  Filtermap fileterzoom = Filtermap.None;
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

    getmyuid();
    Permission.location.request().isGranted;
  }

  void getmyuid() async {
    setState(() {
      myID = sharedPreferences.getString('uid');
    });
  }

  Future<bool> checkbusiness({String id}) async {
    final result = await FirebaseFirestore.instance
        .collection("marker")
        .where("Business_Id", isEqualTo: id)
        .get();

    return result.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    context.read<MapSearchCubit>().DefaultMapDataFirebase();
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
                                    if (state is DefaultMapdata) {
                                      print(state.defaultdata.length);
                                    }
                                    if (state is GetDataformGoogle) {
                                      setState(() {
                                        isloading = false;
                                        MarkerDataList =
                                            state.GetDataFormGoogle;
                                      });

                                      if (fileterzoom == Filtermap.None) {
                                        final GoogleMapController controller =
                                            await _controller.future;
                                        controller.animateCamera(
                                            CameraUpdate.newCameraPosition(
                                                CameraPosition(
                                          target: LatLng(
                                              state.GetDataFormGoogle[0]
                                                  .geometry.location.lat,
                                              state.GetDataFormGoogle[0]
                                                  .geometry.location.lng),
                                          zoom: 14.4746,
                                        )));
                                      } else if (fileterzoom ==
                                          Filtermap.Nearme) {
                                        final GoogleMapController controller =
                                            await _controller.future;
                                        controller.animateCamera(
                                            CameraUpdate.newCameraPosition(
                                                CameraPosition(
                                          target: LatLng(
                                              state.GetDataFormGoogle[0]
                                                  .geometry.location.lat,
                                              state.GetDataFormGoogle[0]
                                                  .geometry.location.lng),
                                          zoom: 14.4746,
                                        )));
                                      } else if (fileterzoom ==
                                          Filtermap.city) {
                                        final GoogleMapController controller =
                                            await _controller.future;
                                        controller.animateCamera(
                                            CameraUpdate.newCameraPosition(
                                                CameraPosition(
                                          target: LatLng(
                                              state.GetDataFormGoogle[0]
                                                  .geometry.location.lat,
                                              state.GetDataFormGoogle[0]
                                                  .geometry.location.lng),
                                          zoom: 8.4746,
                                        )));
                                      } else if (fileterzoom ==
                                          Filtermap.Country) {
                                        final GoogleMapController controller =
                                            await _controller.future;
                                        controller.animateCamera(
                                            CameraUpdate.newCameraPosition(
                                                CameraPosition(
                                          target: LatLng(
                                              state.GetDataFormGoogle[0]
                                                  .geometry.location.lat,
                                              state.GetDataFormGoogle[0]
                                                  .geometry.location.lng),
                                          zoom: 5.4746,
                                        )));
                                      } else if (fileterzoom ==
                                          Filtermap.NoLimit) {
                                        final GoogleMapController controller =
                                            await _controller.future;
                                        controller.animateCamera(
                                            CameraUpdate.newCameraPosition(
                                                CameraPosition(
                                          target: LatLng(
                                              state.GetDataFormGoogle[0]
                                                  .geometry.location.lat,
                                              state.GetDataFormGoogle[0]
                                                  .geometry.location.lng),
                                          zoom: .5,
                                        )));
                                      }

                                      for (var i = 1;
                                          i < state.GetDataFormGoogle.length;
                                          i++) {
                                        print(
                                            state.GetDataFormGoogle[i].placeId);
                                        await checkbusiness(
                                                id: state.GetDataFormGoogle[i]
                                                    .placeId)
                                            .then((value) async {
                                          final marker = Marker(
                                            onTap: (() {
                                              setState(() async {
                                                oldindex = i;
                                                hiden_show = true;
                                                await checkbusiness(
                                                        id: state
                                                            .GetDataFormGoogle[
                                                                i]
                                                            .placeId)
                                                    .then((value) async {
                                                  print(value);
                                                  final GoogleMapController
                                                      controller =
                                                      await _controller.future;
                                                  controller.animateCamera(
                                                      CameraUpdate
                                                          .newCameraPosition(
                                                              CameraPosition(
                                                    target: LatLng(
                                                        state
                                                            .GetDataFormGoogle[
                                                                i]
                                                            .geometry
                                                            .location
                                                            .lat,
                                                        state
                                                            .GetDataFormGoogle[
                                                                i]
                                                            .geometry
                                                            .location
                                                            .lng),
                                                    zoom: 14.4746,
                                                  )));
                                                  final marker = Marker(
                                                    onTap: (() {
                                                      setState(() {
                                                        oldindex = i;
                                                        hiden_show = true;
                                                      });
                                                    }),
                                                    markerId:
                                                        MarkerId(i.toString()),
                                                    position: LatLng(
                                                        state
                                                            .GetDataFormGoogle[
                                                                i]
                                                            .geometry
                                                            .location
                                                            .lat,
                                                        state
                                                            .GetDataFormGoogle[
                                                                i]
                                                            .geometry
                                                            .location
                                                            .lng),
                                                    icon: await MarkerIcon.svgAsset(
                                                        assetName: value
                                                            ? "assets/markerIcon/se.svg"
                                                            : "assets/markerIcon/ese.svg",
                                                        context: context,
                                                        size: 12.w),
                                                  );

                                                  setState(() {
                                                    _markers[i] = marker;
                                                  });
                                                });
                                              });
                                            }),
                                            markerId: MarkerId(i.toString()),
                                            position: LatLng(
                                                state.GetDataFormGoogle[i]
                                                    .geometry.location.lat,
                                                state.GetDataFormGoogle[i]
                                                    .geometry.location.lng),
                                            icon: await MarkerIcon.svgAsset(
                                                assetName: value
                                                    ? "assets/markerIcon/un.svg"
                                                    : "assets/markerIcon/eun.svg",
                                                context: context,
                                                size: 12.w),
                                          );

                                          setState(() {
                                            _markers.add(marker);
                                          });
                                        });
                                      }
                                    }
                                    if (state is MoveSearch) {
                                      for (var i = 0;
                                          i < state.MoveSearchs.length;
                                          i++) {
                                        await checkbusiness(
                                                id: state
                                                    .MoveSearchs[i].placeId)
                                            .then((value) async {
                                          final markers = Marker(
                                            markerId: MarkerId(i.toString()),
                                            position: LatLng(
                                                state.MoveSearchs[i].geometry
                                                    .location.lat,
                                                state.MoveSearchs[i].geometry
                                                    .location.lng),
                                            icon: await MarkerIcon.svgAsset(
                                                assetName: value
                                                    ? "assets/markerIcon/un.svg"
                                                    : "assets/markerIcon/eun.svg",
                                                context: context,
                                                size: 12.w),
                                          );

                                          setState(() {
                                            _markers.add(markers);
                                          });
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
                                            lat = position.target.latitude;
                                            lng = position.target.longitude;
                                            areaSearch = true;
                                          });
                                        }),
                                        markers: Set.from(_markers),
                                        myLocationButtonEnabled: true,
                                        myLocationEnabled: true,
                                        zoomControlsEnabled: false,
                                        mapType: MapType.normal,
                                        initialCameraPosition: CameraPosition(
                                          target: LatLng(snapshot.data.latitude,
                                              snapshot.data.longitude),
                                          zoom: 14.4746,
                                        ),
                                        onMapCreated:
                                            (GoogleMapController controller) {
                                          _controller.complete(controller);
                                          controller.setMapStyle(
                                              isDarkMode ? dark : light);
                                        },
                                      );
                                    }
                                    if (state is GetDataformGoogle) {
                                      return GoogleMap(
                                        onCameraMove: ((position) {
                                          setState(() {
                                            lat = position.target.latitude;
                                            lng = position.target.longitude;
                                            areaSearch = true;
                                          });
                                        }),
                                        markers: Set.from(_markers),
                                        mapType: MapType.normal,
                                        myLocationButtonEnabled: true,
                                        myLocationEnabled: true,
                                        zoomControlsEnabled: false,
                                        initialCameraPosition: CameraPosition(
                                          target: LatLng(snapshot.data.latitude,
                                              snapshot.data.longitude),
                                          zoom: 14.4746,
                                        ),
                                        onMapCreated:
                                            (GoogleMapController controller) {
                                          _controller.complete(controller);

                                          controller.setMapStyle(
                                              isDarkMode ? dark : light);
                                        },
                                      );
                                    }
                                    if (state is DefaultMapdata) {
                                      return GoogleMap(
                                        onCameraMove: ((position) {
                                          print(position.target.latitude);
                                        }),
                                        mapType: MapType.normal,
                                        myLocationButtonEnabled: true,
                                        myLocationEnabled: true,
                                        zoomControlsEnabled: false,
                                        initialCameraPosition: CameraPosition(
                                          target: LatLng(snapshot.data.latitude,
                                              snapshot.data.longitude),
                                          zoom: 14.4746,
                                        ),
                                        onMapCreated:
                                            (GoogleMapController controller) {
                                          _controller.complete(controller);
                                          controller.setMapStyle(
                                              isDarkMode ? dark : light);
                                        },
                                      );
                                    } else {
                                      return Container();
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
                                                  showModalBottomSheet(
                                                      backgroundColor: Theme.of(
                                                              context)
                                                          .secondaryHeaderColor,
                                                      context: context,
                                                      builder: (context) {
                                                        return Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            SizedBox(
                                                              height: 2.w,
                                                            ),
                                                            GestureDetector(
                                                                onTap: search
                                                                        .text
                                                                        .isEmpty
                                                                    ? null
                                                                    : () {
                                                                        setState(
                                                                            () {
                                                                          isloading =
                                                                              true;
                                                                        });
                                                                        context
                                                                            .read<
                                                                                MapSearchCubit>()
                                                                            .FilterMap(
                                                                                address: search.text.replaceAll(" ", "%"),
                                                                                radius: 30)
                                                                            .then((value) {
                                                                          setState(
                                                                              () {
                                                                            fileterzoom =
                                                                                Filtermap.Nearme;
                                                                          });
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        });
                                                                      },
                                                                child:
                                                                    Container(
                                                                  height: 10.w,
                                                                  width: 50.w,
                                                                  decoration: fileterzoom !=
                                                                          Filtermap
                                                                              .Nearme
                                                                      ? BoxDecoration()
                                                                      : BoxDecoration(
                                                                          border: Border.all(
                                                                              width: 1,
                                                                              color: Colors.grey),
                                                                          borderRadius: BorderRadius.circular(5.sp)),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                    "Near me",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .blue,
                                                                        fontSize: 15
                                                                            .sp,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                )),
                                                            SizedBox(
                                                              height: 2.w,
                                                            ),
                                                            GestureDetector(
                                                                onTap: search
                                                                        .text
                                                                        .isEmpty
                                                                    ? null
                                                                    : () {
                                                                        setState(
                                                                            () {
                                                                          isloading =
                                                                              true;
                                                                        });
                                                                        context
                                                                            .read<
                                                                                MapSearchCubit>()
                                                                            .FilterMap(
                                                                                address: search.text.replaceAll(" ", "%"),
                                                                                radius: 1000 * pi.toInt())
                                                                            .then((value) {
                                                                          setState(
                                                                              () {
                                                                            fileterzoom =
                                                                                Filtermap.city;
                                                                          });
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        });
                                                                      },
                                                                child:
                                                                    Container(
                                                                  height: 10.w,
                                                                  width: 50.w,
                                                                  decoration: fileterzoom !=
                                                                          Filtermap
                                                                              .city
                                                                      ? BoxDecoration()
                                                                      : BoxDecoration(
                                                                          border: Border.all(
                                                                              width: 1,
                                                                              color: Colors.grey),
                                                                          borderRadius: BorderRadius.circular(5.sp)),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                    "City",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .blue,
                                                                        fontSize: 15
                                                                            .sp,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                )),
                                                            SizedBox(
                                                              height: 2.w,
                                                            ),
                                                            GestureDetector(
                                                                onTap: search
                                                                        .text
                                                                        .isEmpty
                                                                    ? null
                                                                    : () {
                                                                        setState(
                                                                            () {
                                                                          isloading =
                                                                              true;
                                                                        });
                                                                        context
                                                                            .read<
                                                                                MapSearchCubit>()
                                                                            .FilterMap(
                                                                                address: search.text.replaceAll(" ", "%"),
                                                                                radius: 100000 * pi.toInt())
                                                                            .then((value) {
                                                                          setState(
                                                                              () {
                                                                            fileterzoom =
                                                                                Filtermap.Country;
                                                                          });
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        });
                                                                      },
                                                                child:
                                                                    Container(
                                                                  height: 10.w,
                                                                  width: 50.w,
                                                                  decoration: fileterzoom !=
                                                                          Filtermap
                                                                              .Country
                                                                      ? BoxDecoration()
                                                                      : BoxDecoration(
                                                                          border: Border.all(
                                                                              width: 1,
                                                                              color: Colors.grey),
                                                                          borderRadius: BorderRadius.circular(5.sp)),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                    "Country",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .blue,
                                                                        fontSize: 15
                                                                            .sp,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                )),
                                                            SizedBox(
                                                              height: 2.w,
                                                            ),
                                                            GestureDetector(
                                                                onTap: search
                                                                        .text
                                                                        .isEmpty
                                                                    ? null
                                                                    : () {
                                                                        setState(
                                                                            () {
                                                                          isloading =
                                                                              true;
                                                                        });
                                                                        context
                                                                            .read<
                                                                                MapSearchCubit>()
                                                                            .FilterMap(
                                                                                address: search.text.replaceAll(" ", "%"),
                                                                                radius: 10000000 * pi.toInt())
                                                                            .then((value) {
                                                                          setState(
                                                                              () {
                                                                            fileterzoom =
                                                                                Filtermap.NoLimit;
                                                                          });
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        });
                                                                      },
                                                                child:
                                                                    Container(
                                                                  height: 10.w,
                                                                  width: 50.w,
                                                                  decoration: fileterzoom !=
                                                                          Filtermap
                                                                              .NoLimit
                                                                      ? BoxDecoration()
                                                                      : BoxDecoration(
                                                                          border: Border.all(
                                                                              width: 1,
                                                                              color: Colors.grey),
                                                                          borderRadius: BorderRadius.circular(5.sp)),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                    "No Limit",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .blue,
                                                                        fontSize: 15
                                                                            .sp,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                )),
                                                            SizedBox(
                                                              height: 2.w,
                                                            ),
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: Text(
                                                                  "Cancel",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red,
                                                                      fontSize:
                                                                          15.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                )),
                                                            SizedBox(
                                                              height: 5.w,
                                                            )
                                                          ],
                                                        );
                                                      });
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
                                                        initialPage: oldindex,
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

                                                      if (oldindex != index) {
                                                        setState(() {
                                                          print(oldindex);
                                                          //1
                                                        });
                                                        await checkbusiness(
                                                                id: state
                                                                    .GetDataFormGoogle[
                                                                        oldindex]
                                                                    .placeId)
                                                            .then(
                                                                (value) async {
                                                          final marker = Marker(
                                                            onTap: (() {
                                                              setState(() {
                                                                oldindex =
                                                                    index;
                                                                hiden_show =
                                                                    true;
                                                              });
                                                            }),
                                                            markerId: MarkerId(
                                                                oldindex
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
                                                            icon: await MarkerIcon.svgAsset(
                                                                assetName: value
                                                                    ? "assets/markerIcon/un.svg"
                                                                    : "assets/markerIcon/eun.svg",
                                                                context:
                                                                    context,
                                                                size: 12.w),
                                                          );

                                                          setState(() {
                                                            _markers[oldindex] =
                                                                marker;
                                                          });
                                                        });
                                                      }

                                                      await checkbusiness(
                                                              id: state
                                                                  .GetDataFormGoogle[
                                                                      index]
                                                                  .placeId)
                                                          .then((value) async {
                                                        print(value);
                                                        final GoogleMapController
                                                            controller =
                                                            await _controller
                                                                .future;
                                                        controller.animateCamera(
                                                            CameraUpdate
                                                                .newCameraPosition(
                                                                    CameraPosition(
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
                                                          zoom: 14.4746,
                                                        )));
                                                        final marker = Marker(
                                                          onTap: (() {
                                                            setState(() {
                                                              oldindex = index;
                                                              hiden_show = true;
                                                            });
                                                          }),
                                                          markerId: MarkerId(
                                                              index.toString()),
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
                                                          icon: await MarkerIcon.svgAsset(
                                                              assetName: value
                                                                  ? "assets/markerIcon/se.svg"
                                                                  : "assets/markerIcon/ese.svg",
                                                              context: context,
                                                              size: 12.w),
                                                        );

                                                        setState(() {
                                                          oldindex = index;
                                                          print(index);
                                                          _markers[index] =
                                                              marker;
                                                        });
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
                                                                          StreamBuilder<QuerySnapshot>(
                                                                              stream: FirebaseFirestore.instance.collection("marker").where("Business_Id", isEqualTo: state.GetDataFormGoogle[index].placeId).snapshots(),
                                                                              builder: (context, snapshot) {
                                                                                if (snapshot.hasData) {
                                                                                  if (snapshot.data.docs.isNotEmpty) {
                                                                                    return Padding(
                                                                                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                                                                                      child: GestureDetector(
                                                                                        onTap: () {},
                                                                                        child: AnimatedContainer(
                                                                                          duration: Duration(milliseconds: 300),
                                                                                          height: 30.sp,
                                                                                          width: 60.w,
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
                                                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.sp), border: Border.all(color: Colors.grey, width: 1)),
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
                                                                              onTap: () {
                                                                                MapsSheet.show(
                                                                                  context: context,
                                                                                  onMapTap: (map) {
                                                                                    map.showDirections(
                                                                                      destination: direction.Coords(
                                                                                        state.GetDataFormGoogle[index].geometry.location.lat,
                                                                                        state.GetDataFormGoogle[index].geometry.location.lng,
                                                                                      ),
                                                                                      destinationTitle: state.GetDataFormGoogle[index].name,
                                                                                      origin: direction.Coords(snapshot.data.latitude, snapshot.data.longitude),
                                                                                      originTitle: "Me",
                                                                                      directionsMode: direction.DirectionsMode.driving,
                                                                                    );
                                                                                  },
                                                                                );
                                                                              },
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
                                  "assets/image/mapani.json",
                                  width: 40.w),
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

  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///Map Slider
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
  ///
  ///

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

class MapsSheet {
  static show({
    BuildContext context,
    Function(direction.AvailableMap map) onMapTap,
  }) async {
    final availableMaps = await direction.MapLauncher.installedMaps;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    child: Wrap(
                      children: <Widget>[
                        for (var map in availableMaps)
                          ListTile(
                            onTap: () => onMapTap(map),
                            title: Text(map.mapName),
                            leading: SvgPicture.asset(
                              map.icon,
                              height: 30.0,
                              width: 30.0,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
