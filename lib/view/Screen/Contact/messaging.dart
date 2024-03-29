// import 'package:chat_composer/chat_composer.dart';
// import 'package:chatting/Helper/color.dart';
// import 'package:chatting/Helper/config.dart';
// import 'package:chatting/logic/Profile_data_get/read_data_cubit.dart';
// import 'package:chatting/logic/photo_upload/photoupload_cubit.dart';
// import 'package:chatting/logic/send_message/send_message_cubit.dart';

// import 'package:chatting/main.dart';
// import 'package:http/http.dart' as http;

// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:chatting/view/widget/widget.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_profile_picture/flutter_profile_picture.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:getwidget/getwidget.dart';
// import 'package:google_place/google_place.dart';
// import 'package:intl/intl.dart';

// import 'package:sizer/sizer.dart';
// import 'package:yelp_fusion_client/models/business_endpoints/business_details.dart';

// class Messageing extends StatefulWidget {
//   static const String routeName = '/messageing';

//   static Route route({Map<dynamic, dynamic> data}) {
//     return MaterialPageRoute(
//         settings: RouteSettings(name: routeName),
//         builder: (_) => Messageing(
//               data: data,
//             ));
//   }

//   const Messageing({
//     Key key,
//     this.data,
//   }) : super(key: key);

//   final Map<dynamic, dynamic> data;

//   @override
//   State<Messageing> createState() => _MessageingState();
// }

// class _MessageingState extends State<Messageing> with WidgetsBindingObserver {
//   TextEditingController messaage;
//   ScrollController scrollController = ScrollController();
//   String lates_message;

//   Map<String, dynamic> message_list;
//   final get_message = FirebaseFirestore.instance.collection('chat');
//   String myUID;
//   String frienduid;
//   String Type;
//   List mamberList;
//   bool message_seen;
//   bool michide = false, texthide = false;
//   String _DayName = '';

//   @override
//   void initState() {
//     WidgetsBinding.instance.addObserver(this);
//     messaage = TextEditingController();
//     messaage.addListener(() {
//       try {
//         print(messaage.value.text);

