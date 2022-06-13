import 'package:azlistview/azlistview.dart';
import 'package:chatting/logic/Contact/contact_cubit.dart';
import 'package:chatting/main.dart';
import 'package:chatting/model/Fir_contact.dart';
import 'package:chatting/model/owner_admin_add.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:strings/strings.dart';

class AddOwnerwithAdmin extends StatefulWidget {
  static const String routeName = '/AddOwnerwithAdmin';

  static Route route({Map<String, dynamic> Getadd}) {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => AddOwnerwithAdmin(
              Getadd: Getadd,
            ));
  }

  final Map<String, dynamic> Getadd;
  const AddOwnerwithAdmin({Key key, this.Getadd}) : super(key: key);

  @override
  State<AddOwnerwithAdmin> createState() => _AddOwnerwithAdminState();
}

class _AddOwnerwithAdminState extends State<AddOwnerwithAdmin> {
  String myuid;
  int indexs;
  int hight_index = 0;
  bool isChecked = false;

  List mamberlist = [];
  List<String> get_contact_number_list = [];

  var keyboardtype = TextInputType.text;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUID();
  }

  void getUID() {
    setState(() {
      myuid = sharedPreferences.getString('uid');
      get_contact_number_list =
          sharedPreferences.getStringList("contact_number_list");
    });
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
          actions: [
            Theme(
              data: ThemeData(splashColor: Colors.grey),
              child: TextButton(
                  onPressed: mamberlist.isEmpty
                      ? null
                      : () {
                          if (widget.Getadd['type'] == 'owner') {
                            FirebaseFirestore.instance
                                .collection("chat")
                                .doc(widget.Getadd["RoomId"])
                                .update({
                              "owner": FieldValue.arrayUnion(mamberlist)
                            }).then((value) {
                              print(widget.Getadd["RoomId"]);

                              for (var item in mamberlist) {
                                FirebaseFirestore.instance
                                    .collection('user')
                                    .doc(item)
                                    .collection('Friends')
                                    .doc(widget.Getadd["RoomId"])
                                    .set({
                                  "Room_ID": widget.Getadd["RoomId"],
                                  "time": DateTime.now(),
                                  "uid": item
                                });
                                FirebaseFirestore.instance
                                    .collection("chat")
                                    .doc(widget.Getadd["RoomId"])
                                    .collection('OwnerRequest')
                                    .doc(item)
                                    .set({
                                  "ID": item,
                                  "Status": true,
                                }).then((value) => print("done"));
                              }

                              Navigator.of(context).pop();
                            });
                          }
                          if (widget.Getadd['type'] == 'admin') {
                            FirebaseFirestore.instance
                                .collection("chat")
                                .doc(widget.Getadd["RoomId"])
                                .update({
                              "admin": FieldValue.arrayUnion(mamberlist)
                            }).then((value) {
                              print(widget.Getadd["RoomId"]);
                              for (var item in mamberlist) {
                                FirebaseFirestore.instance
                                    .collection('user')
                                    .doc(item)
                                    .collection('Friends')
                                    .doc(widget.Getadd["RoomId"])
                                    .set({
                                  "Room_ID": widget.Getadd["RoomId"],
                                  "time": DateTime.now(),
                                  "uid": item
                                });
                                FirebaseFirestore.instance
                                    .collection("chat")
                                    .doc(widget.Getadd["RoomId"])
                                    .collection('AdminRequest')
                                    .doc(item)
                                    .set({
                                  "ID": item,
                                  "Status": true,
                                }).then((value) => print("done"));
                              }

                              Navigator.of(context).pop();
                            });
                          }
                        },
                  child: Text(
                    "Add",
                    style: TextStyle(
                        color: Theme.of(context).iconTheme.color,
                        fontWeight: FontWeight.w500),
                  )),
            ),
          ],
          centerTitle: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          title: Column(children: [
            Text(
              widget.Getadd['type'] == 'admin' ? "Add Admin" : "Add Owner",
              style: TextStyle(
                  color: Theme.of(context).iconTheme.color,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              "${mamberlist.length}/${hight_index}",
              style: TextStyle(color: Colors.grey),
            )
          ]),
        ),
        body: Container(
          child: BlocBuilder<ContactCubit, ContactState>(
            builder: (context, state) {
              if (state is hasContactdata) {
                hight_index = 0;
                SuspensionUtil.sortListBySuspensionTag(state.data);
                SuspensionUtil.setShowSuspensionStatus(state.data);
                state.data.insert(
                    0, GetFireContactList(lastName: "header", tag: '↑'));
                return AzListView(
                  padding: EdgeInsets.all(10),
                  data: state.data,
                  itemCount: state.data.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (state.data[index].phoneNumber != null) {
                      if (get_contact_number_list.contains(state
                              .data[index].phoneNumber
                              .split("+88")[1]
                              .trim()) ||
                          get_contact_number_list
                              .contains(state.data[index].phoneNumber)) {
                        var item_data = state.data[index].getSuspensionTag();
                        final offstage = !state.data[index].isShowSuspension;
                        bool is_seleted = mamberlist
                            .contains(state.data[index].phoneNumber.trim());

                        hight_index += 1;

                        return Column(
                          children: [
                            Offstage(
                              offstage: offstage,
                              child: Container(
                                height: 10.w,
                                margin: EdgeInsets.only(right: 16),
                                padding: EdgeInsets.only(left: 16),
                                alignment: Alignment.centerLeft,
                                // decoration: BoxDecoration(
                                //   color: isDarkMode
                                //       ? HexColor.fromHex("#1a1a1c")
                                //       : Colors.grey.shade300,
                                //   borderRadius: BorderRadius.circular(5.sp),
                                // ),
                                child: Row(
                                  children: [
                                    Text(
                                      "$item_data",
                                      softWrap: false,
                                      style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: ListTile(
                                onTap: () {
                                  bool is_seleted = mamberlist
                                      .contains(state.data[index].phoneNumber);
                                  print(is_seleted);
                                  setState(() => is_seleted
                                      ? mamberlist
                                          .remove(state.data[index].phoneNumber)
                                      : mamberlist
                                          .add(state.data[index].phoneNumber));
                                },
                                leading: state.data[index].imageUrl
                                        .contains("https://")
                                    ? CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            state.data[index].imageUrl),
                                      )
                                    : ProfilePicture(
                                        name: state.data[index].imageUrl.trim(),
                                        radius: 20,
                                        fontsize: 15),
                                subtitle: Text(
                                  state.data[index].phoneNumber,
                                  style: TextStyle(color: Colors.grey),
                                ),
                                trailing: is_seleted
                                    ? SvgPicture.asset(
                                        'assets/svg/check_is.svg',
                                        width: 5.w,
                                      )
                                    : SvgPicture.asset(
                                        'assets/svg/oval.svg',
                                        color:
                                            Theme.of(context).iconTheme.color,
                                        width: 5.w,
                                      ),
                                title: Text(
                                    "${capitalize(state.data[index].firstName)} ${state.data[index].lastName}"),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Center();
                      }
                    } else {
                      return Center();
                    }
                  },
                  // indexHintBuilder: (context, hint) {
                  //   return Container(
                  //     alignment: Alignment.center,
                  //     height: 60,
                  //     width: 60,
                  //     decoration: BoxDecoration(
                  //       color: Theme.of(context).secondaryHeaderColor,
                  //       shape: BoxShape.circle,
                  //     ),
                  //     child: Text(hint),
                  //   );
                  // },

                  indexBarMargin: EdgeInsets.all(10),
                  indexBarOptions: IndexBarOptions(
                      needRebuild: true,
                      indexHintAlignment: Alignment.centerRight,
                      indexHintOffset: Offset(-20, 0),
                      selectTextStyle: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontWeight: FontWeight.bold),
                      selectItemDecoration: BoxDecoration(
                          color: Theme.of(context).iconTheme.color,
                          shape: BoxShape.circle)),
                );
              } else {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              }
            },
          ),
        ));
  }
}
