import 'package:chat_composer/chat_composer.dart';
import 'package:chatting/Helper/color.dart';
import 'package:chatting/Helper/config.dart';
import 'package:chatting/logic/Business_profile/business_profile_cubit.dart';
import 'package:chatting/logic/photo_upload/photoupload_cubit.dart';
import 'package:chatting/model/profile_model.dart';
import 'package:chatting/view/Screen/business/chat/model/messagemodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:yelp_fusion_client/models/business_endpoints/business_details.dart';
import 'package:http/http.dart' as http;

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ChatView extends StatefulWidget {
  const ChatView({Key key, this.roomId, this.uid}) : super(key: key);
  final String roomId;
  final String uid;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  void initState() {
    super.initState();
    BusinessBloc();
  }

  void BusinessBloc() {
    context
        .read<BusinessProfileCubit>()
        .get_Business_Profile(room_id: widget.roomId);
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    print("-------------Welcome to Chat View-------------------");
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: isDarkMode
                  ? const AssetImage('assets/image/Black_Background.png')
                  : const AssetImage('assets/image/White_Background.png'),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          shadowColor: Theme.of(context).iconTheme.color.withOpacity(0.5),
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          centerTitle: true,
          iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
          title: Builder(builder: (context) {
            final ProfileInfo = context.watch<BusinessProfileCubit>().state;
            if (ProfileInfo is HasData_Business_Profile) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    ProfileInfo.business.businessName,
                    style: TextStyle(
                        color: Theme.of(context).iconTheme.color,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    ProfileInfo.business.address,
                    style:
                        TextStyle(color: Colors.grey.shade500, fontSize: 10.sp),
                  ),
                ],
              );
            } else {
              return Container();
            }
          }),
          actions: [
            ///
            ///
            ///
            ///
            ///Profile
            ///
            ///
            ///
            ///
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed('/admin_profile', arguments: widget.roomId);
                },
                child: Builder(builder: (context) {
                  final image = context.watch<BusinessProfileCubit>().state;
                  if (image is HasData_Business_Profile) {
                    return CircleAvatar(
                      backgroundImage: NetworkImage(image.business.imageURl),
                      maxRadius: 15.sp,
                    );
                  } else {
                    return CircleAvatar(
                      maxRadius: 15.sp,
                    );
                  }
                }),
              ),
            ),

            ///
            ///
            ///
            ///
            ///
            ///Profiel END
          ],
        ),
        body: Column(
          children: [
            Expanded(
                child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Builder(builder: (context) {
                    final BusinessInfo =
                        context.watch<BusinessProfileCubit>().state;
                    if (BusinessInfo is HasData_Business_Profile) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 8.w,
                          ),
                          CircleAvatar(
                            radius: 40.sp,
                            backgroundImage:
                                NetworkImage(BusinessInfo.business.imageURl),
                          ),
                          SizedBox(
                            height: 5.w,
                          ),
                          Text(
                            BusinessInfo.business.businessName,
                            style: TextStyle(
                                fontSize: 20.sp,
                                color: Theme.of(context).iconTheme.color,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            BusinessInfo.business.address,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                          Text(
                            "${BusinessInfo.business.customer.length} Members",
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: Theme.of(context).iconTheme.color,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5.w,
                          ),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  }),
                ),
                StreamBuilder<List<MessageModel>>(
                    stream: MessageList(RoomID: widget.roomId),
                    builder: (context, MessageSnapshot) {
                      if (MessageSnapshot.hasData) {
                        return SliverList(
                            delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (MessageSnapshot.data[index].sender ==
                                widget.uid) {
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                          alignment: Alignment.topLeft,
                                          child: StreamBuilder<profile_model>(
                                              stream: profileInfo(
                                                  uid: MessageSnapshot
                                                      .data[index].sender),
                                              builder: (context, profileimage) {
                                                if (profileimage.hasData) {
                                                  if (profileimage.data.imageUrl
                                                      .contains("https://")) {
                                                    return CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(
                                                              profileimage.data
                                                                  .imageUrl),
                                                    );
                                                  } else {
                                                    return ProfilePicture(
                                                      random: true,
                                                      count: 2,
                                                      name: profileimage
                                                          .data.imageUrl,
                                                    );
                                                  }
                                                } else {
                                                  return const GFShimmer(
                                                      child: CircleAvatar());
                                                }
                                              })),
                                      SizedBox(
                                        width: 5.sp,
                                      ),
                                      Container(
                                          constraints: BoxConstraints(
                                            maxWidth: MessageContainerWidth(
                                                    length: MessageSnapshot
                                                        .data[index]
                                                        .message
                                                        .length)
                                                .w,
                                            minHeight: 10.w,
                                          ),
                                          decoration: BoxDecoration(
                                              color:
                                                  HexColor.fromHex("#2D7CFE"),
                                              borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(10.sp),
                                                  bottomLeft:
                                                      Radius.circular(10.sp),
                                                  topRight:
                                                      Radius.circular(10.sp))),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 3.5.w,
                                                vertical: 3.5.w),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                StreamBuilder<profile_model>(
                                                    stream: profileInfo(
                                                        uid: MessageSnapshot
                                                            .data[index]
                                                            .sender),
                                                    builder:
                                                        (context, ProfileInfo) {
                                                      if (ProfileInfo.hasData) {
                                                        return Text(
                                                          "${ProfileInfo.data.fullName} ${ProfileInfo.data.lastname ?? ""}",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              fontSize: 12.sp,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        );
                                                      } else {
                                                        return Container();
                                                      }
                                                    }),
                                                SizedBox(
                                                  height: 5.sp,
                                                ),
                                                Text(
                                                  MessageSnapshot
                                                      .data[index].message,
                                                  textAlign: TextAlign.start,
                                                  style: GoogleFonts.openSans(
                                                      fontSize: 15.sp,
                                                      color: Colors.white),
                                                ),
                                                SizedBox(
                                                  height: 4.w,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            if (MessageSnapshot
                                                                .data[index]
                                                                .like
                                                                .contains(widget
                                                                    .uid)) {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'chat')
                                                                  .doc(widget
                                                                      .roomId)
                                                                  .collection(
                                                                      'message')
                                                                  .doc(MessageSnapshot
                                                                      .data[
                                                                          index]
                                                                      .id)
                                                                  .update({
                                                                "Like": FieldValue
                                                                    .arrayRemove([
                                                                  widget.uid
                                                                ])
                                                              });
                                                            } else {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'chat')
                                                                  .doc(widget
                                                                      .roomId)
                                                                  .collection(
                                                                      'message')
                                                                  .doc(MessageSnapshot
                                                                      .data[
                                                                          index]
                                                                      .id)
                                                                  .update({
                                                                "Like": FieldValue
                                                                    .arrayUnion([
                                                                  widget.uid
                                                                ])
                                                              });
                                                            }
                                                          },
                                                          child: Container(
                                                            height: 6.w,
                                                            width: MessageSnapshot
                                                                    .data[index]
                                                                    .like
                                                                    .isEmpty
                                                                ? 12.w
                                                                : 15.w,
                                                            decoration: BoxDecoration(
                                                                color: HexColor
                                                                    .fromHex(
                                                                        "#E5F2FE"),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.sp)),
                                                            child: Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 3.w,
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    "assets/svg/likechat.svg",
                                                                    width: MessageSnapshot
                                                                            .data[index]
                                                                            .like
                                                                            .isEmpty
                                                                        ? 8.w
                                                                        : 15.w,
                                                                  ),
                                                                ),
                                                                if (MessageSnapshot
                                                                    .data[index]
                                                                    .like
                                                                    .isNotEmpty) ...[
                                                                  Expanded(
                                                                      child:
                                                                          Text(
                                                                    "${MessageSnapshot.data[index].like.length}",
                                                                    style: GoogleFonts.openSans(
                                                                        color: HexColor.fromHex(
                                                                            "#2C7AFF"),
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  )),
                                                                ]
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 5.w,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pushNamed(
                                                                    '/comment',
                                                                    arguments: {
                                                                  "message_id":
                                                                      MessageSnapshot
                                                                          .data[
                                                                              index]
                                                                          .id,
                                                                  "Room_Id":
                                                                      widget
                                                                          .roomId
                                                                });
                                                          },
                                                          child: StreamBuilder<
                                                                  QuerySnapshot>(
                                                              stream: FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'chat')
                                                                  .doc(widget
                                                                      .roomId)
                                                                  .collection(
                                                                      'message')
                                                                  .doc(MessageSnapshot
                                                                      .data[
                                                                          index]
                                                                      .id)
                                                                  .collection(
                                                                      'comment')
                                                                  .snapshots(),
                                                              builder: (context,
                                                                  Commentsnapshot) {
                                                                if (Commentsnapshot
                                                                    .hasData) {
                                                                  return Container(
                                                                    height: 6.w,
                                                                    width: Commentsnapshot
                                                                            .data
                                                                            .docs
                                                                            .isEmpty
                                                                        ? 12.w
                                                                        : 15.w,
                                                                    decoration: BoxDecoration(
                                                                        color: HexColor.fromHex(
                                                                            "#E5F2FE"),
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.sp)),
                                                                    child: Row(
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              3.w,
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              SvgPicture.asset(
                                                                            "assets/svg/commentcht.svg",
                                                                            width: Commentsnapshot.data.docs.isEmpty
                                                                                ? 8.w
                                                                                : 15.w,
                                                                          ),
                                                                        ),
                                                                        if (Commentsnapshot
                                                                            .data
                                                                            .docs
                                                                            .isNotEmpty) ...[
                                                                          Expanded(
                                                                              child: Text(
                                                                            "${Commentsnapshot.data.docs.length}",
                                                                            style:
                                                                                GoogleFonts.openSans(color: HexColor.fromHex("#2C7AFF"), fontWeight: FontWeight.bold),
                                                                          )),
                                                                        ]
                                                                      ],
                                                                    ),
                                                                  );
                                                                } else {
                                                                  return Container();
                                                                }
                                                              }),
                                                        )
                                                      ],
                                                    ),
                                                    Text(
                                                      "12:30 PM",
                                                      style:
                                                          GoogleFonts.openSans(
                                                              fontSize: 12.sp,
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return ListTile(
                                title: Text("Client"),
                              );
                            }
                          },
                          childCount: MessageSnapshot.data.length,
                        ));
                      } else {
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return Container();
                            },
                            childCount: 1,
                          ),
                        );
                      }
                    })
              ],
            )),

            // Message Box Start
            ///
            ///
            ///
            ///
            ///
            ///
            ///
            ///
            ///

            StreamBuilder<BusinessDetails>(
                stream: YelpBusinessDetailsStream(BusinessId: widget.roomId),
                builder: (context, BusinessHourStatus) {
                  final admin_owner =
                      context.watch<BusinessProfileCubit>().state;
                  if (BusinessHourStatus.hasData &&
                      admin_owner is HasData_Business_Profile) {
                    if (BusinessHourStatus.data.isClosed &&
                        (admin_owner.business.admin.contains(widget.uid) ||
                            admin_owner.business.owner.contains(widget.uid))) {
                      return Container(
                        height: 20.w,
                        width: 100.w,
                        alignment: Alignment.center,
                        color: Theme.of(context).secondaryHeaderColor,
                        child: Text(
                          "Business Close",
                          style: TextStyle(fontSize: 15.sp),
                        ),
                      );
                    } else {
                      return MessageBox(context);
                    }
                  } else {
                    return MessageBox(context);
                  }
                }),
          ],
        ),
      ),
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
  ///
  ///
  ///
  ///