//         FirebaseFirestore.instance
//             .collection("chat")
//             .doc(frienduid)
//             .collection("message_typing")
//             .doc("typing")
//             .set({"typing": true, "typing_user": myUID});
//       } catch (e) {
//         print(e.toString());
//       }
//     });
//     super.initState();
//     getUID();
//     message_status();
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     try {
//       messaage.dispose();
//     } catch (e) {}
//     super.dispose();
//   }

//   void message_status() async {
//     String Room_ID = widget.data['Single_Room_ID'] ?? widget.data['otheruid'];
//     try {
//       await FirebaseFirestore.instance
//           .collection("chat")
//           .doc(Room_ID)
//           .collection("message")
//           .where("sender", isNotEqualTo: myUID)
//           .get()
//           .then((QuerySnapshot snapshot) {
//         print(frienduid);
//         setState(() {
//           for (var element in snapshot.docs) {
//             bool read_dara = element['read'];
//             if (read_dara == false) {
//               FirebaseFirestore.instance
//                   .collection("chat")
//                   .doc(Room_ID)
//                   .collection("message")
//                   .doc(element.id)
//                   .update({"read": true});
//             }
//           }
//         });
//       });
//     } on FirebaseFirestore catch (e) {
//       setState(() {
//         print(e.toString());
//       });
//     }
//   }

//   void getUID() async {
//     setState(() {
//       frienduid = widget.data['Single_Room_ID'] ?? widget.data['otheruid'];
//       Type = widget.data['type'];
//       mamberList = widget.data['mamber_list'];
//       context
//           .read<ReadDataCubit>()
//           .getprofile_data(uid: widget.data['otheruid'], type: Type);
//     });

//     setState(() {
//       myUID = sharedPreferences.getString('uid');

//       print("------------------------------------------------");
//       print(
//           "Message page UID Data $frienduid With Type ${widget.data['type']}");
//       print("------------------------------------------------");
//       print(widget.data['Single_Room_ID'] ?? "Is Group");
//     });
//     // stream.delayed(Duration(milliseconds: 250), () {
//     //   _scrollDown();
//     // });
//   }

//   void messagesend({String message, String message_type}) async {
//     if (Type == 'chat') {
//       FocusManager.instance.primaryFocus?.unfocus();
//       context.read<SendMessageCubit>().send_message(
//         RoomID: frienduid,
//         message: message,
//         sender: myUID,
//         myuid: myUID,
//         message_type: message_type,
//         type: widget.data['type'],
//         other_uid: widget.data['otheruid'],
//         users: [myUID, widget.data['otheruid']],
//       );
//       print(frienduid);
//     } else if (Type == 'group') {
//       print("Room ID $frienduid");
//       // FocusManager.instance.primaryFocus?.unfocus();
//       context.read<SendMessageCubit>().send_message(
//             RoomID: frienduid,
//             message: message,
//             sender: myUID,
//             message_type: message_type,
//             type: widget.data['type'],
//             users: mamberList,
//           );
//     } else if (Type == 'business') {
//       print("Business ID $mamberList");
//       // FocusManager.instance.primaryFocus?.unfocus();
//       context.read<SendMessageCubit>().send_message(
//             RoomID: frienduid,
//             message: message,
//             sender: myUID,
//             message_type: message_type,
//             type: widget.data['type'],
//             users: mamberList,
//           );
//     }

//     setState(() {
//       messaage.clear();
//     });
//   }

//   void _scrollDown() {
//     if (scrollController.hasClients) {
//       scrollController.jumpTo(scrollController.position.maxScrollExtent);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     message_status();
//     var brightness = MediaQuery.of(context).platformBrightness;
//     bool isDarkMode = brightness == Brightness.dark;
//     final Widget emptyBlock = Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           GestureDetector(
//             onLongPress: () {
//               // Long Press event add Later
//             },
//             child: CircleAvatar(),
//           ),
//           Flexible(
//             child: Container(
//               margin: const EdgeInsets.symmetric(
//                 horizontal: 10,
//               ),
//               constraints: BoxConstraints(maxWidth: 60.w),
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                   color: isDarkMode
//                       ? HexColor.fromHex("#1a1a1c")
//                       : HexColor.fromHex("#f2f5f6"),
//                   borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30),
//                       bottomRight: Radius.circular(30))),
//               child: Container(
//                 width: MediaQuery.of(context).size.width * 0.25,
//                 height: 8,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           Container(
//             width: MediaQuery.of(context).size.width * 0.25,
//             height: 8,
//             color: Colors.white,
//           ),
//         ],
//       ),
//     );

//     return BlocBuilder<ReadDataCubit, ReadDataState>(
//         builder: (context, getdatadate) {
//       if (getdatadate is Loadingstate) {
//         return Center(
//           child: CupertinoActivityIndicator(
//               color: Theme.of(context).iconTheme.color),
//         );
//       } else if (getdatadate is GroupData) {
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///Group Chat Start
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         return Container(
//           decoration: BoxDecoration(
//               image: DecorationImage(
//                   fit: BoxFit.cover,
//                   image: isDarkMode
//                       ? const AssetImage('assets/image/Black_Background.png')
//                       : const AssetImage('assets/svg/White_Background.png'))),
//           child: Scaffold(
//               backgroundColor: Colors.transparent,
//               appBar: AppBar(
//                 iconTheme:
//                     IconThemeData(color: Theme.of(context).iconTheme.color),
//                 backgroundColor: Theme.of(context).secondaryHeaderColor,
//                 centerTitle: true,
//                 title: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       getdatadate.group_data_get.groupName,
//                       style: TextStyle(
//                           color: Theme.of(context).iconTheme.color,
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.w600),
//                     ),
//                     StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//                         stream: FirebaseFirestore.instance
//                             .collection('chat')
//                             .doc(frienduid)
//                             .collection('message_typing')
//                             .doc('typing')
//                             .snapshots(),
//                         builder: (context, snapshot) {
//                           if (snapshot.hasData) {
//                             Map<String, dynamic> typing_data =
//                                 snapshot.data.data();

//                             return typing_data['typing_user'] != myUID &&
//                                     typing_data['typing'] == true
//                                 ? Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Image.asset(
//                                         "assets/image/typing.gif",
//                                         width: 5.w,
//                                         fit: BoxFit.cover,
//                                       ),
//                                       Text(
//                                         "Typing",
//                                         style: TextStyle(
//                                             color: Colors.blue,
//                                             fontSize: 10.sp),
//                                       ),
//                                     ],
//                                   )
//                                 : Text(
//                                     "Group",
//                                     style: TextStyle(
//                                         color: Colors.blue, fontSize: 10.sp),
//                                   );
//                           } else {
//                             return Container();
//                           }
//                         }),
//                   ],
//                 ),
//                 actions: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.of(context)
//                             .pushNamed('/group_profile', arguments: frienduid);

//                         print(frienduid);
//                       },
//                       child: CircleAvatar(
//                         backgroundImage:
//                             NetworkImage(getdatadate.group_data_get.groupImage),
//                         maxRadius: 15.sp,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//                   stream: FirebaseFirestore.instance
//                       .collection('user')
//                       .doc(myUID)
//                       .collection("Friends")
//                       .doc(frienduid)
//                       .snapshots(),
//                   builder: (context,
//                       AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
//                           getuserRoomID) {
//                     if (getuserRoomID.hasData) {
//                       final room_id = getuserRoomID.data.data();
//                       return Column(
//                         children: [
//                           Expanded(
//                               flex: 6,
//                               child: StreamBuilder<QuerySnapshot>(
//                                   stream: get_message
//                                       .doc(room_id['Room_ID'])
//                                       .collection('message')
//                                       .orderBy('time', descending: false)
//                                       .snapshots(),
//                                   builder: (context, snapshot) {
//                                     if (snapshot.hasData) {
//                                       return SingleChildScrollView(
//                                         reverse: true,
//                                         child: ListView.builder(
//                                             physics:
//                                                 const NeverScrollableScrollPhysics(),
//                                             shrinkWrap: true,
//                                             itemCount:
//                                                 snapshot.data.docs.length,
//                                             itemBuilder: (context, index) {
//                                               DocumentSnapshot data =
//                                                   snapshot.data.docs[index];

//                                               if (data['sender'] != null) {
//                                                 return StreamBuilder<
//                                                         DocumentSnapshot<
//                                                             Map<String,
//                                                                 dynamic>>>(
//                                                     stream: FirebaseFirestore
//                                                         .instance
//                                                         .collection('user')
//                                                         .doc(data['sender'])
//                                                         .snapshots(),
//                                                     builder: (context,
//                                                         AsyncSnapshot<
//                                                                 DocumentSnapshot<
//                                                                     Map<String,
//                                                                         dynamic>>>
//                                                             chat_user_data) {
//                                                       if (chat_user_data
//                                                           .hasError) {
//                                                         return GFShimmer(
//                                                           child: emptyBlock,
//                                                         );
//                                                       } else if (chat_user_data
//                                                           .hasData) {
//                                                         Map<String, dynamic>
//                                                             user_info =
//                                                             chat_user_data.data
//                                                                 .data();
//                                                         return Container();
//                                                       } else {
//                                                         return Container();
//                                                       }
//                                                     });
//                                               } else {
//                                                 return Center(
//                                                   child:
//                                                       CupertinoActivityIndicator(
//                                                           color:
//                                                               Theme.of(context)
//                                                                   .iconTheme
//                                                                   .color),
//                                                 );
//                                               }
//                                             }),
//                                       );
//                                     } else {
//                                       return Container();
//                                     }
//                                   })),
//                           Container(
//                             height: 20.w,
//                             color: Theme.of(context).secondaryHeaderColor,
//                             child: Row(
//                               children: [
//                                 CupertinoButton(
//                                   padding: EdgeInsets.zero,
//                                   child: Icon(
//                                     Icons.add,
//                                     size: 25,
//                                     color: Theme.of(context).iconTheme.color,
//                                   ),
//                                   onPressed: () async {
//                                     final result = await FilePicker.platform
//                                         .pickFiles(
//                                             allowMultiple: false,
//                                             type: FileType.custom,
//                                             allowedExtensions: [
//                                           'png',
//                                           'jpg',
//                                           'gif'
//                                         ]);

//                                     if (result != null) {
//                                       final path = result.files.single.path;
//                                       final name = result.files.single.name;
//                                       context
//                                           .read<PhotouploadCubit>()
//                                           .updateData(path, name, name)
//                                           .then(
//                                         (value) async {
//                                           String imagurl =
//                                               await firebase_storage
//                                                   .FirebaseStorage.instance
//                                                   .ref('userimage/${name}/')
//                                                   .getDownloadURL();

//                                           if (imagurl != null) {
//                                             setState(() {
//                                               messagesend(
//                                                   message: imagurl,
//                                                   message_type: 'image');
//                                             });
//                                           }
//                                         },
//                                       );
//                                     }
//                                   },
//                                 ),
//                                 Expanded(
//                                   child: Theme(
//                                     data: ThemeData(),
//                                     child: FocusScope(
//                                       child: Focus(
//                                         onFocusChange: (focus) =>
//                                             print("focus: "),
//                                         child: ChatComposer(
//                                           controller: messaage,
//                                           padding: const EdgeInsets.symmetric(
//                                               vertical: 10),
//                                           onReceiveText: (str) {
//                                             setState(() {
//                                               messagesend(
//                                                   message: str,
//                                                   message_type: "text");

//                                               WidgetsBinding.instance
//                                                   .addPostFrameCallback(
//                                                       (_) => _scrollDown());
//                                               messaage.clear();
//                                             });
//                                           },
//                                           onRecordStart: () {
//                                             FirebaseFirestore.instance
//                                                 .collection("chat")
//                                                 .doc(frienduid)
//                                                 .collection("message_typing")
//                                                 .doc("typing")
//                                                 .set({
//                                               "typing": true,
//                                               "typing_user": myUID
//                                             });
//                                           },
//                                           onRecordEnd: (String path) {
//                                             String name = path.split('/').last;

//                                             context
//                                                 .read<PhotouploadCubit>()
//                                                 .updateData(path, name, name)
//                                                 .then((value) async {
//                                               print("Done");
//                                               String voiceurl =
//                                                   await firebase_storage
//                                                       .FirebaseStorage.instance
//                                                       .ref('userimage//')
//                                                       .getDownloadURL();
//                                               print(voiceurl);
//                                               if (voiceurl != null) {
//                                                 setState(() {
//                                                   messagesend(
//                                                       message: voiceurl,
//                                                       message_type: 'voice');
//                                                 });
//                                               }
//                                             });
//                                             FirebaseFirestore.instance
//                                                 .collection("chat")
//                                                 .doc(frienduid)
//                                                 .collection("message_typing")
//                                                 .doc("typing")
//                                                 .set({
//                                               "typing": false,
//                                               "typing_user": myUID
//                                             });
//                                           },
//                                           recordIconColor:
//                                               Theme.of(context).iconTheme.color,
//                                           sendButtonColor:
//                                               Theme.of(context).iconTheme.color,
//                                           backgroundColor: Colors.transparent,
//                                           sendButtonBackgroundColor:
//                                               Colors.transparent,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ],
//                       );
//                     } else {
//                       return Center(
//                         child: CupertinoActivityIndicator(
//                             color: Theme.of(context).iconTheme.color),
//                       );
//                     }
//                   })),
//         );

//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///BUSINESS CHAT START
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//       } else if (getdatadate is BusinessData) {
//         var brightness = MediaQuery.of(context).platformBrightness;
//         bool isDarkMode = brightness == Brightness.dark;
//         return Container(
//           decoration: BoxDecoration(
//               image: DecorationImage(
//                   image: isDarkMode
//                       ? const AssetImage('assets/image/Black_Background.png')
//                       : const AssetImage('assets/image/White_Background.png'),
//                   fit: BoxFit.cover)),
//           child: Scaffold(
//               backgroundColor: Colors.transparent,

//               ///
//               ///
//               ///
//               ///
//               ///AppBar
//               ///
//               ///
//               ///
//               ///
//               appBar: AppBar(
//                 elevation: 0,
//                 shadowColor: Theme.of(context).iconTheme.color.withOpacity(0.5),
//                 automaticallyImplyLeading: false,
//                 backgroundColor: Theme.of(context).secondaryHeaderColor,
//                 leading: IconButton(
//                   onPressed: () {
//                     Navigator.of(context).pushReplacementNamed('/home');
//                   },
//                   icon: SvgPicture.asset(
//                     'assets/svg/left-chevron.svg',
//                     color: Theme.of(context).iconTheme.color,
//                   ),
//                 ),
//                 centerTitle: true,
//                 title: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       getdatadate.business.businessName,
//                       style: TextStyle(
//                           color: Theme.of(context).iconTheme.color,
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.w600),
//                     ),
//                     Text(
//                       getdatadate.business.address,
//                       style: TextStyle(
//                           color: Colors.grey.shade500, fontSize: 10.sp),
//                     ),
//                   ],
//                 ),
//                 actions: [
//                   ///
//                   ///
//                   ///
//                   ///
//                   ///Profile
//                   ///
//                   ///
//                   ///
//                   ///
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.of(context)
//                             .pushNamed('/admin_profile', arguments: frienduid);
//                       },
//                       child: Stack(
//                         children: [
//                           if (getdatadate.business.imageURl
//                               .contains("https://")) ...[
//                             CircleAvatar(
//                               backgroundImage:
//                                   NetworkImage(getdatadate.business.imageURl),
//                               maxRadius: 15.sp,
//                             ),
//                           ] else ...[
//                             ProfilePicture(
//                               name: getdatadate.business.imageURl,
//                               fontsize: 15.sp,
//                             )
//                           ],
//                         ],
//                       ),
//                     ),
//                   ),

