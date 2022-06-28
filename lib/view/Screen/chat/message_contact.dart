import 'package:azlistview/azlistview.dart';
import 'package:chatting/Helper/Shimmer.dart';
import 'package:chatting/Helper/color.dart';
import 'package:chatting/logic/Contact/contact_cubit.dart';
import 'package:chatting/main.dart';
import 'package:chatting/model/Fir_contact.dart';
import 'package:chatting/view/widget/Full%20Name/Fullname.dart';
import 'package:chatting/view/widget/SearchKey/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:sizer/sizer.dart';
import 'package:strings/strings.dart';
import 'package:uuid/uuid.dart';

class Message_contact extends StatefulWidget {
  static const String routeName = '/message_add';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const Message_contact());
  }

  const Message_contact({Key key}) : super(key: key);

  @override
  State<Message_contact> createState() => _Message_contactState();
}

class _Message_contactState extends State<Message_contact> {
  String myuid;
  var uuid = Uuid();
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

  void myinformation_setup(
      {String myuid, String client, String RoomUID, bool isme}) async {
    if (isme) {
      Map<String, dynamic> data = await FirebaseFirestore.instance
          .collection("user")
          .doc(client)
          .get()
          .then((DocumentSnapshot snapshot) => snapshot.data());
      if (data != null) {
        FirebaseFirestore.instance
            .collection('user')
            .doc(myuid)
            .collection("Friends")
            .doc(client)
            .set({
          "Room_ID": RoomUID,
          "type": "chat",
          "time": DateTime.now().millisecondsSinceEpoch,
          "uid": client,
          "keyword_name": SearchKeyGenerator(
              item: Fullname(
                  firstname: data["first_name"], lastname: data["last_name"])),
          "Phone_keyword": SearchKeyGenerator(item: data['Phone_number']),
        }).then((value) {
          print("Done");
        });
      }
    } else {
      Map<String, dynamic> data = await FirebaseFirestore.instance
          .collection("user")
          .doc(myuid)
          .get()
          .then((DocumentSnapshot snapshot) => snapshot.data());
      if (data != null) {
        FirebaseFirestore.instance
            .collection('user')
            .doc(client)
            .collection("Friends")
            .doc(myuid)
            .set({
          "Room_ID": RoomUID,
          "type": "chat",
          "time": DateTime.now().millisecondsSinceEpoch,
          "uid": myuid,
          "keyword_name": SearchKeyGenerator(
              item: Fullname(
                  firstname: data["first_name"], lastname: data["last_name"])),
          "Phone_keyword": SearchKeyGenerator(item: data['Phone_number']),
        }).then((value) {
          print("Client done");
        });
      }
    }
  }

