import 'dart:async';
import 'package:chatting/Helper/config.dart';
import 'package:chatting/Helper/enum.dart';
import 'package:chatting/logic/YelpSearch/yelp_search_cubit.dart';

import 'package:chatting/model/yelp/yelp_model.dart';

import 'package:getwidget/getwidget.dart';
import 'package:map_launcher/map_launcher.dart' as direction;

import 'package:http/http.dart' as http;
import 'package:chatting/Helper/color.dart';
import 'package:chatting/Helper/mapstyle/light.dart';
import 'package:chatting/logic/BusinessInfoGet/business_info_get_cubit.dart';
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
import 'package:google_geocoding/google_geocoding.dart' as geocode;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart' as lottic;
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:yelp_fusion_client/models/business_endpoints/business_details.dart';

class Map_view extends StatefulWidget {
  const Map_view({Key key}) : super(key: key);

  @override
  _Map_viewState createState() => _Map_viewState();
}

class _Map_viewState extends State<Map_view> {
  TextEditingController search = TextEditingController();
  TextEditingController address = TextEditingController();
  List<Marker> _markers = [];
  Completer<GoogleMapController> _controller = Completer();
  List<String> valueadd = [];
  List<Businesses> MarkerDataList;
  bool hiden_show = false;
  bool isloading = false;
  int list_item;
  double lat = 0;
  double lng = 0;
  String myID;
  Filtermap fileterzoom = Filtermap.None;
  Position position = Position();

