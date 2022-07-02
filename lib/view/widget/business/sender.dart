import 'dart:ffi';

import 'package:chatting/Helper/color.dart';
import 'package:chatting/Helper/time.dart';
import 'package:chatting/main.dart';
import 'package:chatting/view/widget/business/widget/imageView.dart';
import 'package:chatting/view/widget/business/widget/linkview.dart';
import 'package:chatting/view/widget/business/widget/voice_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:voice_message_package/voice_message_package.dart';

class sender extends StatefulWidget {
  const sender({
    Key key,
    @required this.Room_Data,
    @required this.islink,
    @required this.myUID,
    @required this.isDarkMode,
    @required this.message_time,
    this.messageId,
    this.RoomID,
  }) : super(key: key);

  final Map<String, dynamic> Room_Data;
  final bool islink;
  final String myUID;
  final String messageId;
  final String RoomID;
  final int message_time;
  final bool isDarkMode;

  @override
  State<sender> createState() => _senderState();
}

class _senderState extends State<sender> {
  List like_count;
  String uid;
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
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(right: 5.sp),
        child: Stack(
          children: [
            Container(
              color: Colors.transparent,
              constraints: BoxConstraints(
                  maxWidth: 70.w, minWidth: 45.w, minHeight: 25.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    constraints: BoxConstraints(
                        minHeight: 15.w, maxWidth: 70.w, minWidth: 45.w),

                    decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15))),
                    child: Padding(
                      padding: EdgeInsets.only(top: 5.sp, bottom: 25.sp),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (widget.Room_Data['message_type'] != 'image' &&
                              widget.islink == false &&
                              widget.Room_Data['message_type'] != 'voice') ...[
                            // Text View Start
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.Room_Data['message'],
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15.sp),
                              ),
                            ),
                            // Text View End
                          ] else if (widget.islink == true &&
                              widget.Room_Data['message_type'] == 'text' &&
                              widget.Room_Data['message_type'] != 'voice') ...[
                            // Link View start

                            link_view(
                              Room_Data: widget.Room_Data,
                              myUID: widget.myUID,
                              isDarkMode: widget.isDarkMode,
                            )

                            // Link View End
                          ] else if (widget.Room_Data['message_type'] ==
                              'voice') ...[
                            // voice Message Start

                            voice_message(
                              Room_Data: widget.Room_Data,
                              myUID: widget.myUID,
                              isDarkMode: widget.isDarkMode,
                              isreceiver: false,
                            )

                            // VoiceMessage(
                            //   audioSrc:
                            //       "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
                            //   played: false, // To show played badge or not.
                            //   me: true, // Set message side.
                            //   onPlay: () {}, // Do something when voice played.
                            // )

                            // voice Message End
                          ] else ...[
                            // Image View Start

                            Image_view(
                              message_time: widget.message_time,
                              Room_Data: widget.Room_Data,
                            )

                            // Image View End
                          ],
                        ],
                      ),
                    ),
                    // My Message Section End
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 15.sp,
              right: 5.sp,
              child: Row(
                children: [
                  Text(
                    Time_Chat.readTimestamp(widget.message_time),
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 11.sp, color: Colors.white),
                  ),
                  SizedBox(
                    width: 1.w,
                  ),
                  SvgPicture.asset(
                    "assets/svg/see.svg",
                    width: 6.w,
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 0.sp,
              left: 50.sp,
              child: Container(
                width: 8.w,
                height: 8.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: HexColor.fromHex("#C9DDFE"),
                    borderRadius: BorderRadius.circular(20.sp)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/comment', arguments: {
                          "message_id": widget.messageId,
                          "Room_Id": widget.RoomID
                        });
                      },
                      child: SvgPicture.asset(
                        'assets/svg/commentcht.svg',
                        width: 6.w,
                        height: 6.w,
                      ),
                    ),
                    // StreamBuilder<QuerySnapshot>(
                    //     stream: FirebaseFirestore.instance
                    //         .collection('chat')
                    //         .doc(widget.RoomID)
                    //         .collection('message')
                    //         .doc(widget.messageId)
                    //         .collection('comment')
                    //         .snapshots(),
                    //     builder: (context, snapshot) {
                    //       if (snapshot.hasData) {
                    //         return Padding(
                    //           padding:
                    //               EdgeInsets.only(left: 2.sp, right: 10.sp),
                    //           child: Text(
                    //             snapshot.data.docs.length.toString(),
                    //             style: TextStyle(color: Colors.white),
                    //           ),
                    //         );
                    //       }
                    //       return Padding(
                    //         padding: EdgeInsets.only(left: 2.sp, right: 10.sp),
                    //         child: Text(
                    //           '0',
                    //           style: TextStyle(color: Colors.white),
                    //         ),
                    //       );
                    //     })
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 7.sp,
              child: Container(
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('chat')
                        .doc(widget.RoomID)
                        .collection('message')
                        .doc(widget.messageId)
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.hasError) {
                        return IconButton(
                            onPressed: () {},
                            icon: SvgPicture.asset(
                              'assets/svg/like.svg',
                              width: 5.w,
                              height: 5.w,
                              color: Colors.white,
                            ));
                      } else if (snapshot.hasData) {
                        Map<String, dynamic> like = snapshot.data.data();
                        List like_Data =
                            like['Like'] != null ? like['Like'] : [];
                        if (like_Data.contains(uid)) {
                          return Container(
                            width: 8.w,
                            height: 8.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: HexColor.fromHex("#C9DDFE"),
                                borderRadius: BorderRadius.circular(20.sp)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      FirebaseFirestore.instance
                                          .collection('chat')
                                          .doc(widget.RoomID)
                                          .collection('message')
                                          .doc(widget.messageId)
                                          .update({
                                        "Like": FieldValue.arrayRemove([uid])
                                      });

                                      setState(() {});
                                    },
                                    child: SvgPicture.asset(
                                      'assets/svg/likechat.svg',
                                      width: 6.w,
                                      height: 6.w,
                                    )),
                                // SizedBox(
                                //   width: 2.w,
                                // ),
                                // Padding(
                                //   padding: EdgeInsets.only(top: 2.sp),
                                //   child: like['Like'] != null
                                //       ? Text(
                                //           like_Data.length.toString(),
                                //           style: const TextStyle(
                                //               color: Colors.white),
                                //         )
                                //       : Text(
                                //           '0'.toString(),
                                //           style: const TextStyle(
                                //               color: Colors.white),
                                //         ),
                                // ),
                              ],
                            ),
                          );
                        } else {
                          return Container(
                            width: 8.w,
                            height: 8.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: HexColor.fromHex("#C9DDFE"),
                                borderRadius: BorderRadius.circular(20.sp)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      FirebaseFirestore.instance
                                          .collection('chat')
                                          .doc(widget.RoomID)
                                          .collection('message')
                                          .doc(widget.messageId)
                                          .update({
                                        "Like": FieldValue.arrayUnion([uid])
                                      });
                                      setState(() {});
                                    },
                                    child: SvgPicture.asset(
                                      'assets/svg/likechat.svg',
                                      width: 6.w,
                                      height: 6.w,
                                      color: Colors.grey,
                                    )),
                                // SizedBox(
                                //   width: 2.w,
                                // ),
                                // Padding(
                                //   padding: EdgeInsets.only(top: 2.sp),
                                //   child: like['Like'] != null
                                //       ? Text(
                                //           like_Data.length.toString(),
                                //           style: const TextStyle(
                                //               color: Colors.white),
                                //         )
                                //       : Text(
                                //           '0'.toString(),
                                //           style: const TextStyle(
                                //               color: Colors.white),
                                //         ),
                                // ),
                              ],
                            ),
                          );
                        }
                      } else {
                        return Container();
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
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
