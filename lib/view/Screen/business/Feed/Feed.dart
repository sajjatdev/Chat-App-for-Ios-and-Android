import 'dart:io';

import 'package:chatting/Helper/color.dart';
import 'package:chatting/logic/Business_profile/business_profile_cubit.dart';
import 'package:chatting/logic/photo_upload/photoupload_cubit.dart';
import 'package:chatting/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class Feed extends StatefulWidget {
  static const String routeName = '/feed';

  static Route route({String RoomId}) {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => Feed(
              RoomId: RoomId,
            ));
  }

  const Feed({Key key, this.RoomId}) : super(key: key);
  final String RoomId;
  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    context
        .read<BusinessProfileCubit>()
        .get_Business_Profile(room_id: widget.RoomId);
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => postpopup(
                      RoomID: widget.RoomId,
                    )));
          },
          child: Icon(Icons.post_add),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: BlocBuilder<BusinessProfileCubit, BusinessProfileState>(
          builder: (context, state) {
            if (state is HasData_Business_Profile) {
              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('chat')
                      .doc(widget.RoomId)
                      .collection("Promotional_Post")
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.hasData) {
                      return CustomScrollView(
                        slivers: [
                          SliverAppBar(
                            pinned: true,
                            snap: false,
                            floating: true,
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            centerTitle: true,
                            title: Text(
                              "Promotional Post",
                              style: TextStyle(
                                  color: Theme.of(context).iconTheme.color),
                            ),
                            iconTheme: IconThemeData(
                                color: Theme.of(context).iconTheme.color),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                Map<String, dynamic> postdata =
                                    snapshot.data.docs[index].data();
                                final post_id = snapshot.data.docs[index].id;
                                return Column(
                                  children: [
                                    StreamBuilder<
                                            DocumentSnapshot<
                                                Map<String, dynamic>>>(
                                        stream: FirebaseFirestore.instance
                                            .collection('user')
                                            .doc(postdata['author_ID'])
                                            .snapshots(),
                                        builder: (context,
                                            AsyncSnapshot<
                                                    DocumentSnapshot<
                                                        Map<String, dynamic>>>
                                                snapshot) {
                                          if (snapshot.hasData) {
                                            Map<String, dynamic> profiledata =
                                                snapshot.data.data();
                                            return ListTile(
                                              trailing: IconButton(
                                                onPressed: () {
                                                  showModalBottomSheet(
                                                      context: context,
                                                      builder: (context) {
                                                        return Wrap(
                                                          children: [
                                                            ListTile(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .push(
                                                                        MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          Edit_post(
                                                                    image: postdata[
                                                                        'Image'],
                                                                    room_id: widget
                                                                        .RoomId,
                                                                    post_id:
                                                                        post_id,
                                                                    title: postdata[
                                                                        'title'],
                                                                  ),
                                                                ));
                                                              },
                                                              leading: const Icon(
                                                                  Icons
                                                                      .edit_note),
                                                              title: const Text(
                                                                  'Edit Post'),
                                                            ),
                                                            ListTile(
                                                              leading: Icon(Icons
                                                                  .hide_image),
                                                              title: Text(
                                                                  'Hide Post'),
                                                            ),
                                                            ListTile(
                                                              leading: Icon(
                                                                  Icons.delete),
                                                              title: Text(
                                                                  'Delete Post'),
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                },
                                                icon: Icon(Icons.more_vert),
                                              ),
                                              leading: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    profiledata['imageUrl']),
                                              ),
                                              title: Text(
                                                  "${profiledata['first_name']} ${profiledata['last_name']}"),
                                              subtitle: Text("Developer"),
                                            );
                                          } else {
                                            return const ListTile(
                                              leading: CircleAvatar(),
                                              title: Text("...."),
                                              subtitle: Text("......"),
                                            );
                                          }
                                        }),
                                    postdata["title"] != null
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 15),
                                            child: Container(
                                              alignment: Alignment.topLeft,
                                              child: DetectableText(
                                                text: postdata["title"],
                                                detectionRegExp:
                                                    detectionRegExp(),
                                                detectedStyle: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                basicStyle: TextStyle(
                                                  fontSize: 10.sp,
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    postdata["Image"] != null
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.network(
                                                postdata["Image"],
                                                height: 60.w,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                );
                              },
                              childCount: snapshot.data.docs.length,
                            ),
                          )
                        ],
                      );
                    } else {
                      return Container();
                    }
                  });
            } else {
              return Container();
            }
          },
        ));
  }
}

// Edit Post Start
class Edit_post extends StatefulWidget {
  const Edit_post({Key key, this.room_id, this.post_id, this.title, this.image})
      : super(key: key);
  final String room_id;
  final String post_id;
  final String title;
  final String image;