  Future<String> ChatUID({String myUID, String antherUID}) async {
    List userList = [myUID, antherUID];
    String Roomdata = '';
    bool checkStatus = false;
    Function eq = const DeepCollectionEquality.unordered().equals;

    QuerySnapshot Room_Data = await FirebaseFirestore.instance
        .collection('chat')
        .where("type", isEqualTo: "chat")
        .where('users', arrayContainsAny: [myUID, antherUID]).get();

    if (Room_Data.docs.length > 0) {
      for (var i = 0; i < Room_Data.docs.length; i++) {
        List check_user = Room_Data.docs[i]['users'];

        if (eq(check_user, userList)) {
          setState(() {
            checkStatus = false;
          });
          Roomdata = Room_Data.docs[i].id;
          break;
        } else {
          setState(() {
            checkStatus = true;
          });
        }
      }

      if (checkStatus) {
        Roomdata = "create";
      }
    } else {
      Roomdata = "create";
    }
    return Roomdata != '' ? Roomdata : null;
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/seleted_members');
            },
            leading: Icon(
              Icons.group,
              color: Colors.black,
              size: 20.sp,
            ),
            title: Text(
              "Group Create",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).iconTheme.color),
            ),
          ),
          ListTile(
            onTap: (() {
              Navigator.of(context).pushReplacementNamed('/create_business');
            }),
            leading: Icon(
              Icons.business,
              color: Colors.black,
              size: 20.sp,
            ),
            title: Text(
              "Business Create",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).iconTheme.color),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).popAndPushNamed("/");
              },
              icon: Icon(Icons.arrow_back_ios)),
          actions: [
            PopupMenuButton<int>(
                itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
                      PopupMenuItem<int>(
                          value: 1,
                          child: Text(
                            'Refresh',
                            style: TextStyle(
                                fontSize: 13.sp,
                                color: Theme.of(context).iconTheme.color),
                          )),
                      PopupMenuItem<int>(
                          value: 2,
                          child: Text(
                            'New Group',
                            style: TextStyle(
                                fontSize: 13.sp,
                                color: Theme.of(context).iconTheme.color),
                          )),
                      PopupMenuItem<int>(
                          value: 3,
                          child: Text(
                            'Invite Friend',
                            style: TextStyle(
                                fontSize: 13.sp,
                                color: Theme.of(context).iconTheme.color),
                          )),
                    ],
                onSelected: (int value) async {
                  if (value == 1) {
                    List contact_number_list = [];

                    await ContactsService.getContacts().then((value) {
                      for (var item in value) {
                        if (item.phones.isNotEmpty) {
                          contact_number_list.add(item.phones[0].value);
                        } else {
                          print("null phone number");
                        }
                      }

                      FirebaseFirestore.instance
                          .collection("Contact_list")
                          .doc(myuid)
                          .set({"list_Contact": contact_number_list});
                    });

                    context.read<ContactCubit>().Getallcontactlist(
                          keyword: "none",
                          isSearch: false,
                        );
                  }
                  if (value == 2) {
                    Navigator.of(context)
                        .pushReplacementNamed('/seleted_members');
                  }
                })
          ],
          iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
          title: Text(
            "New message",
            style: TextStyle(color: Theme.of(context).iconTheme.color),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(7.0.h),
              child: Container(
                height: 7.0.h,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: TextField(
                    onChanged: ((String keyword) {
                      setState(() {
                        context.read<ContactCubit>().Getallcontactlist(
                            keyword: keyword,
                            isSearch: true,
                            search_number: keyboardtype == TextInputType.phone
                                ? true
                                : false);
                      });
                    }),
                    style: TextStyle(
                        color: Theme.of(context).iconTheme.color,
                        fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              if (keyboardtype == TextInputType.text) {
                                setState(() {
                                  FocusScope.of(context).unfocus();
                                  keyboardtype = TextInputType.phone;
                                });
                              } else {
                                setState(() {
                                  keyboardtype = TextInputType.text;
                                  FocusScope.of(context).unfocus();
                                });
                              }
                            },
                            icon: Icon(
                              keyboardtype != TextInputType.text
                                  ? Icons.dialpad_outlined
                                  : Icons.keyboard_alt_outlined,
                              color: Theme.of(context).iconTheme.color,
                            )),
                        labelStyle:
                            const TextStyle(fontWeight: FontWeight.bold),
                        hintText: "Search name or number",
                        fillColor: isDarkMode
                            ? HexColor.fromHex("#1a1a1c")
                            : Colors.grey.shade300,
                        filled: true,
                        focusColor: Theme.of(context).iconTheme.color,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.sp),
                            borderSide: BorderSide.none)),
                    keyboardType: keyboardtype,
                  ),
                ),
              )),
        ),
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection("Contact_list")
                .doc(myuid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic> contact_data = snapshot.data.data();

                List ContactData = contact_data['list_Contact'];

                return Container(
                  child: BlocBuilder<ContactCubit, ContactState>(
                    builder: (context, state) {
                      if (state is hasContactdata) {
                        SuspensionUtil.sortListBySuspensionTag(state.data);
                        SuspensionUtil.setShowSuspensionStatus(state.data);
                        state.data.insert(0,
                            GetFireContactList(lastName: "header", tag: '↑'));
                        return AzListView(
                          padding: EdgeInsets.all(10),
                          data: state.data,
                          itemCount: state.data.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (state.data != null) {
                              if (index == 0) return _buildHeader();
                              if (state.data[index].phoneNumber != null) {
                                if (ContactData.contains(
                                    state.data[index].phoneNumber)) {
                                  var item_data =
                                      state.data[index].getSuspensionTag();
                                  final offstage =
                                      !state.data[index].isShowSuspension;
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: ListTile(
                                          onTap: () async {
                                            try {
                                              await ChatUID(
                                                      antherUID: state
                                                          .data[index]
                                                          .phoneNumber,
                                                      myUID: myuid)
                                                  .then((String Room_data) {
                                                if (Room_data != null &&
                                                    Room_data == 'create') {
                                                  String UID = uuid.v4();
                                                  FirebaseFirestore.instance
                                                      .collection('chat')
                                                      .doc(UID)
                                                      .set({
                                                    "Last_message": null,
                                                    "Room_ID": UID,
                                                    "message_type": null,
                                                    "type": "chat",
                                                    "users": [
                                                      state.data[index]
                                                          .phoneNumber,
                                                      myuid
                                                    ],
                                                    "last_update": DateTime
                                                            .now()
                                                        .millisecondsSinceEpoch
                                                  }).then((value) {
                                                    // My Keyword Set
                                                    myinformation_setup(
                                                      RoomUID: UID,
                                                      myuid: myuid,
                                                      client: state.data[index]
                                                          .phoneNumber,
                                                      isme: true,
                                                    );
                                                    // End

                                                    // client Keyword Set

                                                    myinformation_setup(
                                                      RoomUID: UID,
                                                      myuid: myuid,
                                                      client: state.data[index]
                                                          .phoneNumber,
                                                      isme: false,
                                                    );

                                                    Navigator.of(context)
                                                        .pushReplacementNamed(
                                                            '/messageing',
                                                            arguments: {
                                                          'otheruid': state
                                                              .data[index]
                                                              .phoneNumber,
                                                          'Single_Room_ID': UID,
                                                          'type': 'chat',
                                                        });
                                                  });
                                                } else if (Room_data != null &&
                                                    Room_data != 'create') {
                                                  // My Keyword Set
                                                  myinformation_setup(
                                                    RoomUID: Room_data,
                                                    myuid: myuid,
                                                    client: state.data[index]
                                                        .phoneNumber,
                                                    isme: true,
                                                  );
                                                  // End

                                                  // client Keyword Set

                                                  myinformation_setup(
                                                    RoomUID: Room_data,
                                                    myuid: myuid,
                                                    client: state.data[index]
                                                        .phoneNumber,
                                                    isme: false,
                                                  );
                                                  Navigator.of(context)
                                                      .pushReplacementNamed(
                                                          '/messageing',
                                                          arguments: {
                                                        'otheruid': state
                                                            .data[index]
                                                            .phoneNumber,
                                                        "Single_Room_ID":
                                                            Room_data,
                                                        'type': 'chat',
                                                      });
                                                }
                                              });
                                            } on FirebaseFirestore catch (e) {
                                              print(e.toString());
                                            }
                                          },
                                          leading: state.data[index].imageUrl
                                                  .contains("https://")
                                              ? CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      state.data[index]
                                                          .imageUrl),
                                                )
                                              : ProfilePicture(
                                                  name: state
                                                      .data[index].imageUrl
                                                      .trim(),
                                                  radius: 20,
                                                  fontsize: 12.sp),
                                          subtitle: Text(
                                            state.data[index].phoneNumber,
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          trailing: Text(
                                            capitalize(
                                                state.data[index].userStatus),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: state.data[index]
                                                            .userStatus ==
                                                        'offline'
                                                    ? Colors.grey
                                                    : Colors.green),
                                          ),
                                          title: Text(
                                              "${capitalize(state.data[index].firstName)} ${state.data[index].lastName}"),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Container();
                                }
                              } else {
                                return Container();
                              }
                            } else {
                              return GFShimmer(child: emptyBlock(context));
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
                        return GFShimmer(child: emptyBlock(context));
                      }
                    },
                  ),
                );
              } else {
                return Container();
              }
            }));
  }
}
