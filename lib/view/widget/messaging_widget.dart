import 'dart:math';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting/Helper/color.dart';
import 'package:chatting/Helper/time.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'business/widget/voice_message.dart';

class messageing_widget extends StatelessWidget {
  const messageing_widget({
    Key key,
    @required this.data,
    @required this.myUID,
    @required this.image,
    @required this.profile_data,
    @required this.RoomID,
  }) : super(key: key);

  final DocumentSnapshot data;
  final Map<String, dynamic> profile_data;
  final String myUID;
  final String image;
  final String RoomID;

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    bool ismessage = data['message'] == '';
    String link_check = data['message'];

    bool islink = link_check.contains('https://') ||
        link_check.contains('http://') && data['message_type'] == 'text';
    String Imagecheck = profile_data["imageUrl"];
    return Padding(
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: data['sender'] == myUID
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: data['sender'] == myUID ? 10.sp : 5.sp,
            ),
            child: Stack(
              children: [
                Positioned(
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 30.sp, top: 10.sp, bottom: 10.sp),
                    child: Column(
                      children: [
                        Container(
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: data['message_type'] == 'image'
                                          ? Colors.transparent
                                          : isDarkMode
                                              ? data['sender'] == myUID
                                                  ? Colors.blue
                                                  : HexColor.fromHex("#1a1a1c")
                                              : data['sender'] == myUID
                                                  ? Colors.blue
                                                  : HexColor.fromHex('#F2F5F7'),
                                    ),
                                    child: Padding(
                                      padding: data['message_type'] == 'image'
                                          ? EdgeInsets.all(0.0.sp)
                                          : EdgeInsets.all(10.0.sp),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  if (data['message_type'] ==
                                                      'voice') ...[
                                                    voice_message(
                                                      Room_Data: {
                                                        "message":
                                                            data['message']
                                                      },
                                                      myUID: myUID,
                                                      isDarkMode: isDarkMode,
                                                      isreceiver:
                                                          data['sender'] ==
                                                                  myUID
                                                              ? false
                                                              : true,
                                                    )
                                                  ] else if (islink &&
                                                      data['message_type'] ==
                                                          'text') ...[
                                                    Container(
                                                      constraints:
                                                          BoxConstraints(
                                                              minHeight: 5.w,
                                                              maxWidth: 70.w,
                                                              minWidth: 20.w),
                                                      child: Padding(
                                                        padding: data[
                                                                    'sender'] !=
                                                                myUID
                                                            ? const EdgeInsets
                                                                    .only(
                                                                top: 15,
                                                                bottom: 5,
                                                                left: 0,
                                                                right: 0)
                                                            : const EdgeInsets
                                                                .all(0.0),
                                                        child: AnyLinkPreview(
                                                          link: data['message'],
                                                          displayDirection:
                                                              uiDirection
                                                                  .uiDirectionVertical,
                                                          showMultimedia: true,
                                                          bodyMaxLines: 7,
                                                          bodyTextOverflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                          titleStyle: TextStyle(
                                                            color: data['sender'] ==
                                                                    myUID
                                                                ? Colors.white
                                                                : Theme.of(
                                                                        context)
                                                                    .iconTheme
                                                                    .color,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15,
                                                          ),
                                                          bodyStyle: TextStyle(
                                                              color: data['sender'] ==
                                                                      myUID
                                                                  ? Colors.white
                                                                  : Theme.of(
                                                                          context)
                                                                      .iconTheme
                                                                      .color,
                                                              fontSize: 12),
                                                          errorBody:
                                                              'Show my custom error body',
                                                          errorTitle:
                                                              'Show my custom error title',
                                                          errorWidget:
                                                              Container(
                                                            color: data['sender'] ==
                                                                    myUID
                                                                ? HexColor
                                                                    .fromHex(
                                                                        "#1ea1f1")
                                                                : isDarkMode
                                                                    ? HexColor
                                                                        .fromHex(
                                                                            "#1a1a1c")
                                                                    : HexColor
                                                                        .fromHex(
                                                                            "#f2f5f6"),
                                                            child: const Text(
                                                                'Oops!'),
                                                          ),
                                                          errorImage:
                                                              data['message'],
                                                          cache: const Duration(
                                                              days: 7),
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,

                                                          removeElevation: true,
                                                          onTap: () async {
                                                            if (!await launch(
                                                                data[
                                                                    'message']))
                                                              throw 'Could not launch ${data['message']}';
                                                          }, // This disables tap event
                                                        ),
                                                      ),
                                                    )
                                                  ] else if (data[
                                                          'message_type'] ==
                                                      'image') ...[
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.sp),
                                                      child: CachedNetworkImage(
                                                        width: 50.w,
                                                        height: 50.w,
                                                        fit: BoxFit.cover,
                                                        imageUrl:
                                                            data['message'],
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons.error),
                                                      ),
                                                    ),
                                                  ] else ...[
                                                    Container(
                                                      constraints:
                                                          BoxConstraints(
                                                              minHeight: 5.w,
                                                              maxWidth: 70.w,
                                                              minWidth: 20.w),
                                                      child: Padding(
                                                        padding: data[
                                                                    'sender'] !=
                                                                myUID
                                                            ? const EdgeInsets
                                                                    .only(
                                                                top: 15,
                                                                bottom: 5,
                                                                left: 0,
                                                                right: 0)
                                                            : EdgeInsets.only(
                                                                bottom: 8.sp),
                                                        child: Text(
                                                          data["message"]
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: data['sender'] ==
                                                                      myUID
                                                                  ? Colors.white
                                                                  : Theme.of(
                                                                          context)
                                                                      .iconTheme
                                                                      .color,
                                                              fontSize: 12.sp),
                                                        ),
                                                      ),
                                                    )
                                                  ],
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
                              data['sender'] != myUID
                                  ? Positioned(
                                      left: 10.sp,
                                      top: data['message_type'] == 'image'
                                          ? 0.sp
                                          : 5.sp,
                                      child: Text(
                                        profile_data['first_name'],
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.primaries[Random()
                                                .nextInt(
                                                    Colors.primaries.length)]),
                                      ),
                                    )
                                  : Container(),
                              Positioned(
                                  bottom: 5.sp,
                                  right: 5.sp,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      top: 5.sp,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          Time_Chat.readTimestamp(data['time']),
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            color:
                                                data['message_type'] == 'image'
                                                    ? data['sender'] != myUID
                                                        ? Colors.black
                                                        : Colors.white
                                                    : data['sender'] != myUID
                                                        ? Colors.black
                                                        : Colors.white,
                                            fontSize: 10.sp,
                                          ),
                                        ),
                                        if (data['sender'] == myUID) ...[
                                          SizedBox(
                                            width: 5.sp,
                                          ),
                                          SvgPicture.asset(
                                            data['read']
                                                ? "assets/svg/see.svg"
                                                : "assets/svg/unsee.svg",
                                            width: 15.sp,
                                          )
                                        ]
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      data['sender'] != myUID
                          ? Imagecheck.contains("https://")
                              ? CircleAvatar(
                                  radius: 12.sp,
                                  backgroundImage:
                                      NetworkImage(profile_data["imageUrl"]),
                                )
                              : ProfilePicture(
                                  name: Imagecheck.trim(),
                                  radius: 12.sp,
                                  fontsize: 12.sp)
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