  @override
  State<Edit_post> createState() => _Edit_postState();
}

class _Edit_postState extends State<Edit_post> {
  TextEditingController titles;
  String myuid;
  File imagepath;
  bool loading = false;
  bool typeing = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_group_data();
    if (widget.title != null) {
      titles = TextEditingController(text: widget.title);
    }
  }

  void get_group_data() {
    myuid = sharedPreferences.getString('uid');
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Edit Post"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: loading ? false : true,
        actions: [
          loading
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CupertinoActivityIndicator(),
                )
              : TextButton(
                  onPressed: titles != null || imagepath != null
                      ? () {
                          setState(() {
                            FocusScope.of(context).unfocus();
                            loading = true;
                          });
                          if (titles != null && imagepath != null) {
                            final path = imagepath.path;
                            final name = imagepath.path;
                            context
                                .read<PhotouploadCubit>()
                                .updateData(path, name, widget.room_id)
                                .then((value) async {
                              String imagurl = await firebase_storage
                                  .FirebaseStorage.instance
                                  .ref('userimage/${widget.room_id}/${name}')
                                  .getDownloadURL();
                              FirebaseFirestore.instance
                                  .collection('chat')
                                  .doc(widget.room_id)
                                  .collection("Promotional_Post")
                                  .doc(widget.post_id)
                                  .update({
                                "title": titles != null ? titles.text : null,
                                "Image": imagurl,
                                "Time": DateTime.now(),
                                "ID": widget.room_id,
                                "author_ID": myuid
                              });
                              Navigator.of(context).pop();
                            });
                          } else if (imagepath != null) {
                            final path = imagepath.path;
                            final name = imagepath.path;
                            context
                                .read<PhotouploadCubit>()
                                .updateData(path, name, widget.room_id)
                                .then((value) async {
                              String imagurl = await firebase_storage
                                  .FirebaseStorage.instance
                                  .ref('userimage/${widget.room_id}/${name}')
                                  .getDownloadURL();
                              FirebaseFirestore.instance
                                  .collection('chat')
                                  .doc(widget.room_id)
                                  .collection("Promotional_Post")
                                  .doc(widget.post_id)
                                  .update({
                                "Image": imagurl,
                                "Time": DateTime.now(),
                                "ID": widget.room_id,
                                "author_ID": myuid
                              });
                              Navigator.of(context).pop();
                            });
                          } else {
                            FirebaseFirestore.instance
                                .collection('chat')
                                .doc(widget.room_id)
                                .collection("Promotional_Post")
                                .doc(widget.post_id)
                                .update({
                              "title": titles != null ? titles.text : null,
                              "Time": DateTime.now(),
                              "ID": widget.room_id,
                              "author_ID": myuid
                            });
                            Navigator.of(context).pop();
                          }
                        }
                      : null,
                  style: TextButton.styleFrom(
                      primary: Theme.of(context).iconTheme.color),
                  child: Text(
                    'Post',
                    style: TextStyle(fontSize: 16.sp),
                  ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                DetectableTextField(
                  controller: titles,
                  readOnly: loading,
                  enabled: loading ? false : true,
                  maxLines: null,
                  cursorColor: Theme.of(context).iconTheme.color,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "typing....",
                      hintStyle: TextStyle(
                          color: Theme.of(context).iconTheme.color,
                          fontWeight: FontWeight.w300)),
                  detectionRegExp: detectionRegExp(),
                  decoratedStyle: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).iconTheme.color,
                      fontWeight: FontWeight.bold),
                  basicStyle: TextStyle(
                      fontSize: 20, color: Theme.of(context).iconTheme.color),
                ),
                SizedBox(
                  height: 10.w,
                ),
                widget.image != null
                    ? imagepath != null
                        ? Image.file(imagepath)
                        : Image.network(widget.image)
                    : Container(),
                SizedBox(
                  height: 5.w,
                ),
                GestureDetector(
                  onTap: loading
                      ? null
                      : () async {
                          FilePickerResult result = await FilePicker.platform
                              .pickFiles(
                                  allowMultiple: false, type: FileType.image);

                          if (result != null) {
                            setState(() {
                              imagepath = File(result.files.single.path);
                            });
                          }
                        },
                  child: Container(
                    height: 15.w,
                    width: 70.w,
                    decoration: BoxDecoration(
                        color: isDarkMode
                            ? HexColor.fromHex("#1a1a1c")
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.upload,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        Text(
                          "Edit Image",
                          style: TextStyle(
                              color: Theme.of(context).iconTheme.color),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}

// Post Create screen Start

class postpopup extends StatefulWidget {
  const postpopup({Key key, this.RoomID}) : super(key: key);
  final String RoomID;
  @override
  State<postpopup> createState() => _postpopupState();
}

class _postpopupState extends State<postpopup> {
  File imagepath;
  String post_message = '';
  bool isloading = false;
  String myuid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_group_data();
  }

  void get_group_data() {
    myuid = sharedPreferences.getString('uid');
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: isloading ? false : true,
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        title: Text(
          "New Post",
          style: TextStyle(color: Theme.of(context).iconTheme.color),
        ),
        centerTitle: true,
        actions: [
          isloading
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CupertinoActivityIndicator(),
                )
              : TextButton(
                  onPressed: post_message != '' || imagepath != null
                      ? () {
                          setState(() {
                            isloading = true;
                          });
                          if (post_message != '' && imagepath != null) {
                            final path = imagepath.path;
                            final name = imagepath.path;
                            context
                                .read<PhotouploadCubit>()
                                .updateData(path, name, widget.RoomID)
                                .then((value) async {
                              String imagurl = await firebase_storage
                                  .FirebaseStorage.instance
                                  .ref('userimage/${widget.RoomID}/${name}')
                                  .getDownloadURL();
                              FirebaseFirestore.instance
                                  .collection('chat')
                                  .doc(widget.RoomID)
                                  .collection("Promotional_Post")
                                  .add({
                                "title":
                                    post_message != '' ? post_message : null,
                                "Image": imagurl,
                                "Time": DateTime.now(),
                                "ID": widget.RoomID,
                                "Visibility": true,
                                "author_ID": myuid
                              });
                              Navigator.of(context).pop();
                            });
                          } else if (imagepath != null) {
                            final path = imagepath.path;
                            final name = imagepath.path;
                            context
                                .read<PhotouploadCubit>()
                                .updateData(path, name, widget.RoomID)
                                .then((value) async {
                              String imagurl = await firebase_storage
                                  .FirebaseStorage.instance
                                  .ref('userimage/${widget.RoomID}/${name}')
                                  .getDownloadURL();
                              FirebaseFirestore.instance
                                  .collection('chat')
                                  .doc(widget.RoomID)
                                  .collection("Promotional_Post")
                                  .add({
                                "title":
                                    post_message != '' ? post_message : null,
                                "Image": imagurl,
                                "Time": DateTime.now(),
                                "ID": widget.RoomID,
                                "Visibility": true,
                                "author_ID": myuid
                              });
                              Navigator.of(context).pop();
                            });
                          } else {
                            FirebaseFirestore.instance
                                .collection('chat')
                                .doc(widget.RoomID)
                                .collection("Promotional_Post")
                                .add({
                              "title": post_message != '' ? post_message : null,
                              "Image": null,
                              "Time": DateTime.now(),
                              "ID": widget.RoomID,
                              "Visibility": true,
                              "author_ID": myuid
                            });
                            Navigator.of(context).pop();
                          }
                        }
                      : null,
                  style: TextButton.styleFrom(
                      primary: Theme.of(context).iconTheme.color),
                  child: Text(
                    'Post',
                    style: TextStyle(fontSize: 16.sp),
                  ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0.sp),
          child: Column(children: [
            Theme(
              data: ThemeData(focusColor: Theme.of(context).iconTheme.color),
              child: isloading && post_message == ''
                  ? Container()
                  : DetectableTextField(
                      readOnly: isloading,
                      enabled: isloading ? false : true,
                      onChanged: (String value) {
                        setState(() {
                          post_message = value;
                        });
                      },
                      maxLines: null,
                      cursorColor: Theme.of(context).iconTheme.color,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "typing....",
                          hintStyle: TextStyle(
                              color: Theme.of(context).iconTheme.color,
                              fontWeight: FontWeight.w300)),
                      detectionRegExp: detectionRegExp(),
                      decoratedStyle: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).iconTheme.color,
                          fontWeight: FontWeight.bold),
                      basicStyle: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).iconTheme.color),
                    ),
            ),
            if (imagepath != null) ...[
              Image.file(
                imagepath,
              )
            ],
            SizedBox(
              height: 5.w,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: isloading
                      ? null
                      : () async {
                          FilePickerResult result = await FilePicker.platform
                              .pickFiles(
                                  allowMultiple: false, type: FileType.image);

                          if (result != null) {
                            setState(() {
                              imagepath = File(result.files.single.path);
                            });
                          }
                        },
                  child: Container(
                    height: 15.w,
                    width: 70.w,
                    decoration: BoxDecoration(
                        color: isDarkMode
                            ? HexColor.fromHex("#1a1a1c")
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.upload,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        Text(
                          "Image",
                          style: TextStyle(
                              color: Theme.of(context).iconTheme.color),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
