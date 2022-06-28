import 'package:chatting/Helper/color.dart';
import 'package:chatting/logic/Profile_data_get/read_data_cubit.dart';
import 'package:chatting/main.dart';
import 'package:chatting/view/Screen/profile/profile_edit.dart';
import 'package:chatting/view/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:strings/strings.dart';

class setting_view extends StatefulWidget {
  const setting_view({Key key}) : super(key: key);

  @override
  _setting_viewState createState() => _setting_viewState();
}

class _setting_viewState extends State<setting_view> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String uid;
  String number;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuid();
  }

  void getuid() {
    setState(() {
      uid = sharedPreferences.getString('uid');
      // number = sharedPreferences.getString('number');
      context.read<ReadDataCubit>().getprofile_data(uid: uid, type: "profile");
    });
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      body: Builder(builder: (context) {
        final getstate = context.watch<ReadDataCubit>().state;
        if (getstate is Loadingstate) {
          return Center(
            child: CupertinoActivityIndicator(
                color: Theme.of(context).iconTheme.color),
          );
        }
        if (getstate is getprofileData) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(children: [
                Row(
                  children: [
                    Text(
                      'Settings',
                      style: TextStyle(
                          color: Theme.of(context).iconTheme.color,
                          fontSize: 24.sp),
                    ),
                  ],
                ),
                Spacer(
                  flex: 1,
                ),
                Container(
                  height: 25.w,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: isDarkMode
                          ? HexColor.fromHex("#1a1a1c")
                          : HexColor.fromHex("#ffffff"),
                      borderRadius: BorderRadius.circular(15.sp)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          if (getstate.profile_data.imageUrl
                              .contains("https://")) ...[
                            CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  NetworkImage(getstate.profile_data.imageUrl),
                            )
                          ] else ...[
                            ProfilePicture(
                              name: getstate.profile_data.fullName.trim(),
                              radius: 30,
                              fontsize: 21,
                            )
                          ],
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  capitalize(getstate.profile_data.fullName),
                                  style: TextStyle(
                                      color: Theme.of(context).iconTheme.color,
                                      fontSize: 16.sp),
                                ),
                                Text(
                                  capitalize(getstate.profile_data.username),
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .iconTheme
                                          .color
                                          .withOpacity(0.5),
                                      fontSize: 12.sp),
                                ),
                                SizedBox(
                                  height: 1.5.w,
                                ),
                                // Text(
                                //   number,
                                //   style: TextStyle(
                                //       color: Theme.of(context)
                                //           .iconTheme
                                //           .color
                                //           .withOpacity(0.5),
                                //       fontSize: 12.sp),
                                // )
                              ],
                            ),
                          )
                        ]),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Profile_edit(
                                        image: getstate.profile_data.imageUrl,
                                        name: getstate.profile_data.fullName,
                                        myuid: uid,
                                      )));
                            },
                            icon: SvgPicture.asset(
                              'assets/svg/Left.svg',
                              color: HexColor.fromHex('#5F5F62'),
                              width: 7.sp,
                              height: 12.sp,
                            ))
                      ],
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  height: 70.w,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: isDarkMode
                          ? HexColor.fromHex("#1a1a1c")
                          : HexColor.fromHex("#ffffff"),
                      borderRadius: BorderRadius.circular(15.sp)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListTile(
                        title: Text(
                          "Notification",
                          style: TextStyle(
                              color: Theme.of(context).iconTheme.color,
                              fontSize: 16.sp),
                        ),
                        leading: SvgPicture.asset(
                          'assets/svg/notification.svg',
                          width: 30.sp,
                          height: 30.sp,
                        ),
                        trailing: IconButton(
                            onPressed: () {},
                            icon: SvgPicture.asset(
                              'assets/svg/Left.svg',
                              color: HexColor.fromHex('#5F5F62'),
                              width: 7.sp,
                              height: 12.sp,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          height: 10.0,
                          child: Center(
                            child: Container(
                              margin: const EdgeInsetsDirectional.only(
                                  start: 1.0, end: 1.0),
                              height: 0.5,
                              color: Colors.grey.withOpacity(0.2),
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          "Chats",
                          style: TextStyle(
                              color: Theme.of(context).iconTheme.color,
                              fontSize: 16.sp),
                        ),
                        leading: SvgPicture.asset(
                          'assets/svg/starred-message.svg',
                          width: 30.sp,
                          height: 30.sp,
                        ),
                        trailing: IconButton(
                            onPressed: () {},
                            icon: SvgPicture.asset(
                              'assets/svg/Left.svg',
                              color: HexColor.fromHex('#5F5F62'),
                              width: 7.sp,
                              height: 12.sp,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          height: 10.0,
                          child: Center(
                            child: Container(
                              margin: const EdgeInsetsDirectional.only(
                                  start: 1.0, end: 1.0),
                              height: 0.5,
                              color: Colors.grey.withOpacity(0.2),
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          "Privacy",
                          style: TextStyle(
                              color: Theme.of(context).iconTheme.color,
                              fontSize: 16.sp),
                        ),
                        leading: SvgPicture.asset(
                          'assets/svg/security.svg',
                          width: 30.sp,
                          height: 30.sp,
                        ),
                        trailing: IconButton(
                            onPressed: () {},
                            icon: SvgPicture.asset(
                              'assets/svg/Left.svg',
                              color: HexColor.fromHex('#5F5F62'),
                              width: 7.sp,
                              height: 12.sp,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          height: 10.0,
                          child: Center(
                            child: Container(
                              margin: EdgeInsetsDirectional.only(
                                  start: 1.0, end: 1.0),
                              height: 0.5,
                              color: Colors.grey.withOpacity(0.2),
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          "About",
                          style: TextStyle(
                              color: Theme.of(context).iconTheme.color,
                              fontSize: 16.sp),
                        ),
                        leading: SvgPicture.asset(
                          'assets/svg/saved.svg',
                          width: 30.sp,
                          height: 30.sp,
                        ),
                        trailing: IconButton(
                            onPressed: () {},
                            icon: SvgPicture.asset(
                              'assets/svg/Left.svg',
                              color: HexColor.fromHex('#5F5F62'),
                              width: 7.sp,
                              height: 12.sp,
                            )),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Button(
                  buttonenable: true,
                  onpress: () async {
                    await _deleteCacheDir();
                    await _deleteAppDir();
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamed("/");
                  },
                  Texts: "Logout",
                  widths: 80,
                ),
              ]),
            ),
          );
        } else {
          return Column(children: []);
        }
      }),
    );
  }

  /// this will delete cache
  Future<void> _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  /// this will delete app's storage
  Future<void> _deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();

    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }
}
