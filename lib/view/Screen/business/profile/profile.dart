import 'package:chatting/Helper/color.dart';
import 'package:chatting/logic/Business_profile/business_profile_cubit.dart';

import 'package:chatting/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:sizer/sizer.dart';
import 'package:strings/strings.dart';

class Admin_Profile extends StatefulWidget {
  static const String routeName = '/admin_profile';

  static Route route({String Room_ID}) {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => Admin_Profile(
              Room_ID: Room_ID,
            ));
  }

  const Admin_Profile({Key key, this.Room_ID}) : super(key: key);
  final String Room_ID;
  @override
  State<Admin_Profile> createState() => _Admin_ProfileState();
}

class _Admin_ProfileState extends State<Admin_Profile> {
  String myuid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_group_data(uid: widget.Room_ID);
  }

  void get_group_data({String uid}) {
    myuid = sharedPreferences.getString('uid');
    context
        .read<BusinessProfileCubit>()
        .get_Business_Profile(room_id: widget.Room_ID);
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('EEEE');
    DateFormat current_time = DateFormat('H:mm');
    String formatted = formatter.format(now);
    String now_time = current_time.format(now);
    var currarry = now_time.split(":");
    int curr_Hour = int.parse(currarry[0]);
    int curr_min = int.parse(currarry[1]);
    return BlocBuilder<BusinessProfileCubit, BusinessProfileState>(
      builder: (context, state) {
        if (state is BusinessLoading) {
          return Center(
            child: CupertinoActivityIndicator(
                color: Theme.of(context).iconTheme.color),
          );
        } else if (state is HasData_Business_Profile) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.zero,
                  child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      future: FirebaseFirestore.instance
                          .collection('chat')
                          .doc(widget.Room_ID)
                          .get(),
                      builder: (context,
                          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.hasData) {
                          Map<String, dynamic> status = snapshot.data.data();
                          if (state.business.owner.contains(myuid) ||
                              (state.business.admin == null
                                  ? false
                                  : state.business.admin.contains(myuid))) {
                            return Theme(
                              data: ThemeData(
                                  splashColor:
                                      Theme.of(context).iconTheme.color),
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                        '/business_profile_edit',
                                        arguments: widget.Room_ID);
                                  },
                                  child: Text(
                                    "Edit",
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).iconTheme.color,
                                        fontSize: 12.sp),
                                  )),
                            );
                          } else {
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: 8.sp,
                                  top: 8.sp,
                                  bottom: 8.sp,
                                  right: 8.sp),
                              child: Container(
                                  height: 20,
                                  width: 15.w,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).iconTheme.color,
                                      borderRadius: BorderRadius.circular(5)),
                                  alignment: Alignment.center,
                                  child: StreamBuilder<
                                          DocumentSnapshot<
                                              Map<String, dynamic>>>(
                                      stream: FirebaseFirestore.instance
                                          .collection('chat')
                                          .doc(widget.Room_ID)
                                          .collection('Business_Hours')
                                          .doc(formatted)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          Map<String, dynamic> hours =
                                              snapshot.data.data();
                                          // Open and Time Format Start

                                          DateTime op = DateFormat('hh:mm a')
                                              .parseLoose(
                                                  hours['open'] == "off" ||
                                                          hours['open'] ==
                                                              '24 Hours'
                                                      ? "00:00 AM"
                                                      : hours['open']);
                                          DateFormat openformat =
                                              DateFormat('H:mm');
                                          String openHours =
                                              openformat.format(op);

                                          var opsarry = openHours.split(":");
                                          int Open_Hour = int.parse(opsarry[0]);
                                          int Open_min = int.parse(opsarry[1]);
                                          // Open and Time Format End
                                          // Open and Time Format Start
                                          DateTime cls = DateFormat('hh:mm a')
                                              .parseLoose(hours['cls'] ==
                                                          "off" ||
                                                      hours['cls'] == '24 Hours'
                                                  ? "00:00 AM"
                                                  : hours['cls']);
                                          DateFormat clsformat =
                                              DateFormat('H:mm');
                                          String clsHours =
                                              openformat.format(cls);
                                          var clsarry = clsHours.split(":");
                                          int cls_Hour = int.parse(clsarry[0]);
                                          int cls_min = int.parse(clsarry[1]);
                                          print("${cls_min} min");
                                          if (((Open_Hour <= curr_Hour &&
                                                      cls_Hour >= curr_Hour) ||
                                                  (Open_Hour == 0 ||
                                                      cls_Hour == 0) ||
                                                  (hours['open'] ==
                                                          "24 Hours" ||
                                                      hours['cls'] ==
                                                          "24 Hours")) &&
                                              (hours['open'] != 'off' ||
                                                  hours['cls'] != 'off')) {
                                            if ((Open_Hour == curr_Hour
                                                    ? Open_min <= curr_min
                                                    : true) ||
                                                (cls_Hour == curr_Hour
                                                    ? cls_min <= curr_min
                                                    : true)) {
                                              return Text(
                                                "Open",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .secondaryHeaderColor),
                                              );
                                            } else {
                                              return Text(
                                                "Close",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .secondaryHeaderColor),
                                              );
                                            }
                                          } else {
                                            return Text(
                                              "Close",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .secondaryHeaderColor),
                                            );
                                          }
                                        }
                                        return Container();
                                      })),
                            );
                          }
                        } else {
                          return CupertinoActivityIndicator(
                            color: Theme.of(context).iconTheme.color,
                          );
                        }
                      }),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    SizedBox(
                      height: 2.w,
                    ),
                    Container(
                      child: StreamBuilder<
                              DocumentSnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection('chat')
                              .doc(widget.Room_ID)
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<
                                      DocumentSnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.hasData) {
                              Map<String, dynamic> businessimage =
                                  snapshot.data.data();
                              return CircleAvatar(
                                  radius: 30.sp,
                                  backgroundImage:
                                      NetworkImage(businessimage['imageURl']));
                            } else {
                              return CircleAvatar();
                            }
                          }),
                    ),
                    SizedBox(
                      height: 15.w,
                    ),
                    Container(
                      height: 25.w,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: isDarkMode
                              ? HexColor.fromHex("#1a1a1c")
                              : HexColor.fromHex("#ffffff"),
                          borderRadius: BorderRadius.circular(15.sp)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  capitalize(state.business.businessName),
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                SvgPicture.asset(
                                  'assets/svg/padlock.svg',
                                  width: 15.sp,
                                  height: 15.sp,
                                  color: Theme.of(context).iconTheme.color,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 5.w,
                              child: const Divider(
                                height: 1,
                                color: Color.fromARGB(255, 223, 223, 223),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 60.w,
                                  child: Text(
                                    state.business.description,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 12.sp, color: Colors.grey),
                                  ),
                                ),
                                SvgPicture.asset(
                                  'assets/svg/padlock.svg',
                                  width: 15.sp,
                                  height: 15.sp,
                                  color: Theme.of(context).iconTheme.color,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            "LINK",
                            style: TextStyle(
                                color: Theme.of(context).iconTheme.color,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Container(
                          height: 15.w,
                          alignment: Alignment.centerLeft,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: isDarkMode
                                  ? HexColor.fromHex("#1a1a1c")
                                  : HexColor.fromHex("#ffffff"),
                              borderRadius: BorderRadius.circular(10.sp)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "s.me/ashdkadkasjd",
                                  style: TextStyle(
                                      color: Theme.of(context).iconTheme.color,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: SvgPicture.asset(
                                    'assets/svg/share.svg',
                                    width: 15.sp,
                                    height: 15.sp,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (state.business.owner.contains(myuid) ||
                        (state.business.admin == null
                            ? false
                            : state.business.admin.contains(myuid))) ...[
                      SizedBox(
                        height: 10.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              "OWNER/ADMIN",
                              style: TextStyle(
                                  color: Theme.of(context).iconTheme.color,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          Container(
                              height: 15.w,
                              alignment: Alignment.topCenter,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: isDarkMode
                                      ? HexColor.fromHex("#1a1a1c")
                                      : HexColor.fromHex("#ffffff"),
                                  borderRadius: BorderRadius.circular(10.sp)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Manage Access",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .iconTheme
                                                  .color,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          children: [
                                            StreamBuilder<
                                                    DocumentSnapshot<
                                                        Map<String, dynamic>>>(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('chat')
                                                    .doc(widget.Room_ID)
                                                    .collection(
                                                        "Request_notification")
                                                    .doc("re")
                                                    .snapshots(),
                                                builder: (context,
                                                    AsyncSnapshot<
                                                            DocumentSnapshot<
                                                                Map<String,
                                                                    dynamic>>>
                                                        snapshot) {
                                                  if (snapshot.hasData) {
                                                    Map<String, dynamic>
                                                        status =
                                                        snapshot.data.data();
                                                    return Container(
                                                      height: 10,
                                                      width: 10,
                                                      decoration: BoxDecoration(
                                                          color: status[
                                                                      "status"] ==
                                                                  true
                                                              ? Colors.red
                                                              : Colors
                                                                  .transparent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                    );
                                                  } else {
                                                    return Container();
                                                  }
                                                }),
                                            SizedBox(
                                              width: 2.w,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pushNamed(
                                                    "/request",
                                                    arguments: widget.Room_ID);
                                              },
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color,
                                              ),
                                            ),
                                          ],
                                        )
                                      ]),
                                ),
                              )),

                          SizedBox(
                            height: 10.w,
                          ),
                          // Feed Section Start

                          Container(
                              height: 15.w,
                              alignment: Alignment.topCenter,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: isDarkMode
                                      ? HexColor.fromHex("#1a1a1c")
                                      : HexColor.fromHex("#ffffff"),
                                  borderRadius: BorderRadius.circular(10.sp)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Promotional Post",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .iconTheme
                                                  .color,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pushNamed(
                                                    '/feed',
                                                    arguments: widget.Room_ID);
                                              },
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color,
                                              ),
                                            ),
                                          ],
                                        )
                                      ]),
                                ),
                              )),

                          // End Feed Section
                        ],
                      ),
                    ],
                    SizedBox(
                      height: 10.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "MEMBERS",
                                style: TextStyle(
                                    color: Theme.of(context).iconTheme.color,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.normal),
                              ),
                              // only Admin and Owner View
                              if (state.business.owner.contains(myuid) ||
                                  (state.business.admin == null
                                      ? false
                                      : state.business.admin
                                          .contains(myuid))) ...[
                                GestureDetector(
                                  onTap: () {
                                    print("Welcome to review List");
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "REVIEW LIST",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.blue,
                                      ),
                                    ],
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
                        Container(
                          height: state.business.owner.contains(myuid) ||
                                  (state.business.admin == null
                                      ? false
                                      : state.business.admin.contains(myuid))
                              ? 60.w
                              : 15.w,
                          alignment: Alignment.topCenter,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: isDarkMode
                                  ? HexColor.fromHex("#1a1a1c")
                                  : HexColor.fromHex("#ffffff"),
                              borderRadius: BorderRadius.circular(10.sp)),
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: state.business.owner.contains(myuid) ||
                                      (state.business.admin == null
                                          ? false
                                          : state.business.admin
                                              .contains(myuid))
                                  ? CustomScrollView(
                                      slivers: [
                                        // SliverAppBar(
                                        //     automaticallyImplyLeading: false,
                                        //     backgroundColor: Colors.transparent,
                                        //     elevation: 0,
                                        //     title: Row(
                                        //       children: [
                                        //         CircleAvatar(
                                        //           backgroundColor: Colors.blue,
                                        //           child: SvgPicture.asset(
                                        //             'assets/svg/add-friend_bus.svg',
                                        //             width: 5.w,
                                        //             height: 5.w,
                                        //             color: Theme.of(context)
                                        //                 .iconTheme
                                        //                 .color,
                                        //           ),
                                        //         ),
                                        //         SizedBox(
                                        //           width: 3.5.w,
                                        //         ),
                                        //         Column(
                                        //           mainAxisAlignment:
                                        //               MainAxisAlignment.center,
                                        //           crossAxisAlignment:
                                        //               CrossAxisAlignment.start,
                                        //           children: const [
                                        //             Text(
                                        //               "Member Request",
                                        //               style: TextStyle(
                                        //                   color: Colors.blue),
                                        //             ),
                                        //             // Container(
                                        //             //   child: const Text(
                                        //             //     " \nBusiness.",
                                        //             //     style: TextStyle(
                                        //             //         color: Colors.grey,
                                        //             //         fontSize: 12),
                                        //             //   ),
                                        //             // )
                                        //           ],
                                        //         )
                                        //       ],
                                        //     )),

                                        SliverList(
                                          delegate: SliverChildBuilderDelegate(
                                            (BuildContext context, int index) {
                                              return FutureBuilder<
                                                      DocumentSnapshot<
                                                          Map<String,
                                                              dynamic>>>(
                                                  future: FirebaseFirestore
                                                      .instance
                                                      .collection('user')
                                                      .doc(state.business
                                                          .customer[index])
                                                      .get(),
                                                  builder: (context,
                                                      AsyncSnapshot<
                                                              DocumentSnapshot<
                                                                  Map<String,
                                                                      dynamic>>>
                                                          snapshot) {
                                                    if (snapshot.hasData) {
                                                      Map<String, dynamic>
                                                          admin_data =
                                                          snapshot.data.data()
                                                              as Map;
                                                      return ListTile(
                                                        leading: CircleAvatar(
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    admin_data[
                                                                        'imageUrl'])),
                                                        title: Text(admin_data[
                                                            'first_name']),
                                                        trailing: IconButton(
                                                            onPressed: () {},
                                                            icon: Icon(Icons
                                                                .more_vert)),
                                                      );
                                                    } else {
                                                      return Center(
                                                          child:
                                                              CupertinoActivityIndicator(
                                                        color: Theme.of(context)
                                                            .iconTheme
                                                            .color,
                                                      ));
                                                    }
                                                  });
                                            },
                                            childCount:
                                                state.business.customer == null
                                                    ? 0
                                                    : state.business.customer
                                                        .length,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(
                                      height: double.infinity,
                                      width: double.infinity,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Members Access",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pushNamed(
                                                    '/owner_request',
                                                    arguments: widget.Room_ID);
                                              },
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color,
                                              ),
                                            )
                                          ]),
                                    )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2.w,
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Container(
            color: Colors.red,
          );
        }
      },
    );
  }
}

