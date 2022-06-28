import 'dart:math';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting/Helper/color.dart';
import 'package:chatting/main.dart';
import 'package:chatting/view/widget/business/widget/voice_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class receiver extends StatefulWidget {
  const receiver({
    Key key,
    @required this.userdoc,
    @required this.isDarkMode,
    @required this.Room_Data,
    @required this.islink,
    @required this.myUID,
    @required this.message_time,
    this.messageId,
    this.RoomID,
  }) : super(key: key);

  final Map<String, dynamic> userdoc;
  final bool isDarkMode;
  final Map<String, dynamic> Room_Data;
  final bool islink;
  final String messageId;
  final String message_time;
  final String myUID;
  final String RoomID;

  @override
  State<receiver> createState() => _receiverState();
}

class _receiverState extends State<receiver> {
  String uid;
  List like_count;
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      uid = sharedPreferences.getString('uid');
      widget.Room_Data['Like'] != null
          ? like_count = (widget.Room_Data['Like'])
          : null;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 12.sp,
              backgroundImage: NetworkImage(widget.userdoc["imageUrl"]),
            ),
            SizedBox(
              width: 1.5.w,
            ),
            Text(
              widget.userdoc['first_name'],
              style: TextStyle(
                  color: Colors
                      .primaries[Random().nextInt(Colors.primaries.length)]),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 25.sp),
          child: Column(
            children: [
              Container(
                constraints: BoxConstraints(
                    minHeight: 12.w, maxWidth: 70.w, minWidth: 25.w),
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: widget.isDarkMode
                                ? HexColor.fromHex("#1a1a1c")
                                : HexColor.fromHex('#F2F5F7'),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (widget.Room_Data['message_type'] !=
                                        'image' &&
                                    widget.islink == false) ...[
                                  Text(
                                    widget.Room_Data['message'],
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).iconTheme.color,
                                        fontSize: 12.sp),
                                  ),
                                ] else if (widget.islink == true &&
                                    widget.Room_Data['message_type'] ==
                                        'text') ...[
                                  AnyLinkPreview(
                                    link: widget.Room_Data['message'],
                                    displayDirection:
                                        UIDirection.uiDirectionVertical,
                                    showMultimedia: true,
                                    bodyMaxLines: 5,
                                    bodyTextOverflow: TextOverflow.ellipsis,
                                    titleStyle: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    bodyStyle: TextStyle(
                                        color:
                                            Theme.of(context).iconTheme.color,
                                        fontSize: 12),
                                    errorBody: 'Show my custom error body',
                                    errorTitle: 'Show my custom error title',
                                    errorWidget: Container(
                                      color: widget.Room_Data['sender'] ==
                                              widget.myUID
                                          ? HexColor.fromHex("#1ea1f1")
                                          : widget.isDarkMode
                                              ? HexColor.fromHex("#1a1a1c")
                                              : HexColor.fromHex("#f2f5f6"),
                                      child: const Text('Oops!'),
                                    ),
                                    errorImage: widget.Room_Data['message'],
                                    cache: const Duration(days: 7),
                                    backgroundColor:
                                        widget.Room_Data['sender'] ==
                                                widget.myUID
                                            ? HexColor.fromHex("#1ea1f1")
                                            : widget.isDarkMode
                                                ? HexColor.fromHex("#1a1a1c")
                                                : HexColor.fromHex("#f2f5f6"),

                                    removeElevation: true,
                                    onTap: () async {
                                      if (!await launch(
                                          widget.Room_Data['message']))
                                        throw 'Could not launch ${widget.Room_Data['message']}';
                                    }, // This disables tap event
                                  )
                                ] else if (widget.Room_Data['message_type'] ==
                                    'voice') ...[
                                  // voice Message Start

                                  voice_message(
                                    Room_Data: widget.Room_Data,
                                    myUID: widget.myUID,
                                    isDarkMode: widget.isDarkMode,
                                    isreceiver: true,
                                  )

                                  // voice Message End
                                ] else ...[
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          '/business_image_show',
                                          arguments:
                                              widget.Room_Data['message']);
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: CachedNetworkImage(
                                        width: double.infinity,
                                        height: 70.w,
                                        fit: BoxFit.cover,
                                        imageUrl: widget.Room_Data['message'],
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                ],
                                SizedBox(
                                  height: 2.w,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        StreamBuilder<
                                                DocumentSnapshot<
                                                    Map<String, dynamic>>>(
                                            stream: FirebaseFirestore.instance
                                                .collection('chat')
                                                .doc(widget.RoomID)
                                                .collection('message')
                                                .doc(widget.messageId)
                                                .snapshots(),
                                            builder: (context,
                                                AsyncSnapshot<
                                                        DocumentSnapshot<
                                                            Map<String,
                                                                dynamic>>>
                                                    snapshot) {
                                              if (snapshot.hasError) {
                                                return IconButton(
                                                    onPressed: () {},
                                                    icon: SvgPicture.asset(
                                                      'assets/svg/like.svg',
                                                      width: 5.w,
                                                      height: 5.w,
                                                      color: Colors.blueAccent,
                                                    ));
                                              } else if (snapshot.hasData) {
                                                Map<String, dynamic> like =
                                                    snapshot.data.data();
                                                List like_Data =
                                                    like['Like'] != null
                                                        ? like['Like']
                                                        : [];
                                                if (like_Data.contains(uid)) {
                                                  return Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      GestureDetector(
                                                          onTap: () {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'chat')
                                                                .doc(widget
                                                                    .RoomID)
                                                                .collection(
                                                                    'message')
                                                                .doc(widget
                                                                    .messageId)
                                                                .update({
                                                              "Like": FieldValue
                                                                  .arrayRemove(
                                                                      [uid])
                                                            });

                                                            setState(() {});
                                                          },
                                                          child:
                                                              SvgPicture.asset(
                                                            'assets/svg/is_like.svg',
                                                            width: 5.w,
                                                            height: 5.w,
                                                            color: Colors
                                                                .blueAccent,
                                                          )),
                                                      SizedBox(
                                                        width: 2.w,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 2.sp),
                                                        child: like['Like'] !=
                                                                null
                                                            ? Text(
                                                                like_Data.length
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                              )
                                                            : Text(
                                                                '0'.toString(),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                              ),
                                                      ),
                                                    ],
                                                  );
                                                } else {
                                                  return Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      GestureDetector(
                                                          onTap: () {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'chat')
                                                                .doc(widget
                                                                    .RoomID)
                                                                .collection(
                                                                    'message')
                                                                .doc(widget
                                                                    .messageId)
                                                                .update({
                                                              "Like": FieldValue
                                                                  .arrayUnion(
                                                                      [uid])
                                                            });
                                                            setState(() {});
                                                          },
                                                          child:
                                                              SvgPicture.asset(
                                                            'assets/svg/like.svg',
                                                            width: 5.w,
                                                            height: 5.w,
                                                            color: Colors
                                                                .blueAccent,
                                                          )),
                                                      SizedBox(
                                                        width: 2.w,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 2.sp),
                                                        child: like['Like'] !=
                                                                null
                                                            ? Text(
                                                                like_Data.length
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                              )
                                                            : Text(
                                                                '0'.toString(),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                              ),
                                                      ),
                                                    ],
                                                  );
                                                }
                                              } else {
                                                return Container();
                                              }
                                            }),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pushNamed(
                                                    '/comment',
                                                    arguments: {
                                                      "message_id":
                                                          widget.messageId,
                                                      "Room_Id": widget.RoomID
                                                    });
                                              },
                                              child: SvgPicture.asset(
                                                'assets/svg/comment.svg',
                                                width: 5.w,
                                                height: 5.w,
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                            StreamBuilder<QuerySnapshot>(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('chat')
                                                    .doc(widget.RoomID)
                                                    .collection('message')
                                                    .doc(widget.messageId)
                                                    .collection('comment')
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    return Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 2.sp,
                                                          right: 10.sp),
                                                      child: Text(
                                                        snapshot
                                                            .data.docs.length
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                    );
                                                  }
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 2.sp,
                                                        right: 10.sp),
                                                    child: const Text(
                                                      '0',
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                  );
                                                })
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                        bottom: 10.sp,
                        right: 5.sp,
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 5.sp,
                          ),
                          child: Text(
                            widget.message_time,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 8.sp,
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<bool> islikebutton(bool isLiked) async {
    if (isLiked == false) {
      FirebaseFirestore.instance
          .collection('chat')
          .doc(widget.RoomID)
          .collection('message')
          .doc(widget.messageId)
          .update({
        "Like": FieldValue.arrayUnion([uid])
      });
      print("Add");
      return isLiked != true;
    } else {
      print("remove");
      FirebaseFirestore.instance
          .collection('chat')
          .doc(widget.RoomID)
          .collection('message')
          .doc(widget.messageId)
          .update({
        "Like": FieldValue.arrayRemove([uid])
      });
      return isLiked == false;
    }
  }
}
