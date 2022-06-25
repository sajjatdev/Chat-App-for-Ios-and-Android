import 'dart:io';

import 'package:chatting/Helper/color.dart';
import 'package:chatting/logic/photo_upload/photoupload_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:sizer/sizer.dart';

class Profile_edit extends StatefulWidget {
  const Profile_edit({Key key, this.image, this.name, this.myuid})
      : super(key: key);
  final String image;
  final String name;
  final String myuid;

  @override
  State<Profile_edit> createState() => _Profile_editState();
}

class _Profile_editState extends State<Profile_edit> {
  TextEditingController name;
  File path;
  bool loader = false;

  @override
  void initState() {
    // TODO: implement initState

    name = TextEditingController(text: widget.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return LoadingOverlay(
      isLoading: loader,
      progressIndicator:
          CupertinoActivityIndicator(color: Theme.of(context).iconTheme.color),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
          title: Text(
            "Profile Edit",
            style: TextStyle(color: Theme.of(context).iconTheme.color),
          ),
          backgroundColor: Colors.transparent,
          actions: [
            TextButton(
                style: TextButton.styleFrom(
                    primary: Theme.of(context).iconTheme.color),
                onPressed: () async {
                  setState(() {
                    loader = true;
                  });
                  if (path != null) {
                    context
                        .read<PhotouploadCubit>()
                        .updateData(path.path, path.path, path.path)
                        .then((value) async {
                      String imagurl = await firebase_storage
                          .FirebaseStorage.instance
                          .ref('userimage/${path.path}/${path.path}')
                          .getDownloadURL();

                      if (imagurl != null) {
                        FirebaseFirestore.instance
                            .collection('user')
                            .doc(widget.myuid)
                            .update({
                          'imageUrl': imagurl,
                          "first_name": name.value.text
                        }).then((value) {
                          Navigator.of(context).pop();
                        });
                      }
                    });
                  } else {
                    FirebaseFirestore.instance
                        .collection('user')
                        .doc(widget.myuid)
                        .update({"first_name": name.value.text}).then((value) {
                      Navigator.of(context).pop();
                    });
                  }
                },
                child: Text(
                  "SAVE",
                  style: TextStyle(color: Theme.of(context).iconTheme.color),
                ))
          ],
        ),
        body: SafeArea(
          child: Container(
            width: 100.w,
            height: 100.h,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (path != null) ...[
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: FileImage(path),
                    )
                  ] else ...[
                    if (widget.image.contains("https://")) ...[
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(widget.image),
                      )
                    ] else ...[
                      ProfilePicture(
                        name: widget.image.trim(),
                        radius: 40,
                        fontsize: 25,
                      )
                    ],
                  ],
                  TextButton(
                    style: TextButton.styleFrom(
                        primary: Theme.of(context).iconTheme.color),
                    onPressed: () async {
                      final result = await FilePicker.platform.pickFiles(
                          allowMultiple: false,
                          type: FileType.custom,
                          allowedExtensions: ['png', 'jpg', 'gif']);

                      if (result != null) {
                        setState(() {
                          path = File(result.files.single.path);
                        });
                      }
                    },
                    child: Text("Set New  Display Image "),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: TextField(
                      controller: name,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: isDarkMode
                              ? HexColor.fromHex("#1a1a1c")
                              : HexColor.fromHex("#ffffff"),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
