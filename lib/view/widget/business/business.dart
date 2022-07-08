import 'package:chatting/Helper/color.dart';
import 'package:chatting/Helper/time.dart';
import 'package:chatting/view/widget/business/receiver.dart';
import 'package:chatting/view/widget/business/sender.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class business_chat extends StatefulWidget {
  business_chat({
    Key key,
    @required this.isDarkMode,
    @required this.myUID,
    this.snapshot,
    this.Room_Id,
  }) : super(key: key);

  final bool isDarkMode;
  final String myUID;
  final AsyncSnapshot snapshot;
  final String Room_Id;

  @override
  State<business_chat> createState() => _business_chatState();
}

class _business_chatState extends State<business_chat> {
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      child: ListView.builder(
          shrinkWrap: true,
          reverse: true,
          itemCount: widget.snapshot.data.docs.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            Map<String, dynamic> Room_Data =
                widget.snapshot.data.docs[index].data();
            String message = widget.snapshot.data.docs[index].id;
            if (index + 1 == widget.snapshot.data.docs.length) {
              return Container(
                height: 40.w,
                width: 100.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 2.w),
                      child:
                          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                              stream: FirebaseFirestore.instance
                                  .collection('chat')
                                  .doc(widget.Room_Id)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  Map<String, dynamic> data =
                                      snapshot.data.data();
                                  return Text(
                                    Time_Chat.readTimestamp(
                                        data['business_date_and_time']),
                                    style: TextStyle(
                                        fontSize: 15.sp, color: Colors.grey),
                                  );
                                } else {
                                  return Container();
                                }
                              }),
                    ),
                    SizedBox(
                      height: 2.w,
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Container(
                          alignment: Alignment.center,
                          height: 15.w,
                          width: 100.w,
                          decoration: BoxDecoration(
                            color: widget.isDarkMode
                                ? HexColor.fromHex("#1a1a1c")
                                : HexColor.fromHex('#F2F5F7'),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: FutureBuilder<
                                      DocumentSnapshot<Map<String, dynamic>>>(
                                  future: FirebaseFirestore.instance
                                      .collection('chat')
                                      .doc(widget.Room_Id)
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      Map<String, dynamic> data =
                                          snapshot.data.data();
                                      return Text(
                                        'You created a hangout spot ${data["Business_Name"]}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          color:
                                              Theme.of(context).iconTheme.color,
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  })),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 80, vertical: 10),
                        child: Container(
                          alignment: Alignment.center,
                          height: 12.w,
                          decoration: BoxDecoration(
                            color: widget.isDarkMode
                                ? HexColor.fromHex("#1a1a1c")
                                : HexColor.fromHex('#F2F5F7'),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: RichText(
                                text: TextSpan(children: [
                                  WidgetSpan(
                                    child: SvgPicture.asset(
                                        'assets/svg/secure.svg'),
                                  ),
                                  TextSpan(
                                    text:
                                        ' Messages sent to by participants in this conversation are end-to-end encrypted.',
                                    style: TextStyle(
                                      fontSize: 8.sp,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                  ),
                                ]),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            // Get Sender Information Get With
            return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('user')
                    .doc(Room_Data['sender'])
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                        userdata) {
                  if (userdata.hasData) {
                    Map<String, dynamic> userdoc = userdata.data.data();

                    String link_check = Room_Data['message'];
                    bool islink = link_check.contains('https://') ||
                        link_check.contains('http://') &&
                            (Room_Data['message_type'] == 'text');

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Room_Data['sender'] == widget.myUID
                          ? sender(
                              message_time: Room_Data["time"],
                              Room_Data: Room_Data,
                              islink: islink,
                              myUID: widget.myUID,
                              RoomID: widget.Room_Id,
                              messageId: message,
                              isDarkMode: widget.isDarkMode)
                          : receiver(
                              message_time: Room_Data["time"],
                              userdoc: userdoc,
                              messageId: message,
                              RoomID: widget.Room_Id,
                              isDarkMode: widget.isDarkMode,
                              Room_Data: Room_Data,
                              islink: islink,
                              myUID: widget.myUID),
                    );
                  }
                  return Container();
                });
          }),
    );
  }
}










    // SliverAppBar(
    //       centerTitle: true,
    //       automaticallyImplyLeading: false,
    //       title: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
    //           stream: FirebaseFirestore.instance
    //               .collection('chat')
    //               .doc(widget.Room_Id)
    //               .snapshots(),
    //           builder: (context, snapshot) {
    //             if (snapshot.hasData) {
    //               Map<String, dynamic> data = snapshot.data.data();
    //               return Text(
    //                 Time_Chat.readTimestamp(data['business_date_and_time']),
    //                 style: TextStyle(fontSize: 12.sp, color: Colors.grey),
    //               );
    //             } else {
    //               return Container();
    //             }
    //           }),
    //       backgroundColor: Colors.transparent,
    //       bottom: PreferredSize(
    //         preferredSize: Size.fromHeight(32.w),
    //         child: Container(
    //           height: 32.w,
    //           child: Column(
    //             children: [
    //               Padding(
    //                 padding:
    //                     EdgeInsets.symmetric(vertical: 10.sp, horizontal: 20.w),
    //                 child: Container(
    //                   alignment: Alignment.center,
    //                   height: 8.w,
    //                   width: 100.w,
    //                   decoration: BoxDecoration(
    //                     color: widget.isDarkMode
    //                         ? HexColor.fromHex("#1a1a1c")
    //                         : HexColor.fromHex('#F2F5F7'),
    //                     borderRadius: BorderRadius.circular(10),
    //                   ),
    //                   child: Padding(
    //                       padding: const EdgeInsets.symmetric(
    //                         horizontal: 8,
    //                       ),
    //                       child: FutureBuilder<
    //                               DocumentSnapshot<Map<String, dynamic>>>(
    //                           future: FirebaseFirestore.instance
    //                               .collection('chat')
    //                               .doc(widget.Room_Id)
    //                               .get(),
    //                           builder: (context, snapshot) {
    //                             if (snapshot.hasData) {
    //                               Map<String, dynamic> data =
    //                                   snapshot.data.data();
    //                               return Text(
    //                                 'You created a hangout spot ${data["Business_Name"]}',
    //                                 textAlign: TextAlign.center,
    //                                 style: TextStyle(
    //                                   fontSize: 10.sp,
    //                                   color: Theme.of(context).iconTheme.color,
    //                                 ),
    //                               );
    //                             } else {
    //                               return Container();
    //                             }
    //                           })),
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.symmetric(
    //                     horizontal: 80, vertical: 10),
    //                 child: Container(
    //                   alignment: Alignment.center,
    //                   height: 12.w,
    //                   decoration: BoxDecoration(
    //                     color: widget.isDarkMode
    //                         ? HexColor.fromHex("#1a1a1c")
    //                         : HexColor.fromHex('#F2F5F7'),
    //                     borderRadius: BorderRadius.circular(10),
    //                   ),
    //                   child: Padding(
    //                       padding: const EdgeInsets.symmetric(
    //                         horizontal: 10,
    //                       ),
    //                       child: RichText(
    //                         text: TextSpan(children: [
    //                           WidgetSpan(
    //                             child:
    //                                 SvgPicture.asset('assets/svg/secure.svg'),
    //                           ),
    //                           TextSpan(
    //                             text:
    //                                 ' Messages sent to by participants in this conversation are end-to-end encrypted.',
    //                             style: TextStyle(
    //                               fontSize: 8.sp,
    //                               color: Theme.of(context).iconTheme.color,
    //                             ),
    //                           ),
    //                         ]),
    //                       )),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),