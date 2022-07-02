import 'dart:math';

import 'package:chatting/main.dart';
import 'package:chatting/view/widget/business/widget/voice_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:strings/strings.dart';

import '../../../Helper/color.dart';
import '../../widget/business/widget/imageView.dart';
import '../../widget/business/widget/linkview.dart';

class comment_page extends StatefulWidget {
  static const String routeName = '/comment';

  final Map<String, dynamic> Comment_Info;

  const comment_page({Key key, this.Comment_Info}) : super(key: key);

  static Route route({Map<String, dynamic> messageId}) {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => comment_page(
              Comment_Info: messageId,
            ));
  }

  @override
  _commentState createState() => _commentState();
}

class _commentState extends State<comment_page> {
  TextEditingController comment = TextEditingController();
  String uid;
  String Room_ID;
  String Message_ID;

  @override
  void initState() {
    // TODO: implement initState
    uid = sharedPreferences.getString('uid');
    Room_ID = widget.Comment_Info['Room_Id'];
    Message_ID = widget.Comment_Info['message_id'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Response",
          style: TextStyle(color: Theme.of(context).iconTheme.color),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection('chat')
                  .doc(Room_ID)
                  .collection('message')
                  .doc(Message_ID)
                  .get(),
              builder: (context,
                  AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                      snapshot) {
                if (snapshot.hasData) {
                  Map<String, dynamic> comment_data =
                      snapshot.data.data() as Map<String, dynamic>;

                  return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      future: FirebaseFirestore.instance
                          .collection('user')
                          .doc(comment_data['sender'])
                          .get(),
                      builder: (context,
                          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.hasError) {
                          return Row(
                            children: [
                              CircleAvatar(),
                              SizedBox(
                                width: 3.w,
                              ),
                              Text(
                                "Not Found",
                                style: TextStyle(fontSize: 12.sp),
                              )
                            ],
                          );
                        }
                        if (snapshot.hasData) {
                          Map<String, dynamic> userinfo = snapshot.data.data();
                          String urls = userinfo['imageUrl'];
                          return Row(
                            children: [
                              if (urls.contains("https://")) ...[
                                IconButton(
                                    onPressed: () {},
                                    icon: CircleAvatar(
                                      backgroundImage: NetworkImage(urls),
                                    )),
                              ] else ...[
                                ProfilePicture(name: urls, fontsize: 12.sp)
                              ],
                            ],
                          );
                        } else {
                          return Row(
                            children: const [
                              CircleAvatar(),
                            ],
                          );
                        }
                      });
                } else {
                  return Container();
                }
              }),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('chat')
              .doc(Room_ID)
              .collection('message')
              .doc(Message_ID)
              .get(),
          builder: (context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> comment_data =
                  snapshot.data.data() as Map<String, dynamic>;

              String link_check = comment_data['message'];
              bool islink = link_check.contains('https://') ||
                  link_check.contains('http://') &&
                      (comment_data['message_type'] == 'text');

              return Container(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    // Start Comment Section
                    Column(
                      children: [
                        if (comment_data['message_type'] == 'voice') ...[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.sp, vertical: 5.sp),
                            child: Card(
                              child: voice_message(
                                Room_Data: comment_data,
                                myUID: uid,
                                isDarkMode: isDarkMode,
                                isreceiver: true,
                              ),
                            ),
                          ),
                        ] else if (comment_data['message_type'] == 'image') ...[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.sp, vertical: 5.sp),
                            child: Card(
                              child: Image_view(
                                Room_Data: comment_data,
                              ),
                            ),
                          )
                        ] else if (islink == true &&
                            comment_data['message_type'] == 'text' &&
                            comment_data['message_type'] != 'voice') ...[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.sp, vertical: 5.sp),
                            child: Card(
                              child: link_view(
                                Room_Data: comment_data,
                                myUID: uid,
                                iscomment: true,
                                isDarkMode: isDarkMode,
                              ),
                            ),
                          )
                        ] else if (comment_data['message_type'] != 'image' &&
                            islink == false &&
                            comment_data['message_type'] != 'voice') ...[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.sp, vertical: 5.sp),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  comment_data['message'],
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Theme.of(context).iconTheme.color),
                                ),
                              ),
                            ),
                          )
                        ]
                      ],
                    ),
                    if (comment_data['comment'] != null) ...[
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.sp, vertical: 10.sp),
                        child: StreamBuilder<
                                QuerySnapshot<Map<String, dynamic>>>(
                            stream: FirebaseFirestore.instance
                                .collection('chat')
                                .doc(Room_ID)
                                .collection('message')
                                .doc(Message_ID)
                                .collection('comment')
                                .orderBy('comment', descending: true)
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<
                                        QuerySnapshot<Map<String, dynamic>>>
                                    snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder: (context, index) {
                                      Map<String, dynamic> comment_info =
                                          snapshot.data.docs[index].data();

                                      DateTime dateTime =
                                          comment_info['comment_Time'].toDate();
                                      var dateValue =
                                          DateFormat("yyyy-MM-dd HH:mm:ss")
                                              .parse(dateTime.toString())
                                              .toLocal();
                                      String message_time =
                                          DateFormat("hh:mm a")
                                              .format(dateValue);
                                      return comment_info['comment_Id'] == uid
                                          ? Align(
                                              alignment: Alignment.topRight,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5,
                                                    vertical: 10.sp),
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      constraints:
                                                          BoxConstraints(
                                                              minHeight: 15.w,
                                                              maxWidth: 70.w,
                                                              minWidth: 40.w),
                                                      decoration: BoxDecoration(
                                                          color: Colors.blue,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 20,
                                                                vertical: 30),
                                                        child: Text(
                                                          comment_info[
                                                              'comment'],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15.sp),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      bottom: 5.sp,
                                                      right: 5.sp,
                                                      child: Text(
                                                        message_time,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    Positioned(
                                                        left: 3.5.w,
                                                        top: 2.w,
                                                        child: Text(
                                                          capitalize("you"),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Align(
                                              alignment: Alignment.topLeft,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5,
                                                    vertical: 10.sp),
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      constraints:
                                                          BoxConstraints(
                                                              minHeight: 15.w,
                                                              maxWidth: 70.w,
                                                              minWidth: 40.w),
                                                      decoration: BoxDecoration(
                                                          color: Colors.white70,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 15,
                                                                vertical: 25),
                                                        child: Text(
                                                          comment_info[
                                                              'comment'],
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .iconTheme
                                                                  .color,
                                                              fontSize: 12.sp),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      left: 3.5.w,
                                                      top: 2.w,
                                                      child: FutureBuilder<
                                                              DocumentSnapshot<
                                                                  Map<String,
                                                                      dynamic>>>(
                                                          future: FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'user')
                                                              .doc(comment_info[
                                                                  'comment_Id'])
                                                              .get(),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                .hasData) {
                                                              Map<String,
                                                                      dynamic>
                                                                  comment_user =
                                                                  snapshot.data
                                                                      .data();
                                                              return Text(
                                                                capitalize(
                                                                    comment_user[
                                                                        'first_name']),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .primaries[
                                                                        Random().nextInt(Colors
                                                                            .primaries
                                                                            .length)]),
                                                              );
                                                            }
                                                            return CupertinoActivityIndicator(
                                                              color: Theme.of(
                                                                      context)
                                                                  .iconTheme
                                                                  .color,
                                                            );
                                                          }),
                                                    ),
                                                    Positioned(
                                                        bottom: 5.sp,
                                                        right: 5.sp,
                                                        child: Text(
                                                          message_time,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .green
                                                                  .shade400),
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            );
                                    });
                              } else {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 20),
                                  child: Text("No Found any Comment"),
                                );
                              }
                            }),
                      )),
                    ] else ...[
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          child: Text("No Found any Comment"),
                        ),
                      ),
                    ],

                    TextFormField(
                      cursorColor: Theme.of(context).iconTheme.color,
                      controller: comment,
                      keyboardType: TextInputType.text,
                      autocorrect: true,
                      textInputAction: TextInputAction.send,
                      onFieldSubmitted: (String value) {
                        FirebaseFirestore.instance
                            .collection('chat')
                            .doc(Room_ID)
                            .collection("message")
                            .doc(Message_ID)
                            .collection('comment')
                            .add({
                          'comment_Id': uid,
                          'comment': value,
                          'comment_Time': DateTime.now(),
                        }).then((value) {
                          setState(() {
                            comment.clear();
                            FirebaseFirestore.instance
                                .collection('chat')
                                .doc(Room_ID)
                                .collection('message')
                                .doc(Message_ID)
                                .update({'comment': value});
                          });
                        });
                      },
                      validator: (value) =>
                          value.isEmpty ? "Enter your Value" : null,
                      style: TextStyle(
                          color: Theme.of(context).iconTheme.color,
                          fontSize: 12.sp),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('chat')
                                  .doc(Room_ID)
                                  .collection("message")
                                  .doc(Message_ID)
                                  .collection('comment')
                                  .add({
                                'comment_Id': uid,
                                'comment': comment.text,
                                'comment_Time': DateTime.now(),
                              }).then((value) {
                                setState(() {
                                  FirebaseFirestore.instance
                                      .collection('chat')
                                      .doc(Room_ID)
                                      .collection('message')
                                      .doc(Message_ID)
                                      .update({'comment': comment.text});
                                  comment.clear();
                                });
                              });
                            },
                            icon: Icon(
                              Icons.send,
                              color: Theme.of(context).iconTheme.color,
                            )),
                        hintText: "Write a comment...",
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        hintStyle: TextStyle(
                            color: Theme.of(context).iconTheme.color,
                            fontSize: 12.sp),
                        fillColor: isDarkMode
                            ? HexColor.fromHex("#696969")
                            : HexColor.fromHex("#EEEEEF"),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide.none,
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide.none),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide.none),
                      ),
                    ),

                    // End Comment Section
                  ],
                ),
              );
            } else {
              return Center(
                child: CupertinoActivityIndicator(
                  color: Theme.of(context).iconTheme.color,
                ),
              );
            }
          }),
    );
  }
}