//                   ///
//                   ///
//                   ///
//                   ///
//                   ///
//                   ///Profiel END
//                 ],
//               ),
//               body: Container(
//                   child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//                       future: FirebaseFirestore.instance
//                           .collection('user')
//                           .doc(myUID)
//                           .collection("Friend")
//                           .doc(frienduid)
//                           .get(),
//                       builder: (context,
//                           AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
//                               getuserRoomID) {
//                         if (getuserRoomID.hasData) {
//                           final room_id = getuserRoomID.data.data();
//                           return Column(
//                             children: [
//                               Expanded(
//                                 flex: 6,
//                                 child: FutureBuilder<QuerySnapshot>(
//                                   future: get_message
//                                       .doc(room_id['Room_ID'])
//                                       .collection('message')
//                                       .orderBy('time', descending: true)
//                                       .get(),
//                                   builder: (context, snapshot) {
//                                     if (snapshot.hasData) {
//                                       return business_chat(
//                                           Room_Id: room_id['Room_ID'],
//                                           isDarkMode: isDarkMode,
//                                           myUID: myUID,
//                                           snapshot: snapshot);
//                                     } else {
//                                       return Container();
//                                     }
//                                   },
//                                 ),
//                               ),

//                               ///
//                               ///
//                               ///
//                               ///
//                               ///File Update Start
//                               ///
//                               ///
//                               ///
//                               ///
//                               ///
//                             ],
//                           );
//                         } else {
//                           return Center(
//                             child: CupertinoActivityIndicator(
//                                 color: Theme.of(context).iconTheme.color),
//                           );
//                         }
//                       }))),
//         );

