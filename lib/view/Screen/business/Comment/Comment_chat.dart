import 'package:any_link_preview/any_link_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_composer/chat_composer.dart';
import 'package:chatting/Helper/color.dart';
import 'package:chatting/Helper/time.dart';
import 'package:chatting/logic/Business_profile/business_profile_cubit.dart';
import 'package:chatting/logic/photo_upload/photoupload_cubit.dart';
import 'package:chatting/main.dart';
import 'package:chatting/model/profile_model.dart';
import 'package:chatting/view/Screen/business/Comment/model/comment_model.dart';
import 'package:chatting/view/widget/MessageBox/MessageBox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:voice_message_package/voice_message_package.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Comment_chat extends StatefulWidget {
  static const String routeName = '/comment';

  static Route route({Map<String, dynamic> CommentData}) {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => Comment_chat(
              CommentData: CommentData,
            ));
  }

  final Map<String, dynamic> CommentData;
  const Comment_chat({
    Key key,
    this.CommentData,
  }) : super(key: key);

  @override
  State<Comment_chat> createState() => _Comment_chatState();
}

class _Comment_chatState extends State<Comment_chat>
    with WidgetsBindingObserver {
  TextEditingController comment = TextEditingController();
  ScrollController scrollController = ScrollController();
  String id;
  String room;
  String uid;
  bool reply = false;
  String reply_ID = '';
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Comment_date();
    _scrolldown();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      MessageStatus();
      _scrolldown();
    }
  }

  @override
  void dispose() {
    comment.dispose();
    super.dispose();
    scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void Comment_date() {
    setState(() {
      id = widget.CommentData['message_id'];
      room = widget.CommentData['Room_Id'];
      uid = sharedPreferences.getString('uid');
    });
  }

  void MessageStatus() async {
    await FirebaseFirestore.instance
        .collection("chat")
        .doc(widget.CommentData['Room_Id'])
        .collection("message")
        .doc(widget.CommentData['message_id'])
        .collection('comment')
        .where("sender", isNotEqualTo: sharedPreferences.getString('uid'))
        .get()
        .then((QuerySnapshot snapshot) {
      setState(() {
        for (var element in snapshot.docs) {
          bool read_dara = element['read'];
          if (read_dara == false) {
            FirebaseFirestore.instance
                .collection("chat")
                .doc(widget.CommentData['Room_Id'])
                .collection("message")
                .doc(widget.CommentData['message_id'])
                .collection('comment')
                .doc(element.id)
                .update({"read": true});
          }
        }
      });
    });
  }

  void _scrolldown() {
    Future.delayed(const Duration(seconds: 2), () {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    // MessageStatus();
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: .5,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        title: StreamBuilder<List<CommentModel>>(
            stream: MessageList(RoomID: room, ID: id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  "${snapshot.data.length} Comments",
                  style: TextStyle(color: Theme.of(context).iconTheme.color),
                );
              } else {
                return Container();
              }
            }),
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                // Message Header
                SliverToBoxAdapter(
                  child: Message_Header(isDarkMode),
                ),
                // Message List
                StreamBuilder<List<CommentModel>>(
                    stream: MessageList(ID: id, RoomID: room),
                    builder: (context, MessageSnapshot) {
                      if (MessageSnapshot.hasData) {
                        return SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                            if (MessageSnapshot.data[index].sender == uid) {
                              return SwipeTo(
                                onRightSwipe: () {
                                  setState(() {
                                    reply = true;
                                    reply_ID = MessageSnapshot.data[index].id;
                                  });
                                },
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 1.w, vertical: 3.w),
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
                                                builder:
                                                    (context, profileimage) {
                                                  if (profileimage.hasData) {
                                                    if (profileimage
                                                        .data.imageUrl
                                                        .contains("https://")) {
                                                      return CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(
                                                                profileimage
                                                                    .data
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

                                        ////Text Message Container

                                        if (MessageSnapshot
                                                .data[index].messageType ==
                                            'text') ...[
                                          if (MessageSnapshot
                                              .data[index].message
                                              .contains("https://")) ...[
                                            Linkpreview(
                                                MessageSnapshot, index, context,
                                                is_sender: false)
                                          ] else ...[
                                            TextMessage(
                                                MessageSnapshot, index, context,
                                                is_sender: false),
                                          ]
                                        ] else if (MessageSnapshot
                                                .data[index].messageType ==
                                            "image") ...[
                                          // Image Message Section
                                          Imagecontainer(
                                              MessageSnapshot, index, context,
                                              is_sender: false)
                                        ] else if (MessageSnapshot
                                                .data[index].messageType ==
                                            "voice") ...[
                                          Voice_Message(
                                              MessageSnapshot, index, context,
                                              is_sender: false),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 1.w, vertical: 3.w),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (MessageSnapshot
                                              .data[index].messageType ==
                                          'text') ...[
                                        if (MessageSnapshot.data[index].message
                                            .contains("https://")) ...[
                                          Linkpreview(
                                              MessageSnapshot, index, context,
                                              is_sender: true)
                                        ] else ...[
                                          TextMessage(
                                              MessageSnapshot, index, context,
                                              is_sender: true),
                                        ]
                                      ] else if (MessageSnapshot
                                              .data[index].messageType ==
                                          "image") ...[
                                        // Image Message Section
                                        Imagecontainer(
                                            MessageSnapshot, index, context,
                                            is_sender: true)
                                      ] else if (MessageSnapshot
                                              .data[index].messageType ==
                                          "voice") ...[
                                        Voice_Message(
                                            MessageSnapshot, index, context,
                                            is_sender: true),
                                      ],
                                    ],
                                  ),
                                ),
                              );
                            }
                          }, childCount: MessageSnapshot.data.length),
                        );
                      } else {
                        return SliverToBoxAdapter(
                          child: Container(),
                        );
                      }
                    })
              ],
            ),
          ),
          // Message Box Start
          MessageBox()
        ],
      ),
    );
  }

  Padding Message_Header(bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 2.5.w),
      child: Container(
        width: 100.w,
        constraints: BoxConstraints(minHeight: 20.w),
        child: Card(
          color: HexColor.fromHex("#2D7CFE"),
          child: FutureBuilder<Comment_model>(
              future: CommentDataFunction(id: id, room_ID: room),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.messageType == "text") {
                    if (snapshot.data.message.contains('https://') ||
                        snapshot.data.message.contains('http://')) {
                      return AnyLinkPreview(
                        link: snapshot.data.message,
                        displayDirection: UIDirection.uiDirectionVertical,
                        showMultimedia: true,
                        bodyMaxLines: 5,
                        bodyTextOverflow: TextOverflow.ellipsis,
                        titleStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                        bodyStyle:
                            TextStyle(color: Colors.white, fontSize: 8.sp),
                        backgroundColor: Colors.transparent,
                        removeElevation: true,
                        borderRadius: 0,
                        onTap: () {}, // This disables tap event
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.5.w, vertical: 2.5.w),
                        child: Text(
                          snapshot.data.message ?? "",
                          textAlign: TextAlign.start,
                          style:
                              TextStyle(fontSize: 15.sp, color: Colors.white),
                        ),
                      );
                    }
                  } else if (snapshot.data.messageType == 'image') {
                    return CachedNetworkImage(
                      imageUrl: snapshot.data.message,
                      fit: BoxFit.cover,
                      width: 80.w,
                    );
                  } else if (snapshot.data.messageType == "voice") {
                    return VoiceMessage(
                      audioSrc: snapshot.data.message,
                      me: true,
                      played: true,
                      meBgColor: HexColor.fromHex("#2D7CFE"),
                      meFgColor: Colors.white,
                      mePlayIconColor: Colors.black,
                    );
                  } else {
                    return Text(
                      "No found any message",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 15.sp),
                    );
                  }
                } else {
                  return Container();
                }
              }),
        ),
      ),
    );
  }

  Future<Comment_model> CommentDataFunction({String room_ID, String id}) async {
    print(id);
    DocumentSnapshot response = await FirebaseFirestore.instance
        .collection("chat")
        .doc(room_ID)
        .collection("message")
        .doc(id)
        .get();
    return Comment_model.fromJson(response.data());
  }

  Stack Linkpreview(AsyncSnapshot<List<CommentModel>> MessageSnapshot,
      int index, BuildContext context,
      {bool is_sender}) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 80.w,
          height: 62.w,
          decoration: BoxDecoration(
            color: is_sender
                ? Theme.of(context).scaffoldBackgroundColor
                : HexColor.fromHex("#2D7CFE"),
            borderRadius: is_sender
                ? BorderRadius.only(
                    bottomRight: Radius.circular(10.sp),
                    bottomLeft: Radius.circular(10.sp),
                    topLeft: Radius.circular(10.sp))
                : BorderRadius.only(
                    bottomRight: Radius.circular(10.sp),
                    bottomLeft: Radius.circular(10.sp),
                    topRight: Radius.circular(10.sp)),
            boxShadow: [
              BoxShadow(
                  spreadRadius: .1,
                  blurRadius: 2,
                  color: Theme.of(context).iconTheme.color.withOpacity(0.2),
                  offset: const Offset(0, 1))
            ],
          ),
          child: ClipRRect(
            borderRadius: is_sender
                ? BorderRadius.only(
                    bottomRight: Radius.circular(10.sp),
                    bottomLeft: Radius.circular(10.sp),
                    topLeft: Radius.circular(10.sp))
                : BorderRadius.only(
                    bottomRight: Radius.circular(10.sp),
                    bottomLeft: Radius.circular(10.sp),
                    topRight: Radius.circular(10.sp)),
            child: Column(
              children: [
                AnyLinkPreview(
                  link: MessageSnapshot.data[index].message,
                  displayDirection: UIDirection.uiDirectionVertical,
                  showMultimedia: true,
                  bodyMaxLines: 5,
                  bodyTextOverflow: TextOverflow.ellipsis,
                  titleStyle: TextStyle(
                    color: is_sender
                        ? Theme.of(context).iconTheme.color
                        : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                  bodyStyle: TextStyle(
                      color: is_sender
                          ? Theme.of(context).iconTheme.color
                          : Colors.white,
                      fontSize: 8.sp),
                  backgroundColor: is_sender
                      ? Theme.of(context).scaffoldBackgroundColor
                      : HexColor.fromHex("#2D7CFE"),

                  removeElevation: true,
                  borderRadius: 0,
                  onTap: () {}, // This disables tap event
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        Time_Chat.readTimestamp(
                            MessageSnapshot.data[index].time),
                        style: GoogleFonts.openSans(
                            fontSize: 12.sp,
                            color: is_sender
                                ? Theme.of(context).iconTheme.color
                                : Colors.white),
                      ),
                      if (is_sender) ...[
                        SizedBox(
                          width: 5.sp,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/Business_status_icon/unsee.svg",
                              width: 11.sp,
                              color: MessageSnapshot.data[index].read
                                  ? HexColor.fromHex("#2D7CFE")
                                  : Colors.grey,
                            ),
                            SvgPicture.asset(
                              "assets/Business_status_icon/unsee.svg",
                              width: 11.sp,
                              color: MessageSnapshot.data[index].read
                                  ? HexColor.fromHex("#2D7CFE")
                                  : Colors.grey,
                            )
                          ],
                        )
                      ]
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          bottom: -10.sp,
          left: 30.sp,
          child: InkWell(
            onTap: () {
              if (MessageSnapshot.data[index].like.contains(uid)) {
                FirebaseFirestore.instance
                    .collection("chat")
                    .doc(room)
                    .collection('message')
                    .doc(id)
                    .collection('comment')
                    .doc(MessageSnapshot.data[index].id)
                    .update({
                  "like": FieldValue.arrayRemove([uid])
                });
              } else {
                FirebaseFirestore.instance
                    .collection("chat")
                    .doc(room)
                    .collection('message')
                    .doc(id)
                    .collection('comment')
                    .doc(MessageSnapshot.data[index].id)
                    .update({
                  "like": FieldValue.arrayUnion([uid])
                });
              }
            },
            child: Container(
              height: 8.w,
              width: MessageSnapshot.data[index].like.isEmpty ? 8.w : 12.w,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2.sp),
                  color: HexColor.fromHex("#E5F2FE"),
                  borderRadius: BorderRadius.circular(50.sp)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: SvgPicture.asset(
                      "assets/svg/likechat.svg",
                      width:
                          MessageSnapshot.data[index].like.isEmpty ? 5.w : 4.w,
                    ),
                  ),
                  if (MessageSnapshot.data[index].like.isNotEmpty) ...[
                    Expanded(
                        child: Text(
                      doublenumber(
                          number: MessageSnapshot.data[index].like.length),
                      style: GoogleFonts.openSans(
                          color: HexColor.fromHex("#2C7AFF"),
                          fontWeight: FontWeight.bold),
                    )),
                  ]
                ],
              ),
            ),
          ),
        ),
        Positioned(
          child: !is_sender
              ? StreamBuilder<profile_model>(
                  stream: profileInfo(uid: MessageSnapshot.data[index].sender),
                  builder: (context, ProfileInfo) {
                    if (ProfileInfo.hasData) {
                      return Padding(
                        padding: EdgeInsets.only(left: 5.w, top: 2.w),
                        child: Text(
                          "${ProfileInfo.data.fullName} ${ProfileInfo.data.lastname ?? ""}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  })
              : Container(),
        ),
      ],
    );
  }

  /// voice Message Block section
  Stack Voice_Message(AsyncSnapshot<List<CommentModel>> MessageSnapshot,
      int index, BuildContext context,
      {bool is_sender}) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: !is_sender ? 30.w : 23.5.w,
          width: 55.w,
          decoration: BoxDecoration(
            color: is_sender
                ? Theme.of(context).scaffoldBackgroundColor
                : HexColor.fromHex("#2D7CFE"),
            borderRadius: is_sender
                ? BorderRadius.only(
                    bottomRight: Radius.circular(10.sp),
                    bottomLeft: Radius.circular(10.sp),
                    topLeft: Radius.circular(10.sp))
                : BorderRadius.only(
                    bottomRight: Radius.circular(10.sp),
                    bottomLeft: Radius.circular(10.sp),
                    topRight: Radius.circular(10.sp)),
            boxShadow: [
              BoxShadow(
                  spreadRadius: .1,
                  blurRadius: 2,
                  color: Theme.of(context).iconTheme.color.withOpacity(0.2),
                  offset: const Offset(0, 1))
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              !is_sender
                  ? StreamBuilder<profile_model>(
                      stream:
                          profileInfo(uid: MessageSnapshot.data[index].sender),
                      builder: (context, ProfileInfo) {
                        if (ProfileInfo.hasData) {
                          return Padding(
                            padding: EdgeInsets.only(left: 5.w, top: 2.w),
                            child: Text(
                              "${ProfileInfo.data.fullName} ${ProfileInfo.data.lastname ?? ""}",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      })
                  : Container(),
              VoiceMessage(
                audioSrc: MessageSnapshot.data[index].message,
                me: is_sender ? false : true,
                played: true,
                meBgColor: HexColor.fromHex("#2D7CFE"),
                contactFgColor: HexColor.fromHex("#2D7CFE"),
                contactPlayIconColor: Theme.of(context).secondaryHeaderColor,
                contactBgColor: is_sender
                    ? Theme.of(context).scaffoldBackgroundColor
                    : HexColor.fromHex("#2D7CFE"),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      Time_Chat.readTimestamp(MessageSnapshot.data[index].time),
                      style: GoogleFonts.openSans(
                          fontSize: 12.sp,
                          color: is_sender
                              ? Theme.of(context).iconTheme.color
                              : Colors.white),
                    ),
                    if (is_sender) ...[
                      SizedBox(
                        width: 5.sp,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/Business_status_icon/unsee.svg",
                            width: 11.sp,
                            color: MessageSnapshot.data[index].read
                                ? HexColor.fromHex("#2D7CFE")
                                : Colors.grey,
                          ),
                          SvgPicture.asset(
                            "assets/Business_status_icon/unsee.svg",
                            width: 11.sp,
                            color: MessageSnapshot.data[index].read
                                ? HexColor.fromHex("#2D7CFE")
                                : Colors.grey,
                          )
                        ],
                      )
                    ]
                  ],
                ),
              )
            ],
          ),
        ),
        Positioned(
          bottom: -10.sp,
          left: 30.sp,
          child: InkWell(
            onTap: () {
              if (MessageSnapshot.data[index].like.contains(uid)) {
                FirebaseFirestore.instance
                    .collection("chat")
                    .doc(room)
                    .collection('message')
                    .doc(id)
                    .collection('comment')
                    .doc(MessageSnapshot.data[index].id)
                    .update({
                  "like": FieldValue.arrayRemove([uid])
                });
              } else {
                FirebaseFirestore.instance
                    .collection("chat")
                    .doc(room)
                    .collection('message')
                    .doc(id)
                    .collection('comment')
                    .doc(MessageSnapshot.data[index].id)
                    .update({
                  "like": FieldValue.arrayUnion([uid])
                });
              }
            },
            child: Container(
              height: 8.w,
              width: MessageSnapshot.data[index].like.isEmpty ? 8.w : 12.w,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2.sp),
                  color: HexColor.fromHex("#E5F2FE"),
                  borderRadius: BorderRadius.circular(50.sp)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: SvgPicture.asset(
                      "assets/svg/likechat.svg",
                      width:
                          MessageSnapshot.data[index].like.isEmpty ? 5.w : 4.w,
                    ),
                  ),
                  if (MessageSnapshot.data[index].like.isNotEmpty) ...[
                    Expanded(
                        child: Text(
                      doublenumber(
                          number: MessageSnapshot.data[index].like.length),
                      style: GoogleFonts.openSans(
                          color: HexColor.fromHex("#2C7AFF"),
                          fontWeight: FontWeight.bold),
                    )),
                  ]
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Stack Imagecontainer(AsyncSnapshot<List<CommentModel>> MessageSnapshot,
      int index, BuildContext context,
      {bool is_sender}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: is_sender
              ? BorderRadius.only(
                  bottomRight: Radius.circular(10.sp),
                  bottomLeft: Radius.circular(10.sp),
                  topLeft: Radius.circular(10.sp))
              : BorderRadius.only(
                  bottomRight: Radius.circular(10.sp),
                  bottomLeft: Radius.circular(10.sp),
                  topLeft: Radius.circular(10.sp)),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    spreadRadius: .1,
                    blurRadius: 2,
                    color: Theme.of(context).iconTheme.color.withOpacity(0.2),
                    offset: const Offset(0, 1))
              ],
            ),
            child: CachedNetworkImage(
              imageUrl: MessageSnapshot.data[index].message,
              width: 80.w,
            ),
          ),
        ),
        Positioned(
          child: !is_sender
              ? StreamBuilder<profile_model>(
                  stream: profileInfo(uid: MessageSnapshot.data[index].sender),
                  builder: (context, ProfileInfo) {
                    if (ProfileInfo.hasData) {
                      return Padding(
                        padding: EdgeInsets.only(left: 5.w, top: 2.w),
                        child: Text(
                          "${ProfileInfo.data.fullName} ${ProfileInfo.data.lastname ?? ""}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  })
              : Container(),
        ),
        Positioned(
          right: 10.sp,
          bottom: 5.sp,
          child: Row(
            children: [
              Text(
                Time_Chat.readTimestamp(MessageSnapshot.data[index].time),
                style:
                    GoogleFonts.openSans(fontSize: 12.sp, color: Colors.white),
              ),
              if (is_sender) ...[
                SizedBox(
                  width: 5.sp,
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/Business_status_icon/unsee.svg",
                      width: 11.sp,
                      color: MessageSnapshot.data[index].read
                          ? HexColor.fromHex("#2D7CFE")
                          : Colors.white,
                    ),
                    SvgPicture.asset(
                      "assets/Business_status_icon/unsee.svg",
                      width: 11.sp,
                      color: MessageSnapshot.data[index].read
                          ? HexColor.fromHex("#2D7CFE")
                          : Colors.white,
                    )
                  ],
                )
              ]
            ],
          ),
        ),
        Positioned(
          bottom: -10.sp,
          left: 30.sp,
          child: InkWell(
            onTap: () {
              if (MessageSnapshot.data[index].like.contains(uid)) {
                FirebaseFirestore.instance
                    .collection("chat")
                    .doc(room)
                    .collection('message')
                    .doc(id)
                    .collection('comment')
                    .doc(MessageSnapshot.data[index].id)
                    .update({
                  "like": FieldValue.arrayRemove([uid])
                });
              } else {
                FirebaseFirestore.instance
                    .collection("chat")
                    .doc(room)
                    .collection('message')
                    .doc(id)
                    .collection('comment')
                    .doc(MessageSnapshot.data[index].id)
                    .update({
                  "like": FieldValue.arrayUnion([uid])
                });
              }
            },
            child: Container(
              height: 8.w,
              width: MessageSnapshot.data[index].like.isEmpty ? 8.w : 12.w,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2.sp),
                  color: HexColor.fromHex("#E5F2FE"),
                  borderRadius: BorderRadius.circular(50.sp)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: SvgPicture.asset(
                      "assets/svg/likechat.svg",
                      width:
                          MessageSnapshot.data[index].like.isEmpty ? 5.w : 4.w,
                    ),
                  ),
                  if (MessageSnapshot.data[index].like.isNotEmpty) ...[
                    Expanded(
                        child: Text(
                      doublenumber(
                          number: MessageSnapshot.data[index].like.length),
                      style: GoogleFonts.openSans(
                          color: HexColor.fromHex("#2C7AFF"),
                          fontWeight: FontWeight.bold),
                    )),
                  ]
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Text Message Container
  ///
  ///
  Container TextMessage(AsyncSnapshot<List<CommentModel>> MessageSnapshot,
      int index, BuildContext context,
      {bool is_sender}) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Container(
        constraints: BoxConstraints(
          maxWidth: MessageContainerWidth(
                  length: MessageSnapshot.data[index].message.length)
              .w,
          minHeight: 10.w,
        ),
        decoration: BoxDecoration(
          color: is_sender
              ? Theme.of(context).scaffoldBackgroundColor
              : HexColor.fromHex("#2D7CFE"),
          borderRadius: is_sender
              ? BorderRadius.only(
                  bottomRight: Radius.circular(10.sp),
                  bottomLeft: Radius.circular(10.sp),
                  topLeft: Radius.circular(10.sp))
              : BorderRadius.only(
                  bottomRight: Radius.circular(10.sp),
                  bottomLeft: Radius.circular(10.sp),
                  topRight: Radius.circular(10.sp)),
          boxShadow: [
            BoxShadow(
                spreadRadius: .1,
                blurRadius: 2,
                color: Theme.of(context).iconTheme.color.withOpacity(0.2),
                offset: const Offset(0, 1))
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 2.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  !is_sender
                      ? StreamBuilder<profile_model>(
                          stream: profileInfo(
                              uid: MessageSnapshot.data[index].sender),
                          builder: (context, ProfileInfo) {
                            if (ProfileInfo.hasData) {
                              return Text(
                                "${ProfileInfo.data.fullName} ${ProfileInfo.data.lastname ?? ""}",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    color: is_sender
                                        ? Theme.of(context).iconTheme.color
                                        : Colors.white,
                                    fontWeight: FontWeight.bold),
                              );
                            } else {
                              return Container();
                            }
                          })
                      : Container(),
                  // SizedBox(
                  //   height: 5.sp,
                  // ),
                  //Text Message Section

                  Text(
                    MessageSnapshot.data[index].message,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.openSans(
                        fontSize: 15.sp,
                        color: is_sender
                            ? Theme.of(context).iconTheme.color
                            : Colors.white),
                  ),

                  // SizedBox(
                  //   height: 4.w,
                  // ),
                  // Message Time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        Time_Chat.readTimestamp(
                            MessageSnapshot.data[index].time),
                        style: GoogleFonts.openSans(
                            fontSize: 12.sp,
                            color: is_sender
                                ? Theme.of(context).iconTheme.color
                                : Colors.white),
                      ),
                      if (is_sender) ...[
                        SizedBox(
                          width: 5.sp,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/Business_status_icon/unsee.svg",
                              width: 11.sp,
                              color: MessageSnapshot.data[index].read
                                  ? HexColor.fromHex("#2D7CFE")
                                  : Colors.grey,
                            ),
                            SvgPicture.asset(
                              "assets/Business_status_icon/unsee.svg",
                              width: 11.sp,
                              color: MessageSnapshot.data[index].read
                                  ? HexColor.fromHex("#2D7CFE")
                                  : Colors.grey,
                            )
                          ],
                        )
                      ]
                    ],
                  ),
                ],
              ),
            ),
            // Like and Comment Button

            Positioned(
              bottom: -10.sp,
              left: 30.sp,
              child: InkWell(
                onTap: () {
                  if (MessageSnapshot.data[index].like.contains(uid)) {
                    FirebaseFirestore.instance
                        .collection("chat")
                        .doc(room)
                        .collection('message')
                        .doc(id)
                        .collection('comment')
                        .doc(MessageSnapshot.data[index].id)
                        .update({
                      "like": FieldValue.arrayRemove([uid])
                    });
                  } else {
                    FirebaseFirestore.instance
                        .collection("chat")
                        .doc(room)
                        .collection('message')
                        .doc(id)
                        .collection('comment')
                        .doc(MessageSnapshot.data[index].id)
                        .update({
                      "like": FieldValue.arrayUnion([uid])
                    });
                  }
                },
                child: Container(
                  height: 8.w,
                  width: MessageSnapshot.data[index].like.isEmpty ? 8.w : 12.w,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2.sp),
                      color: HexColor.fromHex("#E5F2FE"),
                      borderRadius: BorderRadius.circular(50.sp)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: SvgPicture.asset(
                          "assets/svg/likechat.svg",
                          width: MessageSnapshot.data[index].like.isEmpty
                              ? 5.w
                              : 4.w,
                        ),
                      ),
                      if (MessageSnapshot.data[index].like.isNotEmpty) ...[
                        Expanded(
                            child: Text(
                          doublenumber(
                              number: MessageSnapshot.data[index].like.length),
                          style: GoogleFonts.openSans(
                              color: HexColor.fromHex("#2C7AFF"),
                              fontWeight: FontWeight.bold),
                        )),
                      ]
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  int MessageContainerWidth({int length}) {
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

  String doublenumber({int number}) {
    return number < 10 && number >= 0 ? "0$number" : "$number";
  }

  Stream<profile_model> profileInfo({String uid}) {
    final _response =
        FirebaseFirestore.instance.collection("user").doc(uid).snapshots();
    return _response.map((DocumentSnapshot snapshot) =>
        profile_model.fromJson(snapshot.data(), id: snapshot.id));
  }

  Stream<List<CommentModel>> MessageList({String RoomID, String ID}) {
    final response = FirebaseFirestore.instance
        .collection("chat")
        .doc(RoomID)
        .collection("message")
        .doc(id)
        .collection("comment")
        .orderBy('time')
        .snapshots();
    return response.map((QuerySnapshot snapshot) => snapshot.docs
        .map((DocumentSnapshot doc) =>
            CommentModel.fromJson(doc.data(), id: doc.id))
        .toList());
  }

  Future<CommentModel> reply_message(
      {String message_id, String room, String id}) async {
    final response = await FirebaseFirestore.instance
        .collection("chat")
        .doc(room)
        .collection("message")
        .doc(message_id)
        .collection("comment")
        .doc(id)
        .get();
    return CommentModel.fromJson(response.data());
  }

  void MessageSend(
      {String message,
      String message_id,
      String type,
      String sendUID,
      String roomId}) async {
    FirebaseFirestore.instance
        .collection("chat")
        .doc(roomId)
        .collection("message")
        .doc(id)
        .collection("comment")
        .add({
      "message": message,
      "like": [],
      "time": DateTime.now().millisecondsSinceEpoch,
      "message_type": type,
      "sender": sendUID,
      "read": false,
    });
  }
}
