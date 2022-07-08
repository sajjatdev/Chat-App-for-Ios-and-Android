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
import 'package:settings_ui/settings_ui.dart';
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
    return Builder(builder: (context) {
      final getstate = context.watch<ReadDataCubit>().state;
      if (getstate is Loadingstate) {
        return Center(
          child: CupertinoActivityIndicator(
              color: Theme.of(context).iconTheme.color),
        );
      }

      if (getstate is getprofileData) {
        return Scaffold(
          appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              actions: [
                TextButton(
                    onPressed: () {},
                    child: Text(
                      "Edit",
                      style: TextStyle(color: Colors.blue, fontSize: 15.sp),
                    ))
              ]),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.w),
                  child: Row(
                    children: [
                      if (getstate.profile_data.imageUrl
                          .contains("https://")) ...[
                        CircleAvatar(
                          radius: 30.sp,
                          backgroundImage:
                              NetworkImage(getstate.profile_data.imageUrl),
                        )
                      ] else ...[
                        ProfilePicture(
                            name: getstate.profile_data.imageUrl.trim(),
                            radius: 30.sp,
                            fontsize: 25.sp)
                      ],
                      SizedBox(
                        width: 10.sp,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getstate.profile_data.fullName +
                                      " " +
                                      getstate.profile_data.lastname ??
                                  "",
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).iconTheme.color),
                            ),
                            Text(
                              getstate.profile_data.phone,
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Theme.of(context).iconTheme.color),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: SettingsList(
                    sections: [
                      SettingsSection(
                        title: Text(
                          'Setttings',
                        ),
                        tiles: <SettingsTile>[
                          SettingsTile.navigation(
                            leading: Icon(
                              Icons.notifications,
                              color: Theme.of(context).iconTheme.color,
                              size: 15.sp,
                            ),
                            title: Text(
                              'Notification',
                              style: TextStyle(fontSize: 15.sp),
                            ),
                          ),
                          SettingsTile.navigation(
                            leading: Icon(
                              CupertinoIcons.chat_bubble,
                              color: Theme.of(context).iconTheme.color,
                              size: 15.sp,
                            ),
                            title: Text(
                              'chat',
                              style: TextStyle(fontSize: 15.sp),
                            ),
                          ),
                          SettingsTile.navigation(
                            leading: Icon(
                              CupertinoIcons.lock_circle,
                              color: Theme.of(context).iconTheme.color,
                              size: 15.sp,
                            ),
                            title: Text(
                              'Privacy',
                              style: TextStyle(fontSize: 15.sp),
                            ),
                          ),
                          SettingsTile.navigation(
                            leading: Icon(
                              CupertinoIcons.mail,
                              color: Theme.of(context).iconTheme.color,
                              size: 15.sp,
                            ),
                            title: Text(
                              'Contact us',
                              style: TextStyle(fontSize: 15.sp),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Button(
                  buttonenable: true,
                  onpress: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamed("/");
                  },
                  Texts: "LOGOUT",
                  widths: 80,
                ),
                SizedBox(
                  height: 15.sp,
                )
              ],
            ),
          ),
        );
      } else {
        return Column(children: []);
      }
    });
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