// Member show List

// Expanded(
//                                     child: ListView.builder(
//                                         itemCount:
//                                             state.business.customer.length,
//                                         itemBuilder: (context, index) {
//                                           return FutureBuilder<
//                                                   DocumentSnapshot<
//                                                       Map<String, dynamic>>>(
//                                               future: FirebaseFirestore.instance
//                                                   .collection('user')
//                                                   .doc(state
//                                                       .business.customer[index])
//                                                   .get(),
//                                               builder: (context,
//                                                   AsyncSnapshot<
//                                                           DocumentSnapshot<
//                                                               Map<String,
//                                                                   dynamic>>>
//                                                       snapshot) {
//                                                 if (snapshot.hasData) {
//                                                   Map<String, dynamic>
//                                                       admin_data = snapshot.data
//                                                           .data() as Map;
//                                                   return ListTile(
//                                                     leading: CircleAvatar(
//                                                         backgroundImage:
//                                                             NetworkImage(
//                                                                 admin_data[
//                                                                     'imageUrl'])),
//                                                     title: Text(admin_data[
//                                                         'first_name']),
//                                                     subtitle: Text(
//                                                         state.business.owner
//                                                                 .contains(state
//                                                                         .business
//                                                                         .customer[
//                                                                     index])
//                                                             ? 'Owner'
//                                                             : "Member",
//                                                         style: TextStyle(
//                                                             color: Colors.grey,
//                                                             fontSize: 12.sp)),
//                                                   );
//                                                 } else {
//                                                   return Center(
//                                                       child:
//                                                           CupertinoActivityIndicator(
//                                                     color: Theme.of(context)
//                                                         .iconTheme
//                                                         .color,
//                                                   ));
//                                                 }
//                                               });
//                                         })),
