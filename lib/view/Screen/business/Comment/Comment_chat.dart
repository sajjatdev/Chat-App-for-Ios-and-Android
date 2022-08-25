import 'package:any_link_preview/any_link_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting/Helper/color.dart';
import 'package:chatting/view/Screen/business/Comment/model/comment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:voice_message_package/voice_message_package.dart';

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

class _Comment_chatState extends State<Comment_chat> {
  String id;
  String room;

  @override
  void initState() {
    super.initState();
    Comment_date();
  }

  void Comment_date() {
    id = widget.CommentData['message_id'];
    room = widget.CommentData['Room_Id'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: .5,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        title: Text(
          "Response",
          style: TextStyle(color: Theme.of(context).iconTheme.color),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 2.5.w),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 100.w,
                  minHeight: 20.w,
                ),
                child: Card(
                  child: FutureBuilder<Comment_model>(
                      future: CommentDataFunction(id: id, room_ID: room),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data.messageType == "text") {
                            if (snapshot.data.message.contains('https://') ||
                                snapshot.data.message.contains('http://')) {
                              return AnyLinkPreview(
                                link: snapshot.data.message,
                                displayDirection:
                                    UIDirection.uiDirectionVertical,
                                showMultimedia: true,
                                bodyMaxLines: 5,
                                bodyTextOverflow: TextOverflow.ellipsis,
                                titleStyle: TextStyle(
                                  color: Theme.of(context).iconTheme.color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                ),
                                bodyStyle: TextStyle(
                                    color: Theme.of(context).iconTheme.color,
                                    fontSize: 8.sp),
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
                                  style: TextStyle(fontSize: 15.sp),
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
                              contactFgColor: HexColor.fromHex("#2D7CFE"),
                              contactPlayIconColor:
                                  Theme.of(context).secondaryHeaderColor,
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
            ),
          ),
        ],
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
}