  List<String> Image = [];
  List<AutocompletePrediction> predictions = [];
  bool connectionChecker = false;
  bool areaSearch = false;
  int oldindex = 0;
  int radius = 2;
  int clickindex = 0;
  bool Termclearhideshow = false;
  bool Addressclearhideshow = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<MapSearchCubit>(context).DefaultMapDataFirebase();
    getmyuid();
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
                        builder: (context, locationLatLng) {
                          if (locationLatLng.hasData) {
                            return Stack(
                              children: [
                                BlocConsumer<MapSearchCubit, MapSearchState>(
                                  listener: ((context, state) async {
                                    if (state is DefaultMapdata) {
                                      for (var i = 0;
                                          i < state.defaultdata.length;
                                          i++) {
                                        await checkbusiness(
                                                id: state
                                                    .defaultdata[i].businessId)
                                            .then((value) async {
                                          final marker = Marker(
                                            onTap: (() {
                                              setState(() async {
                                                oldindex = i;
                                                hiden_show = true;
                                                await checkbusiness(
                                                        id: state.defaultdata[i]
                                                            .businessId)
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
                                                        double.parse(state
                                                            .defaultdata[i]
                                                            .latitude),
                                                        double.parse(state
                                                            .defaultdata[i]
                                                            .longitude)),
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
                                                        double.parse(state
                                                            .defaultdata[i]
                                                            .latitude),
                                                        double.parse(state
                                                            .defaultdata[i]
                                                            .longitude)),
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
                                                double.parse(state
                                                    .defaultdata[i].latitude),
                                                double.parse(state
                                                    .defaultdata[i].longitude)),
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
                                    if (state is GetDataformGoogle) {
                                      setState(() {
                                        isloading = false;
                                        MarkerDataList =
                                            state.GetDataFormGoogle.businesses;
                                      });

                                      for (var i = 1;
                                          i <
                                              state.GetDataFormGoogle.businesses
                                                  .length;
                                          i++) {
                                        await checkbusiness(
                                                id: state.GetDataFormGoogle
                                                    .businesses[i].id)
                                            .then((value) async {
                                          if (state.ismoveSearch == false) {
                                            final GoogleMapController
                                                controller =
                                                await _controller.future;
                                            controller.animateCamera(
                                                CameraUpdate.newCameraPosition(
                                                    CameraPosition(
                                              target: LatLng(
                                                  state
                                                      .GetDataFormGoogle
                                                      .businesses[0]
                                                      .coordinates
                                                      .latitude,
                                                  state
                                                      .GetDataFormGoogle
                                                      .businesses[0]
                                                      .coordinates
                                                      .longitude),
                                              zoom: 14.4746,
                                            )));
                                          }

                                          final marker = Marker(
                                            onTap: (() {
                                              try {
                                                setState(() async {
                                                  oldindex = i;
                                                  hiden_show = true;
                                                  await checkbusiness(
                                                          id: state
                                                              .GetDataFormGoogle
                                                              .businesses[i]
                                                              .id)
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
                                                              .GetDataFormGoogle
                                                              .businesses[i]
                                                              .coordinates
                                                              .latitude,
                                                          state
                                                              .GetDataFormGoogle
                                                              .businesses[i]
                                                              .coordinates
                                                              .longitude),
                                                      zoom: 18.4746,
                                                    )));
                                                    final marker = Marker(
                                                      onTap: (() {
                                                        setState(() {
                                                          oldindex = i;
                                                          hiden_show = true;
                                                        });
                                                      }),
                                                      markerId: MarkerId(
                                                          i.toString()),
                                                      position: LatLng(
                                                          state
                                                              .GetDataFormGoogle
                                                              .businesses[i]
                                                              .coordinates
                                                              .latitude,
                                                          state
                                                              .GetDataFormGoogle
                                                              .businesses[i]
                                                              .coordinates
                                                              .longitude),
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
                                              } catch (e) {}
                                            }),
                                            markerId: MarkerId(i.toString()),
                                            position: LatLng(
                                                state
                                                    .GetDataFormGoogle
                                                    .businesses[i]
                                                    .coordinates
                                                    .latitude,
                                                state
                                                    .GetDataFormGoogle
                                                    .businesses[i]
                                                    .coordinates
                                                    .longitude),
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

                                    if (state is error) {
                                      setState(() {
                                        isloading = false;
                                      });
                                    }
                                  }),
                                  builder: (context, state) {
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
                                        myLocationButtonEnabled: false,
                                        myLocationEnabled: true,
                                        zoomControlsEnabled: false,
                                        initialCameraPosition: CameraPosition(
                                          target: LatLng(
                                              locationLatLng.data.latitude,
                                              locationLatLng.data.longitude),
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
                                        markers: Set.from(_markers),
                                        mapType: MapType.normal,
                                        myLocationButtonEnabled: false,
                                        myLocationEnabled: true,
                                        zoomControlsEnabled: false,
                                        initialCameraPosition: CameraPosition(
                                          target: LatLng(
                                              locationLatLng.data.latitude,
                                              locationLatLng.data.longitude),
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
                                      return GoogleMap(
                                        onCameraMove: ((position) {
                                          print(position.target.latitude);
                                        }),
                                        markers: Set.from(_markers),
                                        mapType: MapType.normal,
                                        myLocationButtonEnabled: false,
                                        myLocationEnabled: true,
                                        zoomControlsEnabled: false,
                                        initialCameraPosition: CameraPosition(
                                          target: LatLng(
                                              locationLatLng.data.latitude,
                                              locationLatLng.data.longitude),
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
                                  },
                                ),

                                ////
                                ///
                                ///
                                ///
                                ///area Search
                                if (areaSearch) ...[
                                  Positioned(
                                      top: 50.w,
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
                                                    Categoery: search.text,
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
                                    top: 35.w,
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
                                                    address.text =
                                                        predictions[index]
                                                            .description;
                                                    predictions = [];
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
                                  top: 30.sp,
                                  left: 8.sp,
                                  right: 8.sp,
                                  child: Container(
                                    height: 35.w,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .secondaryHeaderColor,
                                        borderRadius:
                                            BorderRadius.circular(10.sp)),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8.sp, vertical: 8.sp),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          TextFormField(
                                            cursorColor: Theme.of(context)
                                                .iconTheme
                                                .color,
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
                                            controller: address,
                                            validator: (value) => value.isEmpty
                                                ? "Name can't be blank"
                                                : null,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color,
                                                fontSize: 12.sp),
                                            decoration: InputDecoration(
                                              prefixIcon: IconButton(
                                                  onPressed: () async {
                                                    await Geolocator
                                                            .getCurrentPosition(
                                                                desiredAccuracy:
                                                                    LocationAccuracy
                                                                        .high)
                                                        .then((Position
                                                            latlng) async {
                                                      print(latlng.latitude);
                                                      final GoogleMapController
                                                          controller =
                                                          await _controller
                                                              .future;
                                                      controller.animateCamera(
                                                          CameraUpdate
                                                              .newCameraPosition(
                                                        CameraPosition(
                                                          bearing: 0,
                                                          target: LatLng(
                                                              latlng.latitude,
                                                              latlng.longitude),
                                                          zoom: 16.0,
                                                        ),
                                                      ));
                                                      controller.setMapStyle(
                                                          isDarkMode
                                                              ? dark
                                                              : light);
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.location_on_outlined,
                                                    color: Theme.of(context)
                                                        .iconTheme
                                                        .color,
                                                    size: 20.sp,
                                                  )),
                                              hintText: "Current Location",
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
                                                              5.sp),
                                                      borderSide:
                                                          BorderSide.none),
                                              errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.sp),
                                                  borderSide: BorderSide.none),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.sp),
                                                  borderSide: BorderSide.none),
                                            ),
                                          ),

                                          // Search Box Start
                                          TextFormField(
                                            cursorColor: Theme.of(context)
                                                .iconTheme
                                                .color,
                                            onChanged: (value) {
                                              setState(() {
                                                hiden_show = false;
                                                Termclearhideshow = true;
                                              });
                                            },
                                            controller: search,
                                            validator: (value) => value.isEmpty
                                                ? "Name can't be blank"
                                                : null,
                                            onFieldSubmitted: (value) async {
                                              setState(() {
                                                hiden_show = false;
                                                isloading = true;
                                                String searchkey = value;
                                                _markers = [];
                                                predictions = [];

                                                if (address.text.isNotEmpty) {
                                                  BlocProvider.of<
                                                              BusinessInfoGetCubit>(
                                                          context)
                                                      .isClosed;
                                                  context
                                                      .read<MapSearchCubit>()
                                                      .MapSearchdata(
                                                        address: address.text,
                                                        Categoery: value,
                                                      );
                                                } else {
                                                  Geolocator.getCurrentPosition(
                                                          desiredAccuracy:
                                                              LocationAccuracy
                                                                  .high)
                                                      .then((Position lanLat) {
                                                    BlocProvider.of<
                                                                BusinessInfoGetCubit>(
                                                            context)
                                                        .isClosed;
                                                    context
                                                        .read<MapSearchCubit>()
                                                        .MapSearchWithLatLng(
                                                          lat: lanLat.latitude,
                                                          lng: lanLat.longitude,
                                                          term: value,
                                                        );
                                                  });
                                                }
                                              });
                                            },
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color,
                                                fontSize: 12.sp),
                                            decoration: InputDecoration(
                                              suffixIcon: Termclearhideshow
                                                  ? IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          search.clear();
                                                          predictions = [];
                                                          Termclearhideshow =
                                                              false;
                                                        });
                                                      },
                                                      icon: Icon(
                                                        CupertinoIcons.clear,
                                                        color: Theme.of(context)
                                                            .iconTheme
                                                            .color,
                                                      ))
                                                  : null,
                                              prefixIcon: IconButton(
                                                  onPressed: search.text.isEmpty
                                                      ? null
                                                      : () {
                                                          setState(() {
                                                            hiden_show = false;
                                                            isloading = true;
                                                            String searchkey =
                                                                search.text;
                                                            _markers = [];
                                                            predictions = [];
                                                            if (address.text
                                                                    .isNotEmpty &&
                                                                search.text
                                                                    .isNotEmpty) {
                                                              BlocProvider.of<
                                                                          BusinessInfoGetCubit>(
                                                                      context)
                                                                  .isClosed;
                                                              context
                                                                  .read<
                                                                      MapSearchCubit>()
                                                                  .MapSearchdata(
                                                                    address:
                                                                        address
                                                                            .text,
                                                                    Categoery:
                                                                        search
                                                                            .text,
                                                                  );
                                                            } else {
                                                              BlocProvider.of<
                                                                          BusinessInfoGetCubit>(
                                                                      context)
                                                                  .isClosed;
                                                              context
                                                                  .read<
                                                                      MapSearchCubit>()
                                                                  .MapSearchWithLatLng(
                                                                    lat: locationLatLng
                                                                        .data
                                                                        .latitude,
                                                                    lng: locationLatLng
                                                                        .data
                                                                        .longitude,
                                                                    term: search
                                                                        .text,
                                                                  );
                                                            }
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
                                                    BorderRadius.circular(5.sp),
                                                borderSide: BorderSide.none,
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.sp),
                                                      borderSide:
                                                          BorderSide.none),
                                              errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.sp),
                                                  borderSide: BorderSide.none),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.sp),
                                                  borderSide: BorderSide.none),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
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
                                            return AnimatedPositioned(
                                              curve: Curves.easeInBack,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              bottom: 20.sp,
                                              left: 0,
                                              right: 0,
                                              child: AnimatedContainer(
                                                curve: Curves.easeInBack,
                                                duration: const Duration(
                                                    milliseconds: 300),
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
                                                        .businesses
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
                                                                    .GetDataFormGoogle
                                                                    .businesses[
                                                                        oldindex]
                                                                    .id)
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
                                                                    .GetDataFormGoogle
                                                                    .businesses[
                                                                        oldindex]
                                                                    .coordinates
                                                                    .latitude,
                                                                state
                                                                    .GetDataFormGoogle
                                                                    .businesses[
                                                                        oldindex]
                                                                    .coordinates
                                                                    .longitude),
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
                                                                  .GetDataFormGoogle
                                                                  .businesses[
                                                                      index]
                                                                  .id)
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
                                                                  .GetDataFormGoogle
                                                                  .businesses[
                                                                      index]
                                                                  .coordinates
                                                                  .latitude,
                                                              state
                                                                  .GetDataFormGoogle
                                                                  .businesses[
                                                                      index]
                                                                  .coordinates
                                                                  .longitude),
                                                          zoom: 18.4746,
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
                                                                  .GetDataFormGoogle
                                                                  .businesses[
                                                                      index]
                                                                  .coordinates
                                                                  .latitude,
                                                              state
                                                                  .GetDataFormGoogle
                                                                  .businesses[
                                                                      index]
                                                                  .coordinates
                                                                  .longitude),
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
                                                          FutureBuilder<
                                                                  BusinessDetails>(
                                                              future: YelpBusinessDetailsFutuer(
                                                                  BusinessId: state
                                                                      .GetDataFormGoogle
                                                                      .businesses[
                                                                          index]
                                                                      .id),
                                                              builder: (context,
                                                                  YelpBusines_Snapshot) {
                                                                if (YelpBusines_Snapshot
                                                                    .hasData) {
                                                                  return Container(
                                                                    width: 90.w,
                                                                    child: Card(
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15.0),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(vertical: 2.w),
                                                                        child: Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              if (YelpBusines_Snapshot.data.photos != null) ...[
                                                                                Padding(
                                                                                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0),
                                                                                  child: Theme(
                                                                                    data: ThemeData(progressIndicatorTheme: ProgressIndicatorThemeData(color: Theme.of(context).iconTheme.color)),
                                                                                    child: GalleryImage(
                                                                                      numOfShowImages: imagelen(YelpBusines_Snapshot.data.photos.length),
                                                                                      imageUrls: List.from(YelpBusines_Snapshot.data.photos.map((e) => e)),
                                                                                      titleGallery: "Photo",
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                              ListTile(
                                                                                  dense: true,
                                                                                  minVerticalPadding: 0,
                                                                                  visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                                                                                  trailing: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                                    children: [
                                                                                      SizedBox(
                                                                                        height: 2.w,
                                                                                      ),
                                                                                      if (YelpBusines_Snapshot.data.isClosed) ...[
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
                                                                                    ],
                                                                                  ),
                                                                                  title: Text(
                                                                                    state.GetDataFormGoogle.businesses[index].name,
                                                                                    style: TextStyle(fontSize: 15.sp, color: Theme.of(context).iconTheme.color, fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                  subtitle: Row(
                                                                                    children: [
                                                                                      if (state.GetDataFormGoogle.businesses[index].rating != null) ...[
                                                                                        GFRating(
                                                                                          size: 12.sp,
                                                                                          value: double.parse(state.GetDataFormGoogle.businesses[index].rating.toString() ?? "0.0"),
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
                                                                                        "${YelpBusines_Snapshot.data.reviewCount ?? "0"} review",
                                                                                        style: TextStyle(color: Theme.of(context).iconTheme.color),
                                                                                      )
                                                                                    ],
                                                                                  )),
                                                                              Padding(
                                                                                padding: EdgeInsets.symmetric(
                                                                                  horizontal: 4.w,
                                                                                ),
                                                                                child: Row(
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
                                                                                            YelpBusines_Snapshot.data.location.displayAddress[0] + " " + YelpBusines_Snapshot.data.location.displayAddress[1],
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
                                                                                height: 2.w,
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                children: [
                                                                                  StreamBuilder<QuerySnapshot>(
                                                                                      stream: FirebaseFirestore.instance.collection("marker").where("Business_Id", isEqualTo: YelpBusines_Snapshot.data.id).snapshots(),
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
                                                                                                            business: YelpBusines_Snapshot.data,
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
                                                                                    padding: EdgeInsets.only(right: 2.w),
                                                                                    child: GestureDetector(
                                                                                      onTap: () {
                                                                                        MapsSheet.show(
                                                                                          
                                                                                          context: context,
                                                                                          onMapTap: (map) {
                                                                                            map.showDirections(
                                                                                              
                                                                                              destination: direction.Coords(
                                                                                                YelpBusines_Snapshot.data.coordinates.latitude,
                                                                                                YelpBusines_Snapshot.data.coordinates.longitude,
                                                                                              ),
                                                                                              destinationTitle: YelpBusines_Snapshot.data.name,
                                                                                              origin: direction.Coords(
                                                                                                YelpBusines_Snapshot.data.coordinates.latitude,
                                                                                                YelpBusines_Snapshot.data.coordinates.longitude,
                                                                                              ),
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
                                                                  );
                                                                } else {
                                                                  return GFShimmer(
                                                                      child:
                                                                          Container(
                                                                    height:
                                                                        63.w,
                                                                    width:
                                                                        100.w,
                                                                    decoration: BoxDecoration(
                                                                        color: Theme.of(context)
                                                                            .iconTheme
                                                                            .color,
                                                                        borderRadius:
                                                                            BorderRadius.circular(10.sp)),
                                                                  ));
                                                                }
                                                              }),
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

  Future<BusinessDetails> YelpBusinessDetailsFutuer({String BusinessId}) async {
    try {
      var res = await http.get(
          Uri.parse(
            "https://api.yelp.com/v3/businesses/${BusinessId}",
          ),
          headers: {"Authorization": 'bearer $YELPAPIKEY'});

      return BusinessDetails.fromJson(res.body);
    } catch (e) {}
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
    var googleGeocoding = geocode.GoogleGeocoding(GOOGLEMAPAPI);
    var risult = await googleGeocoding.geocoding
        .getReverse(geocode.LatLon(value.latitude, value.longitude));

    // Add Marker in Maps
  }

  void autoCompleteSearch(String value) async {
    try {
      final googlePlace = GooglePlace(GOOGLEMAPAPI);

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

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
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
