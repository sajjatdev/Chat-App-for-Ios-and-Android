import 'package:chatting/Helper/color.dart';
import 'package:chatting/logic/group_profile/group_profile_cubit.dart';
import 'package:chatting/logic/photo_upload/photoupload_cubit.dart';
import 'package:chatting/main.dart';
import 'package:chatting/view/Screen/group/group_edit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:strings/strings.dart';

import 'add member and admin/add.dart';

class group_profile extends StatefulWidget {
  const group_profile({Key key, this.UIDuser}) : super(key: key);

  static const String routeName = '/group_profile';

  static Route route({String UIDuser}) {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => group_profile(
              UIDuser: UIDuser,
            ));
  }

  final String UIDuser;

  @override
  State<group_profile> createState() => _group_profileState();
}

class _group_profileState extends State<group_profile> {
  String myuid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_group_data(uid: widget.UIDuser);
  }

  void get_group_data({String uid}) {
    myuid = sharedPreferences.getString('uid');
    context.read<GroupProfileCubit>().Get_Group_Data(Room_Id: uid);
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).iconTheme.color,
              ))),
      body: BlocBuilder<GroupProfileCubit, GroupProfileState>(
        builder: (context, state) {
          if (state is Group_Data_loading) {
            return Center(
              child: CupertinoActivityIndicator(
                  color: Theme.of(context).iconTheme.color),
            );
          } else if (state is Success_Get_Group_Data) {
            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 2.w,
                    ),
                    Container(
                      child: CircleAvatar(
                          radius: 30.sp,
                          backgroundImage:
                              NetworkImage(state.group_profile.groupImage)),
                    ),
                    SizedBox(
                      height: 2.w,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          primary: Theme.of(context).iconTheme.color),
                      onPressed: () async {
                        FilePickerResult result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: [
                            'jpg',
                            'pdf',
                          ],
                        );

                        if (result != null) {
                          final path = result.files.single.path;
                          final name = result.files.single.name;
                          context
                              .read<PhotouploadCubit>()
                              .updateData(path, name, name)
                              .then((value) async {
                            String imagurl = await firebase_storage
                                .FirebaseStorage.instance
                                .ref('userimage/${name}/${name}')
                                .getDownloadURL();

                            FirebaseFirestore.instance
                                .collection('chat')
                                .doc(widget.UIDuser)
                                .update({"group_image": imagurl});
                            context
                                .read<GroupProfileCubit>()
                                .Get_Group_Data(Room_Id: widget.UIDuser);
                          });
                        }
                      },
                      child: Text(
                        "Set New Display Photo",
                        style:
                            TextStyle(color: Theme.of(context).iconTheme.color),
                      ),
                    ),
                    SizedBox(
                      height: 5.w,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: isDarkMode
                              ? HexColor.fromHex("#1a1a1c")
                              : HexColor.fromHex("#ffffff"),
                          borderRadius: BorderRadius.circular(15.sp)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15, vertical: 2.sp),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  capitalize(state.group_profile.groupName),
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                if (state.group_profile.admin
                                    .contains(myuid)) ...[
                                  IconButton(
                                    splashColor:
                                        Theme.of(context).iconTheme.color,
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => Group_edit(
                                                    data: state.group_profile
                                                        .groupName,
                                                    is_title: true,
                                                    room_data: widget.UIDuser,
                                                  )));
                                    },
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                  ),
                                ] else ...[
                                  SvgPicture.asset(
                                    'assets/svg/padlock.svg',
                                    width: 15.sp,
                                    height: 15.sp,
                                    color: Theme.of(context).iconTheme.color,
                                  )
                                ]
                              ],
                            ),
                            SizedBox(
                              height: 5.w,
                              child: const Divider(
                                height: 1,
                                color: Color.fromARGB(255, 223, 223, 223),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  child: Text(
                                    state.group_profile.description,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.grey.shade400),
                                  ),
                                ),
                                if (state.group_profile.admin
                                    .contains(myuid)) ...[
                                  IconButton(
                                    splashColor:
                                        Theme.of(context).iconTheme.color,
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => Group_edit(
                                                    data: state.group_profile
                                                        .description,
                                                    is_title: false,
                                                    room_data: widget.UIDuser,
                                                  )));
                                    },
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                  ),
                                ] else ...[
                                  SvgPicture.asset(
                                    'assets/svg/padlock.svg',
                                    width: 15.sp,
                                    height: 15.sp,
                                    color: Theme.of(context).iconTheme.color,
                                  )
                                ]
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            "LINK",
                            style: TextStyle(
                                color: Theme.of(context).iconTheme.color,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Container(
                          height: 15.w,
                          alignment: Alignment.centerLeft,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: isDarkMode
                                  ? HexColor.fromHex("#1a1a1c")
                                  : HexColor.fromHex("#ffffff"),
                              borderRadius: BorderRadius.circular(10.sp)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${state.group_profile.groupUrl}",
                                  style: TextStyle(
                                      color: Theme.of(context).iconTheme.color,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: SvgPicture.asset(
                                    'assets/svg/share.svg',
                                    width: 15.sp,
                                    height: 15.sp,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            "GROUP ADMIN",
                            style: TextStyle(
                                color: Theme.of(context).iconTheme.color,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Container(
                          height: 45.w,
                          alignment: Alignment.topCenter,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: isDarkMode
                                  ? HexColor.fromHex("#1a1a1c")
                                  : HexColor.fromHex("#ffffff"),
                              borderRadius: BorderRadius.circular(10.sp)),
                          child: SingleChildScrollView(
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    if (state.group_profile.admin
                                        .contains(myuid)) ...[
                                      ListTile(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (context) => add(
                                                        isadmin: true,
                                                        roomid: widget.UIDuser,
                                                      )));
                                        },
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.blue,
                                          child: SvgPicture.asset(
                                            'assets/svg/more.svg',
                                            width: 5.w,
                                            height: 5.w,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                          ),
                                        ),
                                        title: const Text(
                                          "Add Admin",
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                        subtitle: const Text(
                                          "Users who can help you manage this group.",
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2.w,
                                        child: const Divider(
                                          height: 1,
                                          color: Color.fromARGB(
                                              255, 214, 214, 214),
                                        ),
                                      ),
                                    ],
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount:
                                            state.group_profile.admin.length,
                                        itemBuilder: (context, index) {
                                          return FutureBuilder<
                                                  DocumentSnapshot<
                                                      Map<String, dynamic>>>(
                                              future: FirebaseFirestore.instance
                                                  .collection('user')
                                                  .doc(state.group_profile
                                                      .admin[index])
                                                  .get(),
                                              builder: (context,
                                                  AsyncSnapshot<
                                                          DocumentSnapshot<
                                                              Map<String,
                                                                  dynamic>>>
                                                      snapshot) {
                                                if (snapshot.hasData) {
                                                  Map<String, dynamic>
                                                      admin_data = snapshot.data
                                                          .data() as Map;

                                                  String Imagecheck =
                                                      admin_data['imageUrl'];
                                                  return ListTile(
                                                    trailing: myuid !=
                                                            admin_data['uid']
                                                        ? IconButton(
                                                            onPressed: () {
                                                              showModalBottomSheet(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: <
                                                                          Widget>[
                                                                        ListTile(
                                                                          leading:
                                                                              new Icon(Icons.admin_panel_settings),
                                                                          title:
                                                                              new Text('Remove'),
                                                                          onTap:
                                                                              () {
                                                                            FirebaseFirestore.instance.collection("chat").doc(widget.UIDuser).update({
                                                                              "admin": FieldValue.arrayRemove([
                                                                                admin_data['uid']
                                                                              ])
                                                                            });
                                                                            Navigator.pop(context);
                                                                          },
                                                                        ),
                                                                      ],
                                                                    );
                                                                  });
                                                            },
                                                            icon: Icon(
                                                              Icons.more_vert,
                                                              color: Theme.of(
                                                                      context)
                                                                  .iconTheme
                                                                  .color,
                                                            ))
                                                        : IconButton(
                                                            onPressed: () {},
                                                            icon: Icon(
                                                              Icons
                                                                  .admin_panel_settings,
                                                              color: Theme.of(
                                                                      context)
                                                                  .iconTheme
                                                                  .color,
                                                            )),
                                                    leading: Imagecheck
                                                            .contains(
                                                                "https://")
                                                        ? CircleAvatar(
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    admin_data[
                                                                        'imageUrl']))
                                                        : ProfilePicture(
                                                            name: Imagecheck
                                                                .trim(),
                                                            radius: 20,
                                                            fontsize: 15),
                                                    title: Text(admin_data[
                                                        'first_name']),
                                                    subtitle: Text('Admin',
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 12.sp)),
                                                  );
                                                }
                                                return Center(
                                                    child:
                                                        CupertinoActivityIndicator(
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color,
                                                ));
                                              });
                                        }),
                                  ],
                                )),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            "MEMBERS",
                            style: TextStyle(
                                color: Theme.of(context).iconTheme.color,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Container(
                          height: 70.w,
                          alignment: Alignment.topCenter,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: isDarkMode
                                  ? HexColor.fromHex("#1a1a1c")
                                  : HexColor.fromHex("#ffffff"),
                              borderRadius: BorderRadius.circular(10.sp)),
                          child: SingleChildScrollView(
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    if (state.group_profile.admin
                                        .contains(myuid)) ...[
                                      ListTile(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (context) => add(
                                                        isadmin: false,
                                                        roomid: widget.UIDuser,
                                                      )));
                                        },
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.blue,
                                          child: SvgPicture.asset(
                                            'assets/svg/more.svg',
                                            width: 5.w,
                                            height: 5.w,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                          ),
                                        ),
                                        title: const Text(
                                          "Add Members",
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                        subtitle: const Text(
                                          "Add Mamabers in this Group ",
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2.w,
                                        child: const Divider(
                                          height: 1,
                                          color: Color.fromARGB(
                                              255, 214, 214, 214),
                                        ),
                                      ),
                                    ],
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount:
                                            state.group_profile.mamber.length,
                                        itemBuilder: (context, index) {
                                          return FutureBuilder<
                                                  DocumentSnapshot<
                                                      Map<String, dynamic>>>(
                                              future: FirebaseFirestore.instance
                                                  .collection('user')
                                                  .doc(state.group_profile
                                                      .mamber[index])
                                                  .get(),
                                              builder: (context,
                                                  AsyncSnapshot<
                                                          DocumentSnapshot<
                                                              Map<String,
                                                                  dynamic>>>
                                                      snapshot) {
                                                if (snapshot.hasData) {
                                                  Map<String, dynamic>
                                                      mamber_data =
                                                      snapshot.data.data();

                                                  String imageCheck =
                                                      mamber_data['imageUrl'];
                                                  return ListTile(
                                                    trailing: myuid !=
                                                            mamber_data['uid']
                                                        ? IconButton(
                                                            onPressed: () {
                                                              showModalBottomSheet(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: <
                                                                          Widget>[
                                                                        ListTile(
                                                                          leading:
                                                                              new Icon(Icons.remove),
                                                                          title:
                                                                              new Text('Remove'),
                                                                          onTap:
                                                                              () {
                                                                            FirebaseFirestore.instance.collection("chat").doc(widget.UIDuser).update({
                                                                              "mamber": FieldValue.arrayRemove([
                                                                                mamber_data['uid']
                                                                              ])
                                                                            }).then((value) {
                                                                              FirebaseFirestore.instance.collection("user").doc(mamber_data['uid']).collection("Friends").doc(widget.UIDuser).delete();
                                                                            });
                                                                            Navigator.pop(context);
                                                                          },
                                                                        ),
                                                                      ],
                                                                    );
                                                                  });
                                                            },
                                                            icon: Icon(
                                                              Icons.more_vert,
                                                              color: Theme.of(
                                                                      context)
                                                                  .iconTheme
                                                                  .color,
                                                            ))
                                                        : IconButton(
                                                            onPressed: () {},
                                                            icon: Icon(
                                                              Icons
                                                                  .verified_user,
                                                              color: Theme.of(
                                                                      context)
                                                                  .iconTheme
                                                                  .color,
                                                            )),
                                                    leading: imageCheck
                                                            .contains(
                                                                "https://")
                                                        ? CircleAvatar(
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    mamber_data[
                                                                        'imageUrl']))
                                                        : ProfilePicture(
                                                            name: imageCheck
                                                                .trim(),
                                                            radius: 20,
                                                            fontsize: 15),
                                                    title: Text(mamber_data[
                                                        'first_name']),
                                                    subtitle: Text('Mamber',
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 12.sp)),
                                                  );
                                                }
                                                return Center(
                                                    child:
                                                        CupertinoActivityIndicator(
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color,
                                                ));
                                              });
                                        }),
                                  ],
                                )),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2.w,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
