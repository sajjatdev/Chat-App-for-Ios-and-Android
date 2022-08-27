import 'package:any_link_preview/any_link_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_composer/chat_composer.dart';
import 'package:chatting/Helper/color.dart';
import 'package:chatting/logic/Business_profile/business_profile_cubit.dart';
import 'package:chatting/logic/photo_upload/photoupload_cubit.dart';
import 'package:chatting/logic/send_message/send_message_cubit.dart';
import 'package:chatting/view/Screen/business/Comment/model/comment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
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

class _Comment_chatState extends State<Comment_chat> {
  TextEditingController comment = TextEditingController();
  String id;
  String room;
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    Comment_date();
  }

  @override
  void dispose() {
    comment.dispose();
    super.dispose();
  }

  void Comment_date() {
    id = widget.CommentData['message_id'];
    room = widget.CommentData['Room_Id'];
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
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
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Message_Header(isDarkMode),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return ListTile(
                      title: Text("Message"),
                    );
                  }, childCount: 20),
                )
              ],
            ),
          ),
          // Message Box Start
          MessageBox(context)
        ],
      ),
    );
  }

  Padding Message_Header(bool isDarkMode) {
    return Padding(
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
                        displayDirection: UIDirection.uiDirectionVertical,
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
                      me: false,
                      played: true,
                      contactBgColor: !isDarkMode
                          ? Colors.white
                          : HexColor.fromHex("#3b4043"),
                      contactFgColor: Theme.of(context).iconTheme.color,
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
          Builder(builder: (context) {
            final customer = context.watch<BusinessProfileCubit>().state;
            if (customer is HasData_Business_Profile) {
              return CupertinoButton(
                padding: EdgeInsets.zero,
                child: SvgPicture.asset("assets/svg/add_message.svg"),
                onPressed: () async {
                  // final result = await FilePicke.platform.pickFiles(
                  //     allowMultiple: false,
                  //     type: FileType.image,
                  //     allowedExtensions: ['png', 'jpg', 'gif']);
                  final XFile result =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (result != null) {
                    final path = result.path;
                    final name = result.name;
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
                          setState(() {});
                        }
                      },
                    );
                  }
                },
              );
            } else {
              return Container();
            }
          }),

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
              child: Builder(builder: (context) {
                final customer = context.watch<BusinessProfileCubit>().state;
                if (customer is HasData_Business_Profile) {
                  return ChatComposer(
                    controller: comment,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    onReceiveText: (str) {
                      setState(() {});
                    },
                    onRecordEnd: (String path) {
                      String name = path.split('/').last;

                      context
                          .read<PhotouploadCubit>()
                          .updateData(path, name, name)
                          .then((value) async {
                        String voiceurl = await firebase_storage
                            .FirebaseStorage.instance
                            .ref('userimage/${name}/${name}')
                            .getDownloadURL();

                        if (voiceurl != null) {
                          setState(() {});
                        }
                      });
                    },
                    recordIconColor: Theme.of(context).iconTheme.color,
                    sendButtonColor: Theme.of(context).iconTheme.color,
                    backgroundColor: Colors.transparent,
                    sendButtonBackgroundColor: Colors.transparent,
                  );
                } else {
                  return Container();
                }
              }),
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
}
