import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:chatting/Helper/color.dart';
import 'package:chatting/logic/Business_profile/business_profile_cubit.dart';
import 'package:chatting/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

class owner_request extends StatefulWidget {
  static const String routeName = '/owner_request';

  static Route route({String room_Id}) {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => owner_request(
              room_Id: room_Id,
            ));
  }

  owner_request({Key key, this.room_Id}) : super(key: key);
  final String room_Id;
  @override
  State<owner_request> createState() => _owner_requestState();
}

class _owner_requestState extends State<owner_request> {
  String myuid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_group_data(uid: widget.room_Id);
  }

  void get_group_data({String uid}) {
    myuid = sharedPreferences.getString('uid');
    context.read<BusinessProfileCubit>().get_Business_Profile(room_id: uid);
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return BlocBuilder<BusinessProfileCubit, BusinessProfileState>(
      builder: (context, state) {
        if (state is BusinessLoading) {
          return Center(
            child: CupertinoActivityIndicator(
                color: Theme.of(context).iconTheme.color),
          );
        } else if (state is HasData_Business_Profile) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
              title: Text(
                "Members Access",
                style: TextStyle(
                    color: Theme.of(context).iconTheme.color,
                    fontWeight: FontWeight.bold),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 20.sp, vertical: 20.sp),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 5.sp, bottom: 5.sp),
                      child: const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "TRANSFER OWNERSHIP REQUEST",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: isDarkMode
                              ? HexColor.fromHex("#1a1a1c")
                              : HexColor.fromHex("#ffffff"),
                          boxShadow: const [
                            BoxShadow(
                                spreadRadius: 0.5,
                                blurRadius: 0.5,
                                color: Colors.grey)
                          ],
                          borderRadius: BorderRadius.circular(5.sp)),
                      constraints: BoxConstraints(
                          minHeight: 40.w,
                          maxHeight: 60.w,
                          maxWidth: double.infinity,
                          minWidth: double.infinity),
                      child: CustomScrollView(slivers: [
                        SliverAppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          automaticallyImplyLeading: false,
                          actions: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Theme(
                                  data: ThemeData(
                                      splashColor:
                                          Theme.of(context).iconTheme.color),
                                  child: TextButton.icon(
                                      onPressed: () {
                                        showAdaptiveActionSheet(
                                          context: context,

                                          title: Column(
                                            children: [
                                              Text(
                                                "Owner Request",
                                                style: TextStyle(
                                                    fontSize: 18.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20.sp,
                                                    vertical: 10.sp),
                                                child: Text(
                                                  "I would like to become an owner for your Business Hangout",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          androidBorderRadius: 30,
                                          actions: <BottomSheetAction>[
                                            BottomSheetAction(
                                                title: const Text('Send'),
                                                onPressed: () {
                                                  FirebaseFirestore.instance
                                                      .collection('chat')
                                                      .doc(widget.room_Id)
                                                      .collection(
                                                          "OwnerRequest")
                                                      .doc(myuid)
                                                      .set({
                                                    "ID": myuid,
                                                    "Status": false,
                                                    "request_Time":
                                                        DateTime.now()
                                                  }).then((value) {
                                                    FirebaseFirestore.instance
                                                        .collection("chat")
                                                        .doc(widget.room_Id)
                                                        .collection(
                                                            "Request_notification")
                                                        .doc("re")
                                                        .set({"status": true});
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Thank_Page(
                                                                          room_id:
                                                                              widget.room_Id,
                                                                          postion:
                                                                              "Owner",
                                                                        )));
                                                  });
                                                }),
                                          ],
                                          cancelAction: CancelAction(
                                              title: const Text(
                                                  'Cancel')), // onPressed parameter is optional by default will dismiss the ActionSheet
                                        );
                                      },
                                      icon: Icon(
                                        Icons.arrow_back_ios,
                                        color:
                                            Theme.of(context).iconTheme.color,
                                      ),
                                      label: Text(
                                        "Request Access",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color),
                                      )),
                                ),
                              ),
                            )
                          ],
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return FutureBuilder<
                                      DocumentSnapshot<Map<String, dynamic>>>(
                                  future: FirebaseFirestore.instance
                                      .collection('user')
                                      .doc(state.business.owner[index])
                                      .get(),
                                  builder: (context,
                                      AsyncSnapshot<
                                              DocumentSnapshot<
                                                  Map<String, dynamic>>>
                                          snapshot) {
                                    if (snapshot.hasData) {
                                      Map<String, dynamic> admin_data =
                                          snapshot.data.data() as Map;
                                      return ListTile(
                                        leading: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                admin_data['imageUrl'])),
                                        title: Text(admin_data['first_name']),
                                        trailing: Text('Owner',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12.sp)),
                                      );
                                    } else {
                                      return Center(
                                          child: CupertinoActivityIndicator(
                                        color:
                                            Theme.of(context).iconTheme.color,
                                      ));
                                    }
                                  });
                            },
                            childCount: state.business.owner.length,
                          ),
                        ),
                      ]),
                    ),
                    // Admin Request Section end
                    SizedBox(
                      height: 20.w,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.sp, bottom: 5.sp),
                      child: const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "ADMIN REQUEST",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: isDarkMode
                              ? HexColor.fromHex("#1a1a1c")
                              : HexColor.fromHex("#ffffff"),
                          boxShadow: const [
                            BoxShadow(
                                spreadRadius: 0.5,
                                blurRadius: 0.5,
                                color: Colors.grey)
                          ],
                          borderRadius: BorderRadius.circular(5.sp)),
                      constraints: BoxConstraints(
                          minHeight: 40.w,
                          maxHeight: 60.w,
                          maxWidth: double.infinity,
                          minWidth: double.infinity),
                      child: CustomScrollView(slivers: [
                        SliverAppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          automaticallyImplyLeading: false,
                          actions: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Theme(
                                  data: ThemeData(
                                      splashColor:
                                          Theme.of(context).iconTheme.color),
                                  child: TextButton.icon(
                                      onPressed: () {
                                        showAdaptiveActionSheet(
                                          context: context,

                                          title: Column(
                                            children: [
                                              Text(
                                                "Admin Request",
                                                style: TextStyle(
                                                    fontSize: 18.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20.sp,
                                                    vertical: 10.sp),
                                                child: Text(
                                                  "I would like to become an Admin for your Business Hangout",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          androidBorderRadius: 30,
                                          actions: <BottomSheetAction>[
                                            BottomSheetAction(
                                                title: const Text('Send'),
                                                onPressed: () {
                                                  FirebaseFirestore.instance
                                                      .collection('chat')
                                                      .doc(widget.room_Id)
                                                      .collection(
                                                          "AdminRequest")
                                                      .doc(myuid)
                                                      .set({
                                                    "ID": myuid,
                                                    "Status": false,
                                                    "request_Time":
                                                        DateTime.now()
                                                  }).then((value) {
                                                    FirebaseFirestore.instance
                                                        .collection("chat")
                                                        .doc(widget.room_Id)
                                                        .collection(
                                                            "Request_notification")
                                                        .doc("re")
                                                        .set({"status": true});
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Thank_Page(
                                                                          room_id:
                                                                              widget.room_Id,
                                                                          postion:
                                                                              "Admin",
                                                                        )));
                                                  });
                                                }),
                                          ],
                                          cancelAction: CancelAction(
                                              title: const Text(
                                                  'Cancel')), // onPressed parameter is optional by default will dismiss the ActionSheet
                                        );
                                      },
                                      icon: Icon(
                                        Icons.arrow_back_ios,
                                        color:
                                            Theme.of(context).iconTheme.color,
                                      ),
                                      label: Text(
                                        "Request Access",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color),
                                      )),
                                ),
                              ),
                            )
                          ],
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              if (state.business.admin != null) {
                                return FutureBuilder<
                                        DocumentSnapshot<Map<String, dynamic>>>(
                                    future: FirebaseFirestore.instance
                                        .collection('user')
                                        .doc(state.business.admin[index])
                                        .get(),
                                    builder: (context,
                                        AsyncSnapshot<
                                                DocumentSnapshot<
                                                    Map<String, dynamic>>>
                                            snapshot) {
                                      if (snapshot.hasData) {
                                        Map<String, dynamic> admin_data =
                                            snapshot.data.data() as Map;
                                        return ListTile(
                                          leading: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  admin_data['imageUrl'])),
                                          title: Text(admin_data['first_name']),
                                          trailing: Text('Admin',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12.sp)),
                                        );
                                      } else {
                                        return Center(
                                            child: CupertinoActivityIndicator(
                                          color:
                                              Theme.of(context).iconTheme.color,
                                        ));
                                      }
                                    });
                              } else {
                                return Container();
                              }
                            },
                            childCount: state.business.admin != null
                                ? state.business.admin.length
                                : 0,
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Center(
            child: CupertinoActivityIndicator(
                color: Theme.of(context).iconTheme.color),
          );
        }
      },
    );
  }
}

// Thank you Page

class Thank_Page extends StatelessWidget {
  const Thank_Page({Key key, this.room_id, this.postion}) : super(key: key);
  final String room_id;
  final String postion;
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pop();
    });
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/svg/celebration.svg'),
            Text(
              "Padding your ${postion} Request",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
            )
          ],
        ),
      ),
    );
  }
}
