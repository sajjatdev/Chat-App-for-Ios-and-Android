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
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => Profile_edit(
                                image: getstate.profile_data.imageUrl,
                                name: getstate.profile_data.fullName,
                                lastname: getstate.profile_data.lastname,
                                myuid: uid,
                                phonenumber: getstate.profile_data.phone,
                                Username: getstate.profile_data.username,
                              )));
                    },
                    child: Text(
                      "Edit",
                      style: TextStyle(color: Colors.blue, fontSize: 15.sp),
                    ))
              ]),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (getstate.profile_data.imageUrl.contains("https://")) ...[
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
                  height: 10.sp,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    SizedBox(
                      height: 5.sp,
                    ),
                    Text(
                      getstate.profile_data.phone,
                      style: TextStyle(fontSize: 15.sp, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 5.sp,
                    ),
                    Text(
                      getstate.profile_data.username,
                      style: TextStyle(fontSize: 15.sp, color: Colors.grey),
                    ),
                  ],
                ),
                Expanded(
                  flex: 2,
                  child: SettingsList(
                    lightTheme: SettingsThemeData(
                        settingsListBackground: Colors.transparent),
                    sections: [
                      SettingsSection(
                        title: Text(
                          '',
                        ),
                        tiles: <SettingsTile>[
                          SettingsTile.navigation(
                            onPressed: (BuildContext) {
                              print(uid);
                            },
                            leading: SvgPicture.asset(
                                "assets/setting_icon/notificationSetting.svg"),
                            title: Text(
                              'Notification and Sounds',
                              style: TextStyle(fontSize: 15.sp),
                            ),
                          ),
                          SettingsTile.navigation(
                            leading: SvgPicture.asset(
                                "assets/setting_icon/chatSetting.svg"),
                            title: Text(
                              'Chat',
                              style: TextStyle(fontSize: 15.sp),
                            ),
                          ),
                          SettingsTile.navigation(
                            leading: SvgPicture.asset(
                                "assets/setting_icon/PrivacySetting.svg"),
                            title: Text(
                              'Privacy',
                              style: TextStyle(fontSize: 15.sp),
                            ),
                          ),
                          SettingsTile.navigation(
                            leading: SvgPicture.asset(
                                "assets/setting_icon/contactSetting.svg"),
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
                InkWell(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamed("/");
                  },
                  child: Container(
                    height: 5.h,
                    width: 80.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? HexColor.fromHex("#353535")
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "Log Out",
                      style: TextStyle(color: Colors.red, fontSize: 15.sp),
                    ),
                  ),
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
