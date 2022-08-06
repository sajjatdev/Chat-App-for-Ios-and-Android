import 'dart:io';
import 'package:chatting/Helper/color.dart';
import 'package:chatting/logic/Profile_data_get/read_data_cubit.dart';
import 'package:chatting/logic/photo_upload/photoupload_cubit.dart';
import 'package:chatting/view/Screen/profile/numberchange.dart';
import 'package:chatting/view/Screen/profile/phoneNumberChangeAlert.dart';
import 'package:chatting/view/Screen/profile/usernamechange.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:sizer/sizer.dart';

class Profile_edit extends StatefulWidget {
  const Profile_edit(
      {Key key,
      this.image,
      this.name,
      this.myuid,
      this.lastname,
      this.phonenumber,
      this.Username})
      : super(key: key);
  final String image;
  final String name;
  final String myuid;
  final String lastname;
  final String phonenumber;
  final Username;

  @override
  State<Profile_edit> createState() => _Profile_editState();
}

class _Profile_editState extends State<Profile_edit> {
  TextEditingController name, lastname;
  File path;
  bool loader = false;

  @override
  void initState() {
    // TODO: implement initState

    name = TextEditingController(text: widget.name);
    lastname = TextEditingController(text: widget.lastname);
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
                          "first_name": name.value.text,
                          "last_name": lastname.text ?? "",
                        }).then((value) {
                          Navigator.of(context).pop();
                        });
                      }
                    });
                  } else {
                    FirebaseFirestore.instance
                        .collection('user')
                        .doc(widget.myuid)
                        .update({
                      "first_name": name.value.text,
                      "last_name": lastname.text ?? "",
                    }).then((value) {
                      Navigator.of(context).pop();
                    });
                  }

                  context
                      .read<ReadDataCubit>()
                      .getprofile_data(type: "profile", uid: widget.myuid);
                },
                child: Text(
                  "Done",
                  style: TextStyle(color: Colors.blue, fontSize: 12.sp),
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
                      try {
                        final picker = ImagePicker();
                        final pickedFile =
                            await picker.getImage(source: ImageSource.gallery);
                        // final result = await FilePicker.platform.pickFiles(
                        //     allowMultiple: false,
                        //     type: FileType.image,
                        //     allowedExtensions: ['png', 'jpg']);
                        print(pickedFile.path);
                        if (pickedFile.path != null) {
                          setState(() {
                            path = File(pickedFile.path);
                          });
                        }
                      } catch (e) {}
                    },
                    child: Text(
                      "Set New Photo",
                      style: TextStyle(color: Colors.blue, fontSize: 15.sp),
                    ),
                  ),
                  SizedBox(
                    height: 5.w,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.sp, vertical: 0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: isDarkMode
                              ? HexColor.fromHex("#1a1a1c")
                              : HexColor.fromHex("#ffffff"),
                          borderRadius: BorderRadius.circular(10.sp)),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.sp, vertical: 0),
                            child: TextField(
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Theme.of(context).iconTheme.color),
                              cursorColor: Theme.of(context).iconTheme.color,
                              controller: name,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              )),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.sp),
                            child: Divider(
                              height: .5,
                              color: Colors.grey,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.sp, vertical: 0),
                            child: TextField(
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Theme.of(context).iconTheme.color),
                              cursorColor: Theme.of(context).iconTheme.color,
                              controller: lastname,
                              decoration: InputDecoration(
                                  hintText: "Last Name",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.w,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.sp),
                    child: Text(
                      "Enter your name and add an optional profile photo",
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                  ),
                  Expanded(
                    child: SettingsList(
                      sections: [
                        SettingsSection(
                          title: Text(
                            '',
                          ),
                          tiles: <SettingsTile>[
                            SettingsTile.navigation(
                              onPressed: (context) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => PhoneChangeAlert(
                                          myuid: widget.myuid,
                                        )));
                              },
                              value: StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('user')
                                      .doc(widget.myuid)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      Map<String, dynamic> phonenumber =
                                          snapshot.data.data();
                                      return Text(
                                        phonenumber["Phone_number"] ?? "",
                                        style: TextStyle(fontSize: 12.sp),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  }),
                              title: Text(
                                'Change Number',
                                style: TextStyle(fontSize: 15.sp),
                              ),
                            ),
                            SettingsTile.navigation(
                              onPressed: (context) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => usernamechange(
                                          myuid: widget.myuid,
                                        )));
                              },
                              value: StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('user')
                                      .doc(widget.myuid)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      Map<String, dynamic> phonenumber =
                                          snapshot.data.data();
                                      return Text(
                                        phonenumber["username"] ?? "",
                                        style: TextStyle(fontSize: 12.sp),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  }),
                              title: Text(
                                'Username',
                                style: TextStyle(fontSize: 15.sp),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
