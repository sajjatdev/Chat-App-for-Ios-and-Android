import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:chatting/Helper/color.dart';
import 'package:chatting/logic/group_create/group_create_cubit.dart';
import 'package:chatting/logic/photo_upload/photoupload_cubit.dart';
import 'package:chatting/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

class create_group extends StatefulWidget {
  static const String routeName = '/create_group';

  static Route route({List member_list}) {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => create_group(
              member_list: member_list,
            ));
  }

  final List member_list;
  create_group({Key key, @required this.member_list}) : super(key: key);

  @override
  State<create_group> createState() => _create_groupState();
}

class _create_groupState extends State<create_group> {
  TextEditingController Group_name = TextEditingController();
  TextEditingController description = TextEditingController();
  String path;
  String name;
  String myuid;
  bool is_loading = false;

  bool creategrout = false;
  List admin_list = [];
  bool has_path = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    show();
  }

  void show() async {
    setState(() {
      myuid = sharedPreferences.getString('uid');
      admin_list.add(myuid);
      widget.member_list.add(myuid);
      print(widget.member_list);
    });
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Back",
              style: TextStyle(
                  color: Theme.of(context).iconTheme.color,
                  fontWeight: FontWeight.w500),
            )),
        actions: [
          Material(
            color: Theme.of(context).iconTheme.color,
            child: TextButton(
                onPressed: () async {
                  if (Group_name.text != null && path != null) {
                    setState(() {
                      is_loading = true;
                    });
                    context
                        .read<PhotouploadCubit>()
                        .updateData(
                            path, name, Group_name.text.replaceAll(" ", ''))
                        .then((value) async {
                      try {
                        String imagurl = await firebase_storage
                            .FirebaseStorage.instance
                            .ref(
                                'userimage/${Group_name.text.replaceAll(" ", '')}/${name}')
                            .getDownloadURL();

                        context
                            .read<GroupCreateCubit>()
                            .create(
                              admin: admin_list,
                              group_image: imagurl,
                              group_name: Group_name.text,
                              mamber: widget.member_list,
                              group_username:
                                  Group_name.text.replaceAll(" ", ''),
                              group_url: Group_name.text.replaceAll(" ", ''),
                            )
                            .then((value) {
                          Navigator.of(context)
                              .pushReplacementNamed('/messageing', arguments: {
                            'otheruid':
                                Group_name.text.replaceAll(" ", '').toString(),
                            'type': 'group',
                            'mamber_list': widget.member_list,
                          });
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())));
                      }
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                      'Enter you Correct Information',
                    )));
                  }
                },
                child: is_loading
                    ? Center(
                        child: CupertinoActivityIndicator(
                        color: Theme.of(context).iconTheme.color,
                      ))
                    : Text(
                        "Create",
                        style: TextStyle(
                            color: Theme.of(context).iconTheme.color,
                            fontWeight: FontWeight.w500),
                      )),
          ),
        ],
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Group_name.text != null
                  ? GestureDetector(
                      onTap: () async {
                        final result = await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                            type: FileType.custom,
                            allowedExtensions: ['png', 'jpg', 'gif']);

                        if (result != null) {
                          setState(() {
                            path = result.files.single.path;
                            name = result.files.single.name;
                            has_path = true;
                          });
                        }
                      },
                      child: Container(
                        width: 15.w,
                        height: 15.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Theme.of(context).iconTheme.color,
                            borderRadius: BorderRadius.circular(50)),
                        child: has_path
                            ? CircleAvatar(
                                radius: 25.sp,
                                backgroundImage: FileImage(
                                  File(path),
                                ),
                              )
                            : SvgPicture.asset(
                                'assets/svg/Shape_group.svg',
                                color: Theme.of(context).iconTheme.color,
                              ),
                      ),
                    )
                  : Container(),
              const Spacer(),
              Container(
                height: 40.w,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: isDarkMode
                        ? HexColor.fromHex("#1a1a1c")
                        : HexColor.fromHex("#ffffff"),
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: Group_name,
                        validator: (value) =>
                            value.isEmpty ? "Name can't be blank" : null,
                        onSaved: (value) {
                          print(value);
                        },
                        style:
                            TextStyle(color: Theme.of(context).iconTheme.color),
                        decoration: InputDecoration(
                          hintText: "Group Name (Mandatory)",
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: HexColor.fromHex("#D8D8D8")),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: HexColor.fromHex("#D8D8D8")),
                          ),
                          hintStyle:
                              TextStyle(color: HexColor.fromHex("#C9C9CB")),
                        ),
                      ),
                      TextFormField(
                        controller: description,
                        validator: (value) =>
                            value.isEmpty ? "Name can't be blank" : null,
                        onSaved: (value) {
                          print(value);
                        },
                        style:
                            TextStyle(color: Theme.of(context).iconTheme.color),
                        decoration: InputDecoration(
                          hintText: "Description (Optional)",
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: HexColor.fromHex("#D8D8D8")),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: HexColor.fromHex("#D8D8D8")),
                          ),
                          hintStyle:
                              TextStyle(color: HexColor.fromHex("#C9C9CB")),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(
                flex: 2,
              ),
              Container(
                height: 50.w,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: isDarkMode
                        ? HexColor.fromHex("#1a1a1c")
                        : HexColor.fromHex("#ffffff"),
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                  child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(),
                      itemCount: widget.member_list.length,
                      itemBuilder: (context, index) {
                        return FutureBuilder<
                                DocumentSnapshot<Map<String, dynamic>>>(
                            future: FirebaseFirestore.instance
                                .collection('user')
                                .doc(widget.member_list[index])
                                .get(),
                            builder: (context,
                                AsyncSnapshot<
                                        DocumentSnapshot<Map<String, dynamic>>>
                                    snapshot) {
                              if (snapshot.hasData) {
                                final datas = snapshot.data.data();
                                return ListTile(
                                  leading: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(datas['imageUrl'])),
                                  title: Text(datas['first_name'].toString()),
                                );
                              } else {
                                return Center(
                                  child: Text(
                                    'Not found  members',
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).iconTheme.color),
                                  ),
                                );
                              }
                            });
                      }),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
