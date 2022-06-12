import 'package:chatting/Helper/color.dart';
import 'package:chatting/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:random_color/random_color.dart';
import 'package:sizer/sizer.dart';
import 'package:strings/strings.dart';

class request extends StatefulWidget {
  static const String routeName = '/request';

  static Route route({String RoomId}) {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => request(
              RoomId: RoomId,
            ));
  }

  final String RoomId;

  const request({Key key, this.RoomId}) : super(key: key);

  @override
  State<request> createState() => _requestState();
}

class _requestState extends State<request> {
  String myuid = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void get_group_data({String uid}) {
    setState(() {
      myuid = sharedPreferences.getString('uid');
    });
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Requests",
          style: TextStyle(color: Theme.of(context).iconTheme.color),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "TRANSFER OWNERSHIP REQUEST",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 2.5.w,
              ),
              Container(
                  height: 70.w,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: isDarkMode
                          ? HexColor.fromHex("#1a1a1c")
                          : HexColor.fromHex("#ffffff"),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('chat')
                            .doc(widget.RoomId)
                            .collection('OwnerRequest')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Container();
                          }
                          if (snapshot.hasData) {
                            return CustomScrollView(
                              slivers: [
                                SliverAppBar(
                                  automaticallyImplyLeading: false,
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  actions: [
                                    StreamBuilder<
                                            DocumentSnapshot<
                                                Map<String, dynamic>>>(
                                        stream: FirebaseFirestore.instance
                                            .collection('chat')
                                            .doc(widget.RoomId)
                                            .snapshots(),
                                        builder: (context,
                                            AsyncSnapshot<
                                                    DocumentSnapshot<
                                                        Map<String, dynamic>>>
                                                snapshot) {
                                          if (snapshot.hasData) {
                                            Map<String, dynamic> datas =
                                                snapshot.data.data();
                                            List data = datas['owner'];

                                            return data.contains(
                                                    sharedPreferences
                                                        .getString('uid'))
                                                ? GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                              '/AddOwnerwithAdmin',
                                                              arguments: {
                                                            "RoomId":
                                                                widget.RoomId,
                                                            "type": "owner"
                                                          });
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Add Owner",
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .iconTheme
                                                                  .color,
                                                              fontSize: 12.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          color:
                                                              Theme.of(context)
                                                                  .iconTheme
                                                                  .color,
                                                          size: 12.sp,
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                : Container();
                                          } else {
                                            return Container();
                                          }
                                        })
                                  ],
                                ),
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      ((context, index) {
                                    QueryDocumentSnapshot ownerData =
                                        snapshot.data.docs[index];
                                    return FutureBuilder<
                                            DocumentSnapshot<
                                                Map<String, dynamic>>>(
                                        future: FirebaseFirestore.instance
                                            .collection('user')
                                            .doc(ownerData['ID'])
                                            .get(),
                                        builder: (context, usersnapshot) {
                                          if (usersnapshot.hasData) {
                                            Map<String, dynamic> userdata =
                                                usersnapshot.data.data();
                                            String imagecheck =
                                                userdata['imageUrl'];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      // Photo With title and subtitle Section Start
                                                      Row(
                                                        children: [
                                                          if (imagecheck.contains(
                                                              "https://")) ...[
                                                            CircleAvatar(
                                                              radius: 15.sp,
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                      userdata[
                                                                          'imageUrl']),
                                                            ),
                                                          ] else ...[
                                                            ProfilePicture(
                                                              name: userdata[
                                                                      'first_name']
                                                                  .trim(),
                                                              radius: 20,
                                                              fontsize: 12.sp,
                                                            )
                                                          ],

                                                          // Name and Sub titile Section
                                                          SizedBox(
                                                            width: 5.w,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                capitalize(userdata[
                                                                    'first_name']),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12.sp,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .iconTheme
                                                                        .color,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              const Text(
                                                                "Owner",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      // Photo With title and subtitle Section END

                                                      // Action Button Section Start
                                                      if (ownerData['Status'] ==
                                                          false) ...[
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  2.5.w),
                                                          child: Row(
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'chat')
                                                                      .doc(widget
                                                                          .RoomId)
                                                                      .collection(
                                                                          'OwnerRequest')
                                                                      .doc(ownerData[
                                                                          "ID"])
                                                                      .delete()
                                                                      .then(
                                                                          (value) {
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'chat')
                                                                        .doc(widget
                                                                            .RoomId)
                                                                        .update({
                                                                      "owner":
                                                                          FieldValue
                                                                              .arrayRemove([
                                                                        ownerData[
                                                                            "ID"]
                                                                      ])
                                                                    });
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            "chat")
                                                                        .doc(widget
                                                                            .RoomId)
                                                                        .collection(
                                                                            "Request_notification")
                                                                        .doc(
                                                                            "re")
                                                                        .update({
                                                                      "status":
                                                                          false
                                                                    });
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 11.w,
                                                                  width: 11.w,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Icon(
                                                                          Icons
                                                                              .remove_circle,
                                                                          color:
                                                                              Theme.of(context).secondaryHeaderColor),
                                                                      Text(
                                                                        "remove",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                8.sp,
                                                                            color: Theme.of(context).secondaryHeaderColor),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 2.5.w,
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'chat')
                                                                      .doc(widget
                                                                          .RoomId)
                                                                      .collection(
                                                                          'OwnerRequest')
                                                                      .doc(ownerData[
                                                                          "ID"])
                                                                      .update({
                                                                    "Status":
                                                                        true
                                                                  }).then((value) {
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'chat')
                                                                        .doc(widget
                                                                            .RoomId)
                                                                        .update({
                                                                      "owner":
                                                                          FieldValue
                                                                              .arrayUnion([
                                                                        ownerData[
                                                                            "ID"]
                                                                      ])
                                                                    });
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'chat')
                                                                        .doc(widget
                                                                            .RoomId)
                                                                        .update({
                                                                      "customer":
                                                                          FieldValue
                                                                              .arrayUnion([
                                                                        ownerData[
                                                                            "ID"]
                                                                      ])
                                                                    });
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            "chat")
                                                                        .doc(widget
                                                                            .RoomId)
                                                                        .collection(
                                                                            "Request_notification")
                                                                        .doc(
                                                                            "re")
                                                                        .set({
                                                                      "status":
                                                                          false
                                                                    });
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 11.w,
                                                                  width: 11.w,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                  child: Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Icon(
                                                                            Icons
                                                                                .done,
                                                                            color:
                                                                                Theme.of(context).secondaryHeaderColor),
                                                                        Text(
                                                                          "approve",
                                                                          style: TextStyle(
                                                                              fontSize: 8.sp,
                                                                              color: Theme.of(context).secondaryHeaderColor),
                                                                        )
                                                                      ]),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ] else ...[
                                                        StreamBuilder<
                                                                DocumentSnapshot<
                                                                    Map<String,
                                                                        dynamic>>>(
                                                            stream:
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'chat')
                                                                    .doc(widget
                                                                        .RoomId)
                                                                    .snapshots(),
                                                            builder: (context,
                                                                AsyncSnapshot<
                                                                        DocumentSnapshot<
                                                                            Map<String,
                                                                                dynamic>>>
                                                                    snapshot) {
                                                              if (snapshot
                                                                  .hasData) {
                                                                Map<String,
                                                                        dynamic>
                                                                    data =
                                                                    snapshot
                                                                        .data
                                                                        .data();
                                                                List owner =
                                                                    data[
                                                                        'owner'];
                                                                return owner.contains(
                                                                        sharedPreferences
                                                                            .getString('uid'))
                                                                    ? Row(
                                                                        children: [
                                                                          GestureDetector(
                                                                              onTap: () {
                                                                                showModalBottomSheet(
                                                                                    context: context,
                                                                                    builder: (context) {
                                                                                      return Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        children: <Widget>[
                                                                                          ListTile(
                                                                                            leading: Icon(
                                                                                              Icons.remove,
                                                                                              color: Theme.of(context).iconTheme.color,
                                                                                            ),
                                                                                            title: Text(
                                                                                              'Kick Owner',
                                                                                              style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).iconTheme.color),
                                                                                            ),
                                                                                            onTap: () {
                                                                                              FirebaseFirestore.instance.collection('chat').doc(widget.RoomId).collection("OwnerRequest").doc(ownerData["ID"]).delete();
                                                                                              FirebaseFirestore.instance.collection('chat').doc(widget.RoomId).update({
                                                                                                "owner": FieldValue.arrayRemove([ownerData["ID"]])
                                                                                              });
                                                                                              Navigator.pop(context);
                                                                                            },
                                                                                          ),
                                                                                        ],
                                                                                      );
                                                                                    });
                                                                              },
                                                                              child: Icon(
                                                                                Icons.more_vert,
                                                                                color: Theme.of(context).iconTheme.color,
                                                                              ))
                                                                        ],
                                                                      )
                                                                    : Container();
                                                              } else {
                                                                return Container();
                                                              }
                                                            })
                                                      ],

                                                      // Action Button Section END
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20.sp),
                                                    child: const Divider(),
                                                  )
                                                ],
                                              ),
                                            );
                                          } else {
                                            return Container();
                                          }
                                        });
                                  }), childCount: snapshot.data.docs.length),
                                )
                              ],
                            );
                          } else {
                            return Container();
                          }
                        }),
                  )),

              // Owner Request Section End
              SizedBox(
                height: 20.w,
              ),
              Text(
                "ADMIN REQUEST",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 2.5.w,
              ),
              Container(
                  height: 70.w,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: isDarkMode
                          ? HexColor.fromHex("#1a1a1c")
                          : HexColor.fromHex("#ffffff"),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('chat')
                            .doc(widget.RoomId)
                            .collection('AdminRequest')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Container();
                          }
                          if (snapshot.hasData) {
                            return CustomScrollView(
                              slivers: [
                                SliverAppBar(
                                  automaticallyImplyLeading: false,
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  actions: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            '/AddOwnerwithAdmin',
                                            arguments: {
                                              "RoomId": widget.RoomId,
                                              "type": "admin"
                                            });
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            "Add Admin",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                            size: 12.sp,
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      ((context, index) {
                                    QueryDocumentSnapshot ownerData =
                                        snapshot.data.docs[index];
                                    return FutureBuilder<
                                            DocumentSnapshot<
                                                Map<String, dynamic>>>(
                                        future: FirebaseFirestore.instance
                                            .collection('user')
                                            .doc(ownerData['ID'])
                                            .get(),
                                        builder: (context, usersnapshot) {
                                          if (usersnapshot.hasData) {
                                            Map<String, dynamic> userdata =
                                                usersnapshot.data.data();
                                            String imagecheck =
                                                userdata['imageUrl'];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      // Photo With title and subtitle Section Start
                                                      Row(
                                                        children: [
                                                          if (imagecheck.contains(
                                                              "https://")) ...[
                                                            CircleAvatar(
                                                              radius: 15.sp,
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                      userdata[
                                                                          'imageUrl']),
                                                            ),
                                                          ] else ...[
                                                            ProfilePicture(
                                                              name: userdata[
                                                                      'first_name']
                                                                  .trim(),
                                                              radius: 20,
                                                              fontsize: 12.sp,
                                                            )
                                                          ],

                                                          // Name and Sub titile Section
                                                          SizedBox(
                                                            width: 5.w,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                capitalize(userdata[
                                                                    'first_name']),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12.sp,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .iconTheme
                                                                        .color,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              const Text(
                                                                "Admin",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      // Photo With title and subtitle Section END

                                                      // Action Button Section Start
                                                      if (ownerData['Status'] ==
                                                          false) ...[
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  2.5.w),
                                                          child: Row(
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'chat')
                                                                      .doc(widget
                                                                          .RoomId)
                                                                      .collection(
                                                                          'AdminRequest')
                                                                      .doc(ownerData[
                                                                          "ID"])
                                                                      .delete()
                                                                      .then(
                                                                          (value) {
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'chat')
                                                                        .doc(widget
                                                                            .RoomId)
                                                                        .update({
                                                                      "admin":
                                                                          FieldValue
                                                                              .arrayRemove([
                                                                        ownerData[
                                                                            "ID"]
                                                                      ])
                                                                    });
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            "chat")
                                                                        .doc(widget
                                                                            .RoomId)
                                                                        .collection(
                                                                            "Request_notification")
                                                                        .doc(
                                                                            "re")
                                                                        .update({
                                                                      "status":
                                                                          false
                                                                    });
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 11.w,
                                                                  width: 11.w,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Icon(
                                                                          Icons
                                                                              .remove_circle,
                                                                          color:
                                                                              Theme.of(context).secondaryHeaderColor),
                                                                      Text(
                                                                        "remove",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Theme.of(context).secondaryHeaderColor,
                                                                            fontSize: 8.sp),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 2.5.w,
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'chat')
                                                                      .doc(widget
                                                                          .RoomId)
                                                                      .collection(
                                                                          'AdminRequest')
                                                                      .doc(ownerData[
                                                                          "ID"])
                                                                      .update({
                                                                    "Status":
                                                                        true
                                                                  }).then((value) {
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'user')
                                                                        .doc(ownerData[
                                                                            "ID"])
                                                                        .collection(
                                                                            'Friends')
                                                                        .doc(widget
                                                                            .RoomId)
                                                                        .set({
                                                                      "Room_ID":
                                                                          widget
                                                                              .RoomId,
                                                                      "time": DateTime
                                                                          .now(),
                                                                      "uid": ownerData[
                                                                          "ID"]
                                                                    });
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'chat')
                                                                        .doc(widget
                                                                            .RoomId)
                                                                        .update({
                                                                      "admin":
                                                                          FieldValue
                                                                              .arrayUnion([
                                                                        ownerData[
                                                                            "ID"]
                                                                      ])
                                                                    });
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'chat')
                                                                        .doc(widget
                                                                            .RoomId)
                                                                        .update({
                                                                      "customer":
                                                                          FieldValue
                                                                              .arrayUnion([
                                                                        ownerData[
                                                                            "ID"]
                                                                      ])
                                                                    });
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            "chat")
                                                                        .doc(widget
                                                                            .RoomId)
                                                                        .collection(
                                                                            "Request_notification")
                                                                        .doc(
                                                                            "re")
                                                                        .update({
                                                                      "status":
                                                                          false
                                                                    });
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 11.w,
                                                                  width: 11.w,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                  child: Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .done,
                                                                          color:
                                                                              Theme.of(context).secondaryHeaderColor,
                                                                        ),
                                                                        Text(
                                                                          "approve",
                                                                          style: TextStyle(
                                                                              fontSize: 8.sp,
                                                                              color: Theme.of(context).secondaryHeaderColor),
                                                                        )
                                                                      ]),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ] else ...[
                                                        StreamBuilder<
                                                                DocumentSnapshot<
                                                                    Map<String,
                                                                        dynamic>>>(
                                                            stream:
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'chat')
                                                                    .doc(widget
                                                                        .RoomId)
                                                                    .snapshots(),
                                                            builder: (context,
                                                                AsyncSnapshot<
                                                                        DocumentSnapshot<
                                                                            Map<String,
                                                                                dynamic>>>
                                                                    snapshot) {
                                                              if (snapshot
                                                                  .hasData) {
                                                                Map<String,
                                                                        dynamic>
                                                                    businessdata =
                                                                    snapshot
                                                                        .data
                                                                        .data();
                                                                List ownerdata =
                                                                    businessdata[
                                                                        'owner'];

                                                                return ownerdata
                                                                        .contains(
                                                                            sharedPreferences.getString('uid'))
                                                                    ? Row(
                                                                        children: [
                                                                          GestureDetector(
                                                                              onTap: () {
                                                                                showModalBottomSheet(
                                                                                    context: context,
                                                                                    builder: (context) {
                                                                                      return Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        children: <Widget>[
                                                                                          ListTile(
                                                                                            leading: Icon(
                                                                                              Icons.remove,
                                                                                              color: Theme.of(context).iconTheme.color,
                                                                                            ),
                                                                                            title: Text(
                                                                                              'Kick Admin',
                                                                                              style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).iconTheme.color),
                                                                                            ),
                                                                                            onTap: () {
                                                                                              FirebaseFirestore.instance.collection('chat').doc(widget.RoomId).collection("AdminRequest").doc(ownerData["ID"]).delete();
                                                                                              FirebaseFirestore.instance.collection('chat').doc(widget.RoomId).update({
                                                                                                "admin": FieldValue.arrayRemove([ownerData["ID"]])
                                                                                              });

                                                                                              Navigator.pop(context);
                                                                                            },
                                                                                          ),
                                                                                        ],
                                                                                      );
                                                                                    });
                                                                              },
                                                                              child: Icon(
                                                                                Icons.more_vert,
                                                                                color: Theme.of(context).iconTheme.color,
                                                                              ))
                                                                        ],
                                                                      )
                                                                    : Container();
                                                              } else {
                                                                return Container();
                                                              }
                                                            })
                                                      ],

                                                      // Action Button Section END
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20.sp),
                                                    child: const Divider(),
                                                  )
                                                ],
                                              ),
                                            );
                                          } else {
                                            return Container();
                                          }
                                        });
                                  }), childCount: snapshot.data.docs.length),
                                )
                              ],
                            );
                          } else {
                            return Container();
                          }
                        }),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
