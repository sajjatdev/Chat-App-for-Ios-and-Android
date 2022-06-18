import 'package:chat_composer/chat_composer.dart';
import 'package:chatting/Helper/color.dart';
import 'package:chatting/logic/Profile_data_get/read_data_cubit.dart';
import 'package:chatting/logic/photo_upload/photoupload_cubit.dart';
import 'package:chatting/logic/send_message/send_message_cubit.dart';

import 'package:chatting/main.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:chatting/view/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';

import 'package:sizer/sizer.dart';

class Messageing extends StatefulWidget {
  static const String routeName = '/messageing';

  static Route route({Map<dynamic, dynamic> data}) {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => Messageing(
              data: data,
            ));
  }

  const Messageing({
    Key key,
    this.data,
  }) : super(key: key);

  final Map<dynamic, dynamic> data;

  @override
  State<Messageing> createState() => _MessageingState();
}

class _MessageingState extends State<Messageing> with WidgetsBindingObserver {
  TextEditingController messaage = TextEditingController();
  ScrollController scrollController = ScrollController();
  String lates_message;

  Map<String, dynamic> message_list;
  final get_message = FirebaseFirestore.instance.collection('chat');
  String myUID;
  String frienduid;
  String Type;
  List mamberList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUID();
    WidgetsBinding.instance.addObserver(this);
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) async {
  //   if (state == AppLifecycleState.resumed) {
  //     //message Delivery with See

  //     setState(() {
  //       message_status(status: "see");
  //     });
  //   } else {
  //     message_status(status: "not_see");
  //   }
  // }

  // void message_status({String status}) async {
  //   await FirebaseFirestore.instance
  //       .collection('chat')
  //       .doc(frienduid)
  //       .update({'message_seen': status});
  // }

  @override
  void dispose() {
    // TODO: implement dispose

    messaage.dispose();
    super.dispose();
  }

  void getUID() async {
    setState(() {
      frienduid = widget.data['otheruid'];
      Type = widget.data['type'];
      mamberList = widget.data['mamber_list'];
      context.read<ReadDataCubit>().getprofile_data(uid: frienduid, type: Type);
    });

    setState(() {
      myUID = sharedPreferences.getString('uid');

      print("------------------------------------------------");
      print(
          "Message page UID Data $frienduid With Type ${widget.data['type']}");
      print("------------------------------------------------");
    });
    // stream.delayed(Duration(milliseconds: 250), () {
    //   _scrollDown();
    // });
  }

  void messagesend({String message, String message_type}) async {
    if (Type == 'chat') {
      String Room_ID = myUID + widget.data['otheruid'];
      // FocusManager.instance.primaryFocus?.unfocus();
      context.read<SendMessageCubit>().send_message(
        RoomID: Room_ID,
        message: message,
        sender: myUID,
        myuid: myUID,
        message_type: message_type,
        type: widget.data['type'],
        other_uid: widget.data['otheruid'],
        users: [myUID, widget.data['otheruid']],
      );
    } else if (Type == 'group') {
      print("Room ID $frienduid");
      // FocusManager.instance.primaryFocus?.unfocus();
      context.read<SendMessageCubit>().send_message(
            RoomID: frienduid,
            message: message,
            sender: myUID,
            message_type: message_type,
            type: widget.data['type'],
            users: mamberList,
          );
    } else if (Type == 'business') {
      print("Business ID $mamberList");
      // FocusManager.instance.primaryFocus?.unfocus();
      context.read<SendMessageCubit>().send_message(
            RoomID: frienduid,
            message: message,
            sender: myUID,
            message_type: message_type,
            type: widget.data['type'],
            users: mamberList,
          );
    }

    setState(() {
      messaage.clear();
    });
  }

  void _scrollDown() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }

    // scrollController.animateTo(
    //   scrollController.position.maxScrollExtent,
    //   duration: const Duration(milliseconds: 250),
    //   curve: Curves.fastOutSlowIn,
    // );
  }

  @override
  Widget build(BuildContext context) {
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollDown());
    } catch (e) {
      print(e.toString());
    }

    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    final Widget emptyBlock = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onLongPress: () {
              // Long Press event add Later
            },
            child: CircleAvatar(),
          ),
          Flexible(
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              constraints: BoxConstraints(maxWidth: 60.w),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: isDarkMode
                      ? HexColor.fromHex("#1a1a1c")
                      : HexColor.fromHex("#f2f5f6"),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.25,
                height: 8,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.25,
            height: 8,
            color: Colors.white,
          ),
        ],
      ),
    );

    return Builder(builder: (context) {
      final getdatadate = context.watch<ReadDataCubit>().state;

      if (getdatadate is Loadingstate) {
        return Center(
          child: CupertinoActivityIndicator(
              color: Theme.of(context).iconTheme.color),
        );
      } else if (getdatadate is GroupData) {
        return Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: isDarkMode
                      ? const AssetImage('assets/svg/Black_Background.png')
                      : const AssetImage('assets/svg/White_Background.png'))),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                iconTheme:
                    IconThemeData(color: Theme.of(context).iconTheme.color),
                backgroundColor: Theme.of(context).secondaryHeaderColor,
                centerTitle: true,
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      getdatadate.group_data_get.groupName,
                      style: TextStyle(
                          color: Theme.of(context).iconTheme.color,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      getdatadate.group_data_get.type,
                      style: TextStyle(color: Colors.grey, fontSize: 10.sp),
                    ),
                  ],
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed('/group_profile', arguments: frienduid);

                        print(frienduid);
                      },
                      child: CircleAvatar(
                        backgroundImage:
                            NetworkImage(getdatadate.group_data_get.groupImage),
                        maxRadius: 15.sp,
                      ),
                    ),
                  ),
                ],
              ),
              body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('user')
                      .doc(myUID)
                      .collection("Friends")
                      .doc(frienduid.trim())
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                          getuserRoomID) {
                    if (getuserRoomID.hasData) {
                      final room_id = getuserRoomID.data.data();
                      return Column(
                        children: [
                          Expanded(
                              flex: 6,
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: get_message
                                      .doc(room_id['Room_ID'])
                                      .collection('message')
                                      .orderBy('time', descending: false)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return SingleChildScrollView(
                                        child: ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount:
                                                snapshot.data.docs.length,
                                            itemBuilder: (context, index) {
                                              DocumentSnapshot data =
                                                  snapshot.data.docs[index];

                                              if (data['sender'] != null) {
                                                return StreamBuilder<
                                                        DocumentSnapshot<
                                                            Map<String,
                                                                dynamic>>>(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection('user')
                                                        .doc(data['sender'])
                                                        .snapshots(),
                                                    builder: (context,
                                                        AsyncSnapshot<
                                                                DocumentSnapshot<
                                                                    Map<String,
                                                                        dynamic>>>
                                                            chat_user_data) {
                                                      if (chat_user_data
                                                          .hasError) {
                                                        return GFShimmer(
                                                          child: emptyBlock,
                                                        );
                                                      } else if (chat_user_data
                                                          .hasData) {
                                                        Map<String, dynamic>
                                                            user_info =
                                                            chat_user_data.data
                                                                .data();
                                                        return messageing_widget(
                                                            data: data,
                                                            myUID: myUID,
                                                            profile_data:
                                                                user_info,
                                                            image: getdatadate
                                                                .group_data_get
                                                                .groupImage);
                                                      } else {
                                                        return Container();
                                                      }
                                                    });
                                              } else {
                                                return Center(
                                                  child:
                                                      CupertinoActivityIndicator(
                                                          color:
                                                              Theme.of(context)
                                                                  .iconTheme
                                                                  .color),
                                                );
                                              }
                                            }),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  })),
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () async {
                                      final result = await FilePicker.platform
                                          .pickFiles(
                                              allowMultiple: false,
                                              type: FileType.custom,
                                              allowedExtensions: [
                                            'png',
                                            'jpg',
                                            'gif'
                                          ]);

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

                                          if (imagurl != null) {
                                            setState(() {
                                              messagesend(
                                                  message: imagurl,
                                                  message_type: 'image');
                                            });
                                          }
                                        });
                                      }
                                    },
                                    icon: SvgPicture.asset(
                                      'assets/svg/gallery.svg',
                                      color: Theme.of(context).iconTheme.color,
                                    )),

                                // suffixIcon: IconButton(
                                //       onPressed: () {},
                                //       icon: SvgPicture.asset(
                                //         'assets/svg/smile-3.svg',
                                //         color: Theme.of(context)
                                //             .iconTheme
                                //             .color,
                                //       )),
                                //   hintText: "Write a message...",
                                // style: TextStyle(
                                //   color:
                                //       Theme.of(context).iconTheme.color,
                                //   fontSize: 12.sp),
                                Container(
                                    width: 70.w,
                                    constraints: BoxConstraints(
                                        minHeight: 5.w, maxHeight: 20.w),
                                    child: SingleChildScrollView(
                                      child: DetectableTextField(
                                        controller: messaage,
                                        onChanged: ((value) {
                                          setState(() {
                                            lates_message = value;
                                          });
                                        }),
                                        maxLines: null,
                                        decoration: InputDecoration(
                                          hintText: "New Message",
                                          hintStyle: TextStyle(
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black),
                                          fillColor: isDarkMode
                                              ? HexColor.fromHex("#1a1a1c")
                                              : Colors.grey.shade200,
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                        ),
                                        textInputAction:
                                            TextInputAction.newline,
                                        detectionRegExp: detectionRegExp(),
                                        decoratedStyle: TextStyle(
                                          fontSize: 12.sp,
                                          color: Theme.of(context)
                                              .secondaryHeaderColor,
                                        ),
                                        basicStyle: TextStyle(
                                            fontSize: 12.sp,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color),
                                      ),
                                    )),
                                IconButton(
                                    onPressed: () {
                                      if (lates_message != null) {
                                        setState(() {
                                          messagesend(
                                              message: messaage.text,
                                              message_type: 'text');
                                        });
                                      }
                                    },
                                    icon: SvgPicture.asset(
                                      'assets/svg/send.svg',
                                      color: Theme.of(context).iconTheme.color,
                                    )),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Center(
                        child: CupertinoActivityIndicator(
                            color: Theme.of(context).iconTheme.color),
                      );
                    }
                  })),
        );
      } else if (getdatadate is BusinessData) {
        var brightness = MediaQuery.of(context).platformBrightness;
        bool isDarkMode = brightness == Brightness.dark;
        DateTime now = DateTime.now();
        DateFormat formatter = DateFormat('EEEE');
        DateFormat current_time = DateFormat('H:mm');
        String formatted = formatter.format(now);
        String now_time = current_time.format(now);
        var currarry = now_time.split(":");
        int curr_Hour = int.parse(currarry[0]);
        int curr_min = int.parse(currarry[1]);

        print(now_time);
        return Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: isDarkMode
                      ? AssetImage('assets/image/Black_Background.png')
                      : AssetImage('assets/image/White_Background.png'),
                  fit: BoxFit.cover)),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                elevation: 0,
                shadowColor: Theme.of(context).iconTheme.color.withOpacity(0.5),
                automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).secondaryHeaderColor,
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/home');
                  },
                  icon: SvgPicture.asset(
                    'assets/svg/left-chevron.svg',
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                centerTitle: true,
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      getdatadate.business.businessName,
                      style: TextStyle(
                          color: Theme.of(context).iconTheme.color,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      getdatadate.business.address,
                      style: TextStyle(
                          color: Colors.grey.shade500, fontSize: 10.sp),
                    ),
                  ],
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed('/admin_profile', arguments: frienduid);
                      },
                      child: Stack(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(getdatadate.business.imageURl),
                            maxRadius: 15.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              body: Container(
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('chat')
                        .doc(frienduid)
                        .collection('Business_Hours')
                        .doc(formatted)
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.hasData) {
                        Map<String, dynamic> hours = snapshot.data.data();
                        // Open and Time Format Start

                        DateTime op = DateFormat('hh:mm a').parseLoose(
                            hours['open'] == "off" ||
                                    hours['open'] == '24 Hours'
                                ? "00:00 AM"
                                : hours['open']);
                        DateFormat openformat = DateFormat('H:mm');
                        String openHours = openformat.format(op);

                        var opsarry = openHours.split(":");
                        int Open_Hour = int.parse(opsarry[0]);
                        int Open_min = int.parse(opsarry[1]);
                        // Open and Time Format End
                        // Open and Time Format Start
                        DateTime cls = DateFormat('hh:mm a').parseLoose(
                            hours['cls'] == "off" || hours['cls'] == '24 Hours'
                                ? "00:00 AM"
                                : hours['cls']);
                        DateFormat clsformat = DateFormat('H:mm');
                        String clsHours = openformat.format(cls);
                        var clsarry = clsHours.split(":");
                        int cls_Hour = int.parse(clsarry[0]);
                        int cls_min = int.parse(clsarry[1]);
                        // Open and Time Format End

                        if (((Open_Hour <= curr_Hour &&
                                    cls_Hour >= curr_Hour) ||
                                (Open_Hour == 0 || cls_Hour == 0) ||
                                (hours['open'] == "24 Hours" ||
                                    hours['cls'] == "24 Hours")) &&
                            (hours['open'] != 'off' || hours['cls'] != 'off')) {
                          if ((Open_Hour == curr_Hour
                                  ? Open_min <= curr_min
                                  : true) ||
                              (cls_Hour == curr_Hour
                                  ? cls_min <= curr_min
                                  : true)) {
                            return StreamBuilder<
                                    DocumentSnapshot<Map<String, dynamic>>>(
                                stream: FirebaseFirestore.instance
                                    .collection('user')
                                    .doc(myUID)
                                    .collection("Friends")
                                    .doc(frienduid.trim())
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<
                                            DocumentSnapshot<
                                                Map<String, dynamic>>>
                                        getuserRoomID) {
                                  if (getuserRoomID.hasData) {
                                    final room_id = getuserRoomID.data.data();
                                    return Column(
                                      children: [
                                        Expanded(
                                          flex: 6,
                                          child: StreamBuilder<QuerySnapshot>(
                                            stream: get_message
                                                .doc(room_id['Room_ID'])
                                                .collection('message')
                                                .orderBy('time',
                                                    descending: false)
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return business_chat(
                                                    Room_Id: room_id['Room_ID'],
                                                    isDarkMode: isDarkMode,
                                                    myUID: myUID,
                                                    snapshot: snapshot);
                                              } else {
                                                return Container();
                                              }
                                            },
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          child: ChatComposer(
                                            controller: messaage,
                                            onReceiveText: (str) {
                                              setState(() {
                                                messagesend(
                                                    message: str,
                                                    message_type: "text");

                                                WidgetsBinding.instance
                                                    .addPostFrameCallback(
                                                        (_) => _scrollDown());
                                                messaage.clear();
                                              });
                                            },
                                            onRecordEnd: (String path) {
                                              String name =
                                                  path.split('/').last;

                                              context
                                                  .read<PhotouploadCubit>()
                                                  .updateData(path, name, name)
                                                  .then((value) async {
                                                print("Done");
                                                String voiceurl =
                                                    await firebase_storage
                                                        .FirebaseStorage
                                                        .instance
                                                        .ref(
                                                            'userimage/${name}/${name}')
                                                        .getDownloadURL();
                                                print(voiceurl);
                                                if (voiceurl != null) {
                                                  setState(() {
                                                    messagesend(
                                                        message: voiceurl,
                                                        message_type: 'voice');
                                                  });
                                                }
                                              });
                                            },
                                            textPadding: EdgeInsets.zero,
                                            leading: CupertinoButton(
                                              padding: EdgeInsets.zero,
                                              child: const Icon(
                                                Icons.insert_emoticon_outlined,
                                                size: 25,
                                                color: Colors.grey,
                                              ),
                                              onPressed: () {},
                                            ),
                                            recordIconColor: Theme.of(context)
                                                .secondaryHeaderColor,
                                            sendButtonColor: Theme.of(context)
                                                .secondaryHeaderColor,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            backgroundColor: Colors.transparent,
                                            sendButtonBackgroundColor:
                                                Theme.of(context)
                                                    .iconTheme
                                                    .color,
                                            actions: [
                                              // CupertinoButton(
                                              //   padding: EdgeInsets.zero,
                                              //   child: const Icon(
                                              //     Icons.attach_file_rounded,
                                              //     size: 25,
                                              //     color: Colors.grey,
                                              //   ),
                                              //   onPressed: () {},
                                              // ),
                                              CupertinoButton(
                                                padding: EdgeInsets.zero,
                                                child: const Icon(
                                                  Icons.image,
                                                  size: 25,
                                                  color: Colors.grey,
                                                ),
                                                onPressed: () async {
                                                  final result = await FilePicker
                                                      .platform
                                                      .pickFiles(
                                                          allowMultiple: false,
                                                          type: FileType.custom,
                                                          allowedExtensions: [
                                                        'png',
                                                        'jpg',
                                                        'gif'
                                                      ]);

                                                  if (result != null) {
                                                    final path = result
                                                        .files.single.path;
                                                    final name = result
                                                        .files.single.name;
                                                    context
                                                        .read<
                                                            PhotouploadCubit>()
                                                        .updateData(
                                                            path, name, name)
                                                        .then(
                                                      (value) async {
                                                        String imagurl =
                                                            await firebase_storage
                                                                .FirebaseStorage
                                                                .instance
                                                                .ref(
                                                                    'userimage/${name}/${name}')
                                                                .getDownloadURL();

                                                        if (imagurl != null) {
                                                          setState(() {
                                                            messagesend(
                                                                message:
                                                                    imagurl,
                                                                message_type:
                                                                    'image');
                                                          });
                                                        }
                                                      },
                                                    );
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Center(
                                      child: CupertinoActivityIndicator(
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color),
                                    );
                                  }
                                });
                          } else {
                            return Container(
                              height: double.infinity,
                              width: double.infinity,
                              color: Theme.of(context).secondaryHeaderColor,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10.w,
                                    ),
                                    Text(
                                      "We’re closed,\nsorry! ",
                                      style: TextStyle(
                                          fontSize: 25.sp,
                                          color:
                                              Theme.of(context).iconTheme.color,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 20.w,
                                    ),
                                    Center(
                                      child: SvgPicture.asset(
                                          'assets/svg/closed_sign.svg'),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                        } else {
                          return Container(
                            height: double.infinity,
                            width: double.infinity,
                            color: Theme.of(context).secondaryHeaderColor,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10.w,
                                  ),
                                  Text(
                                    "We’re closed,\nsorry! ",
                                    style: TextStyle(
                                        fontSize: 25.sp,
                                        color:
                                            Theme.of(context).iconTheme.color,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 20.w,
                                  ),
                                  Center(
                                    child: SvgPicture.asset(
                                        'assets/svg/closed_sign.svg'),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                      } else {
                        return Center(
                          child: CupertinoActivityIndicator(
                              color: Theme.of(context).iconTheme.color),
                        );
                      }
                    }),
              )),
        );
      } else if (getdatadate is getprofileData) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/home');
              },
              icon: SvgPicture.asset(
                'assets/svg/left-chevron.svg',
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            centerTitle: true,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  getdatadate.profile_data.fullName,
                  style: TextStyle(
                      color: Theme.of(context).iconTheme.color,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  getdatadate.profile_data.userStatus,
                  style: TextStyle(
                      color: getdatadate.profile_data.userStatus == 'online'
                          ? Colors.green
                          : Colors.grey,
                      fontSize: 10.sp),
                ),
              ],
            ),
            actions: [
              if (getdatadate.profile_data.imageUrl.contains("https://")) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CircleAvatar(
                    backgroundImage:
                        NetworkImage(getdatadate.profile_data.imageUrl),
                    maxRadius: 15.sp,
                  ),
                ),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ProfilePicture(
                    name: getdatadate.profile_data.imageUrl.trim(),
                    radius: 20,
                    fontsize: 12.sp,
                  ),
                )
              ],
            ],
          ),
          body: SafeArea(
              child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('user')
                      .doc(myUID)
                      .collection("Friends")
                      .doc(frienduid.trim())
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                          getuserRoomID) {
                    if (getuserRoomID.hasData) {
                      final room_id = getuserRoomID.data.data();
                      return Column(
                        children: [
                          Expanded(
                              flex: 6,
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: get_message
                                      .doc(room_id['Room_ID'])
                                      .collection('message')
                                      .orderBy('time', descending: false)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return ListView.builder(
                                          controller: scrollController,
                                          shrinkWrap: true,
                                          itemCount: snapshot.data.docs.length,
                                          itemBuilder: (context, index) {
                                            DocumentSnapshot data =
                                                snapshot.data.docs[index];

                                            if (data['sender'] != null) {
                                              return StreamBuilder<
                                                  DocumentSnapshot<
                                                      Map<String, dynamic>>>(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('user')
                                                    .doc(data['sender'])
                                                    .snapshots(),
                                                builder: (context,
                                                    AsyncSnapshot<
                                                            DocumentSnapshot<
                                                                Map<String,
                                                                    dynamic>>>
                                                        chat_user_data) {
                                                  if (chat_user_data.hasError) {
                                                    return Container();
                                                  } else if (chat_user_data
                                                      .hasData) {
                                                    Map<String, dynamic>
                                                        user_info =
                                                        chat_user_data.data
                                                            .data();

                                                    return messageing_widget(
                                                        data: data,
                                                        myUID: myUID,
                                                        profile_data: user_info,
                                                        image: getdatadate
                                                            .profile_data
                                                            .imageUrl);
                                                  } else {
                                                    return Container();
                                                  }
                                                },
                                              );
                                            } else {
                                              return Center(
                                                child:
                                                    CupertinoActivityIndicator(
                                                        color: Theme.of(context)
                                                            .iconTheme
                                                            .color),
                                              );
                                            }
                                          });
                                    } else {
                                      return Container();
                                    }
                                  })),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () async {
                                      final result = await FilePicker.platform
                                          .pickFiles(
                                              allowMultiple: false,
                                              type: FileType.custom,
                                              allowedExtensions: [
                                            'png',
                                            'jpg',
                                            'gif'
                                          ]);

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

                                          if (imagurl != null) {
                                            print("Image");
                                            setState(() {
                                              messagesend(
                                                  message: imagurl,
                                                  message_type: 'image');
                                            });
                                          }
                                        });
                                      }
                                    },
                                    icon: SvgPicture.asset(
                                      'assets/svg/gallery.svg',
                                      color: Theme.of(context).iconTheme.color,
                                    )),
                                Container(
                                  width: 70.w,
                                  child: TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        lates_message = value;
                                      });
                                    },
                                    controller: messaage,
                                    keyboardType: TextInputType.text,
                                    autocorrect: true,
                                    textInputAction: TextInputAction.newline,
                                    validator: (value) => value.isEmpty
                                        ? "Enter your Value"
                                        : null,
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).iconTheme.color,
                                        fontSize: 12.sp),
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                          onPressed: () {},
                                          icon: SvgPicture.asset(
                                            'assets/svg/smile-3.svg',
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                          )),
                                      hintText: "Write a message...",
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                      hintStyle: TextStyle(
                                          color:
                                              Theme.of(context).iconTheme.color,
                                          fontSize: 12.sp),
                                      fillColor: isDarkMode
                                          ? HexColor.fromHex("#696969")
                                          : HexColor.fromHex("#EEEEEF"),
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          borderSide: BorderSide.none),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          borderSide: BorderSide.none),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          borderSide: BorderSide.none),
                                    ),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      if (lates_message != null) {
                                        setState(() {
                                          messagesend(
                                              message: messaage.text,
                                              message_type: 'text');
                                        });
                                      }
                                    },
                                    icon: SvgPicture.asset(
                                      'assets/svg/send.svg',
                                      color: Theme.of(context).iconTheme.color,
                                    )),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Center(
                        child: CupertinoActivityIndicator(
                            color: Theme.of(context).iconTheme.color),
                      );
                    }
                  })),
        );
      } else {
        return Container();
      }
    });
  }
}

// Send Message event Code

//if (lates_message != null) {
//setState(() {
//messagesend(
//message: messaage.text,
//message_type: 'text');
//});
//}

/// business
///
///

