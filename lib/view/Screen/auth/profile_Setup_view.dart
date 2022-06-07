import 'dart:io';

import 'package:chatting/Helper/color.dart';
import 'package:chatting/Services/Auth.dart';
import 'package:chatting/logic/Profile_setup/profile_setup_cubit.dart';
import 'package:chatting/logic/current_user/cunrrent_user_bloc.dart';
import 'package:chatting/logic/photo_upload/photoupload_cubit.dart';
import 'package:chatting/main.dart';
import 'package:chatting/view/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class profile_setup extends StatefulWidget {
  const profile_setup({Key key}) : super(key: key);

  static const String routeName = '/profile_Setup';

  static Route route() {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => profile_setup());
  }

  @override
  _profile_setupState createState() => _profile_setupState();
}

class _profile_setupState extends State<profile_setup> {
  File image;
  bool isloading = false;
  bool buttonenable = false;
  bool btnloading = false;
  String username;
  String names;
  String lastnames;

  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController firstname;
  TextEditingController lastname;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calldata();
  }

  void calldata() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      names = prefs.getString('name');
      lastnames = prefs.getString('lastname');
    });

    if (names != null) {
      setState(() {
        firstname = TextEditingController(text: names);
      });
    }

    if (lastnames != null) {
      setState(() {
        lastname = TextEditingController(text: lastnames);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      BlocProvider.of<CunrrentUserBloc>(context).add(calluserdata());
    });

    return Scaffold(
      body: BlocBuilder<CunrrentUserBloc, CunrrentUserState>(
          builder: (context, state) {
        final imagedata = context.watch<PhotouploadCubit>().state;
        if (state is hasdata) {
          return SafeArea(
              child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Setup profile",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 10.w,
                ),
                Builder(builder: (context) {
                  if (imagedata is loadingimage) {
                    return CircleAvatar(
                      radius: 30.0.sp,
                      child: CupertinoActivityIndicator(),
                    );
                  }
                  if (imagedata is photouploadss) {
                    return CircleAvatar(
                      radius: 30.0.sp,
                      backgroundImage: NetworkImage(imagedata.ImageURL),
                    );
                  } else {
                    return Container(
                      width: 15.w,
                      height: 15.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: HexColor.fromHex("#3A9EEE"),
                          borderRadius: BorderRadius.circular(50)),
                      child: IconButton(
                          onPressed: () async {
                            final result = await FilePicker.platform.pickFiles(
                                allowMultiple: false,
                                type: FileType.image,
                                allowCompression: false);

                            print(result.files.single.path);
                            FirebaseFirestore.instance
                                .collection(result.files.single.path);
                            if (result != null) {
                              final path = result.files.single.path;
                              final name = result.files.single.name;
                              context
                                  .read<PhotouploadCubit>()
                                  .updateData(path, name, state.user.uid);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('No Image Selected')));
                            }
                          },
                          icon: SvgPicture.asset(
                            'assets/svg/add-friend.svg',
                            color: Theme.of(context).iconTheme.color,
                          )),
                    );
                  }
                }),
                SizedBox(
                  height: 10.w,
                ),
                Form(
                    key: _globalKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  names = value;
                                });
                              },
                              validator: (value) =>
                                  value.isEmpty ? "Name can't be blank" : null,
                              controller: firstname,
                              onSaved: (value) {
                                print(value);
                              },
                              style: TextStyle(
                                  color: Theme.of(context).iconTheme.color),
                              decoration: InputDecoration(
                                hintText: "First Name (Required)",
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: HexColor.fromHex("#D8D8D8")),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: HexColor.fromHex("#D8D8D8")),
                                ),
                                hintStyle: TextStyle(
                                    color: HexColor.fromHex("#C9C9CB")),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.w,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextFormField(
                              controller: lastname,
                              onChanged: (value) {
                                setState(() {
                                  lastnames = value;
                                });
                              },
                              style: TextStyle(
                                  color: Theme.of(context).iconTheme.color),
                              decoration: InputDecoration(
                                hintText: "Last Name (Optional)",
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: HexColor.fromHex("#D8D8D8")),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: HexColor.fromHex("#D8D8D8")),
                                ),
                                hintStyle: TextStyle(
                                    color: HexColor.fromHex("#C9C9CB")),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.w,
                          ),
                          Container(
                            height: 15.w,
                            width: 80.w,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                              color: HexColor.fromHex("#D8D8D8"),
                            ))),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    username == null
                                        ? "Username (Required)"
                                        : "$username",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: username == null
                                            ? HexColor.fromHex("#C9C9CB")
                                            : Theme.of(context).iconTheme.color,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.sp),
                                  ),
                                  Builder(builder: (context) {
                                    if (imagedata is photouploadss) {
                                      return IconButton(
                                          onPressed: () async {
                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            await prefs.setString(
                                                'name', names);
                                            await prefs.setString(
                                                'lastname',
                                                lastnames == ''
                                                    ? ''
                                                    : lastnames);
                                            Navigator.of(context)
                                                .pushNamed('/username_crate');
                                          },
                                          icon: SvgPicture.asset(
                                            'assets/svg/Left_Arrow_4_.svg',
                                            color: HexColor.fromHex('#5F5F62'),
                                          ));
                                    }
                                    return IconButton(
                                        // onPressed: () async {
                                        //   final prefs = await SharedPreferences
                                        //       .getInstance();
                                        //   await prefs.setString('name', names);
                                        //   await prefs.setString('lastname',
                                        //       lastnames == '' ? '' : lastnames);
                                        //   Navigator.of(context)
                                        //       .pushNamed('/username_crate');
                                        // },
                                        icon: SvgPicture.asset(
                                      'assets/svg/Left_Arrow_4_.svg',
                                      color: HexColor.fromHex('#5F5F62'),
                                    ));
                                  })
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
                SizedBox(
                  height: 30.h,
                ),
                Builder(builder: (context) {
                  if (imagedata is photouploadss) {
                    return Button(
                      buttonenable: true,
                      loadingbtn: btnloading,
                      onpress: () async {
                        final FormState status = _globalKey.currentState;

                        if (status.validate()) {
                          setState(() {
                            btnloading = true;
                          });

                          context.read<ProfileSetupCubit>().set_profile(
                              Firstname: firstname.text,
                              lastname: lastnames == null ? '' : lastnames,
                              username: '@' + username,
                              imageURL: imagedata.ImageURL,
                              phone_number: state.user.phoneNumber,
                              uid: state.user.uid);
                          sharedPreferences.setString(
                              'uid', state.user.phoneNumber);
                          sharedPreferences.setString(
                              'number', state.user.phoneNumber);
                          Future.delayed(Duration(seconds: 5), () {
                            Navigator.of(context).pushNamed('/');
                          });
                        }
                      },
                      Texts: "DONE",
                      widths: 80,
                    );
                  } else {
                    return Button(
                      buttonenable: false,
                      onpress: () {},
                      Texts: "DONE",
                      widths: 80,
                    );
                  }
                }),
                SizedBox(
                  height: 10.w,
                ),
              ],
            ),
          ));
        } else {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }
      }),
    );
  }
}