// Message Box Method
  Widget MessageBox(BuildContext context) {
    return Container(
      height: 20.w,
      decoration: BoxDecoration(
          color: Theme.of(context).secondaryHeaderColor,
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).iconTheme.color.withOpacity(0.5),
                blurRadius: 2,
                offset: Offset(0, 0))
          ]),
      child: Row(
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: SvgPicture.asset("assets/svg/add_message.svg"),
            onPressed: () async {
              final result = await FilePicker.platform.pickFiles(
                  allowMultiple: false,
                  type: FileType.custom,
                  allowedExtensions: ['png', 'jpg', 'gif']);

              if (result != null) {
                final path = result.files.single.path;
                final name = result.files.single.name;
                context
                    .read<PhotouploadCubit>()
                    .updateData(path, name, name)
                    .then(
                  (value) async {
                    String imagurl = await firebase_storage
                        .FirebaseStorage.instance
                        .ref('userimage//')
                        .getDownloadURL();

                    if (imagurl != null) {
                      setState(() {
                        // messagesend(
                        //     message: imagurl,
                        //     message_type:
                        //         'image');
                      });
                    }
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
          ///Text Input Bar Start
          ///
          ///
          ///
          Expanded(
            child: Theme(
              data: ThemeData(),
              child: ChatComposer(
                padding: const EdgeInsets.symmetric(vertical: 10),
                onReceiveText: (str) {
                  setState(() {
                    // messagesend(
                    //     message: str,
                    //     message_type: "text");

                    // WidgetsBinding.instance
                    //     .addPostFrameCallback(
                    //         (_) =>
                    //             _scrollDown());
                    // messaage.clear();
                  });
                },
                onRecordEnd: (String path) {
                  String name = path.split('/').last;

                  context
                      .read<PhotouploadCubit>()
                      .updateData(path, name, name)
                      .then((value) async {
                    print("Done");
                    String voiceurl = await firebase_storage
                        .FirebaseStorage.instance
                        .ref('userimage//')
                        .getDownloadURL();
                    print(voiceurl);
                    if (voiceurl != null) {
                      setState(() {
                        // messagesend(
                        //     message: voiceurl,
                        //     message_type:
                        //         'voice');
                      });
                    }
                  });
                },
                recordIconColor: Theme.of(context).iconTheme.color,
                sendButtonColor: Theme.of(context).iconTheme.color,
                backgroundColor: Colors.transparent,
                sendButtonBackgroundColor: Colors.transparent,
              ),
            ),
          ),

          ///
          ///
          ///
          ///
          ///END
          ///
          ///
          ///
          ///
        ],
      ),
    );
  }

  int MessageContainerWidth({int length}) {
    print(length);
    if (length <= 5) {
      return 65;
    } else if (length <= 15) {
      return 70;
    } else if (length <= 25) {
      return 75;
    } else if (length <= 35) {
      return 80;
    } else {
      return 80;
    }
  }

  Stream<profile_model> profileInfo({String uid}) {
    final _response =
        FirebaseFirestore.instance.collection("user").doc(uid).snapshots();
    return _response.map((DocumentSnapshot snapshot) =>
        profile_model.fromJson(snapshot.data(), id: snapshot.id));
  }

  Stream<List<MessageModel>> MessageList({String RoomID}) {
    final response = FirebaseFirestore.instance
        .collection("chat")
        .doc(RoomID)
        .collection("message")
        .orderBy("time")
        .snapshots();
    return response.map((QuerySnapshot snapshot) => snapshot.docs
        .map((DocumentSnapshot doc) =>
            MessageModel.fromJson(doc.data(), id: doc.id))
        .toList());
  }

  Stream<BusinessDetails> YelpBusinessDetailsStream(
      {String BusinessId}) async* {
    try {
      var res = await http.get(
          Uri.parse(
            "https://api.yelp.com/v3/businesses/${BusinessId}",
          ),
          headers: {"Authorization": 'bearer $YELPAPIKEY'});
      print(res.body);
      yield BusinessDetails.fromJson(res.body);
    } catch (e) {}
  }
}