//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///PROFILE CHAT START
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//         ///
//       } else if (getdatadate is getprofileData) {
//         return Scaffold(
//           backgroundColor: Colors.transparent,
//           appBar: AppBar(
//             elevation: 0,
//             automaticallyImplyLeading: false,
//             backgroundColor: Theme.of(context).secondaryHeaderColor,
//             leading: IconButton(
//               onPressed: () {
//                 Navigator.of(context).pushReplacementNamed('/home');
//               },
//               icon: SvgPicture.asset(
//                 'assets/svg/left-chevron.svg',
//                 color: Theme.of(context).iconTheme.color,
//               ),
//             ),
//             centerTitle: true,
//             title: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   getdatadate.profile_data.fullName,
//                   style: TextStyle(
//                       color: Theme.of(context).iconTheme.color,
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w600),
//                 ),
//                 StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//                     stream: FirebaseFirestore.instance
//                         .collection('chat')
//                         .doc(frienduid)
//                         .collection('message_typing')
//                         .doc('typing')
//                         .snapshots(),
//                     builder: (context, snapshot) {
//                       if (snapshot.hasData) {
//                         Map<String, dynamic> typing_data = snapshot.data.data();

//                         return typing_data['typing_user'] != myUID &&
//                                 typing_data['typing'] == true
//                             ? Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Image.asset(
//                                     "assets/image/typing.gif",
//                                     width: 5.w,
//                                     fit: BoxFit.cover,
//                                   ),
//                                   Text(
//                                     "Typing",
//                                     style: TextStyle(
//                                         color: Colors.blue, fontSize: 10.sp),
//                                   ),
//                                 ],
//                               )
//                             : Text(
//                                 getdatadate.profile_data.userStatus,
//                                 style: TextStyle(
//                                     color:
//                                         getdatadate.profile_data.userStatus ==
//                                                 'online'
//                                             ? Colors.green
//                                             : Colors.grey,
//                                     fontSize: 10.sp),
//                               );
//                       } else {
//                         return Container();
//                       }
//                     }),
//               ],
//             ),
//             actions: [
//               if (getdatadate.profile_data.imageUrl.contains("https://")) ...[
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: CircleAvatar(
//                     backgroundImage:
//                         NetworkImage(getdatadate.profile_data.imageUrl),
//                     maxRadius: 15.sp,
//                   ),
//                 ),
//               ] else ...[
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: ProfilePicture(
//                     name: getdatadate.profile_data.imageUrl.trim(),
//                     radius: 20,
//                     fontsize: 12.sp,
//                   ),
//                 )
//               ],
//             ],
//           ),
//           body: SafeArea(
//               child: Container(
//             decoration: BoxDecoration(
//                 image: DecorationImage(
//                     image: isDarkMode
//                         ? const AssetImage('assets/image/Black_Background.png')
//                         : const AssetImage('assets/svg/White_Background.png'),
//                     fit: BoxFit.cover)),
//             child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//                 stream: FirebaseFirestore.instance
//                     .collection('user')
//                     .doc(myUID)
//                     .collection("Friends")
//                     .doc(frienduid.trim())
//                     .snapshots(),
//                 builder: (context,
//                     AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
//                         getuserRoomID) {
//                   if (getuserRoomID.hasData) {
//                     final room_id = getuserRoomID.data.data();
//                     return Column(
//                       children: [
//                         Expanded(
//                             flex: 6,
//                             child: StreamBuilder<QuerySnapshot>(
//                                 stream: get_message
//                                     .doc(frienduid)
//                                     .collection('message')
//                                     .orderBy('time', descending: false)
//                                     .snapshots(),
//                                 builder: (context, snapshot) {
//                                   if (snapshot.hasData) {
//                                     return SingleChildScrollView(
//                                       // controller: scrollController,
//                                       reverse: true,
//                                       child: ListView.builder(
//                                           shrinkWrap: true,
//                                           physics:
//                                               NeverScrollableScrollPhysics(),
//                                           itemCount: snapshot.data.docs.length,
//                                           itemBuilder: (context, index) {
//                                             DocumentSnapshot data =
//                                                 snapshot.data.docs[index];

//                                             if (data['sender'] != null) {
//                                               return StreamBuilder<
//                                                   DocumentSnapshot<
//                                                       Map<String, dynamic>>>(
//                                                 stream: FirebaseFirestore
//                                                     .instance
//                                                     .collection('user')
//                                                     .doc(data['sender'])
//                                                     .snapshots(),
//                                                 builder: (context,
//                                                     AsyncSnapshot<
//                                                             DocumentSnapshot<
//                                                                 Map<String,
//                                                                     dynamic>>>
//                                                         chat_user_data) {
//                                                   if (chat_user_data.hasError) {
//                                                     return Container();
//                                                   } else if (chat_user_data
//                                                       .hasData) {
//                                                     Map<String, dynamic>
//                                                         user_info =
//                                                         chat_user_data.data
//                                                             .data();

//                                                     return messageing_widget(
//                                                       data: data,
//                                                       myUID: myUID,
//                                                       RoomID: frienduid.trim(),
//                                                       profile_data: user_info,
//                                                     );
//                                                   } else {
//                                                     return Container();
//                                                   }
//                                                 },
//                                               );
//                                             } else {
//                                               return Center(
//                                                 child:
//                                                     CupertinoActivityIndicator(
//                                                         color: Theme.of(context)
//                                                             .iconTheme
//                                                             .color),
//                                               );
//                                             }
//                                           }),
//                                     );
//                                   } else {
//                                     return Container();
//                                   }
//                                 })),
//                         Container(
//                           height: 20.w,
//                           color: Theme.of(context).secondaryHeaderColor,
//                           child: Row(
//                             children: [
//                               CupertinoButton(
//                                 padding: EdgeInsets.zero,
//                                 child: Icon(
//                                   Icons.add,
//                                   size: 25,
//                                   color: Theme.of(context).iconTheme.color,
//                                 ),
//                                 onPressed: () async {
//                                   final result = await FilePicker.platform
//                                       .pickFiles(
//                                           allowMultiple: false,
//                                           type: FileType.custom,
//                                           allowedExtensions: [
//                                         'png',
//                                         'jpg',
//                                         'gif'
//                                       ]);

//                                   if (result != null) {
//                                     final path = result.files.single.path;
//                                     final name = result.files.single.name;
//                                     context
//                                         .read<PhotouploadCubit>()
//                                         .updateData(path, name, name)
//                                         .then(
//                                       (value) async {
//                                         String imagurl = await firebase_storage
//                                             .FirebaseStorage.instance
//                                             .ref('userimage//')
//                                             .getDownloadURL();

//                                         if (imagurl != null) {
//                                           setState(() {
//                                             messagesend(
//                                                 message: imagurl,
//                                                 message_type: 'image');
//                                           });
//                                         }
//                                       },
//                                     );
//                                   }
//                                 },
//                               ),
//                               Expanded(
//                                 child: Theme(
//                                   data: ThemeData(),
//                                   child: ChatComposer(
//                                     controller: messaage,
//                                     padding: EdgeInsets.symmetric(vertical: 10),
//                                     onReceiveText: (str) {
//                                       setState(() {
//                                         messagesend(
//                                             message: str, message_type: "text");

//                                         WidgetsBinding.instance
//                                             .addPostFrameCallback(
//                                                 (_) => _scrollDown());
//                                         messaage.clear();
//                                       });
//                                     },
//                                     onRecordEnd: (String path) {
//                                       String name = path.split('/').last;

//                                       context
//                                           .read<PhotouploadCubit>()
//                                           .updateData(path, name, name)
//                                           .then((value) async {
//                                         print("Done");
//                                         String voiceurl = await firebase_storage
//                                             .FirebaseStorage.instance
//                                             .ref('userimage//')
//                                             .getDownloadURL();
//                                         print(voiceurl);
//                                         if (voiceurl != null) {
//                                           setState(() {
//                                             messagesend(
//                                                 message: voiceurl,
//                                                 message_type: 'voice');
//                                           });
//                                         }
//                                       });
//                                     },
//                                     recordIconColor:
//                                         Theme.of(context).iconTheme.color,
//                                     sendButtonColor:
//                                         Theme.of(context).iconTheme.color,
//                                     backgroundColor: Colors.transparent,
//                                     sendButtonBackgroundColor:
//                                         Colors.transparent,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     );
//                   } else {
//                     return Center(
//                       child: CupertinoActivityIndicator(
//                           color: Theme.of(context).iconTheme.color),
//                     );
//                   }
//                 }),
//           )),
//         );
//       } else {
//         return Container();
//       }
//     });
//   }
// }
