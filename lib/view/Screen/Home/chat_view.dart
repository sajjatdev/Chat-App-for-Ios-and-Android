import 'package:chatting/Helper/Shimmer.dart';
import 'package:chatting/Helper/color.dart';
import 'package:chatting/logic/Contact/contact_cubit.dart';
import 'package:chatting/logic/Get_message_list/get_message_list_cubit.dart';

import 'package:chatting/logic/search/search_cubit.dart';

import 'package:chatting/main.dart';

import 'package:chatting/view/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

class chat_view extends StatefulWidget {
  const chat_view({Key key}) : super(key: key);

  static const String routeName = '/chat_view';

  static Route route() {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName), builder: (_) => chat_view());
  }

  @override
  _chat_viewState createState() => _chat_viewState();
}

class _chat_viewState extends State<chat_view> with WidgetsBindingObserver {
  String myuid = '';
  String search_key = '';
  List<String> contact_number_list = [""];

  TextEditingController search = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUID();
    WidgetsBinding.instance.addObserver(this);
    setStatus(status: 'online');
    Get_contact_lists();
  }

  void Get_contact_lists() async {
    contact_number_list =
        await sharedPreferences.getStringList("contact_number_list");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus(status: 'online');
    } else {
      setStatus(status: 'offline');
    }
  }

  void getUID() async {
    setState(() {
      myuid = sharedPreferences.getString('uid');
      context
          .read<GetMessageListCubit>()
          .get_message_list(myuid: myuid, ischeck: true);
    });
  }

  void setStatus({String status}) async {
    try {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(myuid)
          .update({'userStatus': status});
    } on FirebaseFirestore catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                context.read<ContactCubit>().Getallcontactlist(
                      keyword: "none",
                      isSearch: false,
                    );
                Navigator.of(context).pushNamed('/message_add');
              },
              icon: SvgPicture.asset(
                'assets/svg/edit-3.svg',
                color: Theme.of(context).iconTheme.color,
              ))
        ],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          "Chat",
          style: TextStyle(
              color: Theme.of(context).iconTheme.color,
              fontWeight: FontWeight.bold,
              fontSize: 24.sp),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Container(
              height: 12.w,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  onChanged: (value) {
                    if (value.length > 0) {
                      context.read<GetMessageListCubit>().get_message_list(
                          myuid: myuid, ischeck: false, namekeyword: value);
                    } else {
                      context.read<GetMessageListCubit>().get_message_list(
                          myuid: myuid, ischeck: true, namekeyword: value);
                    }
                  },
                  onFieldSubmitted: (_) {
                    setState(() {
                      context
                          .read<SearchCubit>()
                          .getcontact_list(search: search.text, myUID: myuid);
                    });
                  },
                  textInputAction: TextInputAction.search,
                  controller: search,
                  validator: (value) =>
                      value.isEmpty ? "Enter your Value" : null,
                  style: TextStyle(
                      color: Theme.of(context).iconTheme.color,
                      fontSize: 12.sp),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            search.clear();
                            context
                                .read<GetMessageListCubit>()
                                .get_message_list(
                                  myuid: myuid,
                                  ischeck: true,
                                );
                          });
                        },
                        icon: Icon(
                          Icons.close,
                          color: Theme.of(context).iconTheme.color,
                        )),
                    prefixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            context
                                .read<SearchCubit>()
                                .getcontact_list(search: search.text);
                          });
                        },
                        icon: Icon(
                          Icons.search,
                          color: Theme.of(context).iconTheme.color,
                        )),
                    hintText: "Search",
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    hintStyle: TextStyle(
                        color: Theme.of(context).iconTheme.color,
                        fontSize: 12.sp),
                    fillColor: isDarkMode
                        ? HexColor.fromHex("#696969")
                        : HexColor.fromHex("#EEEEEF"),
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none),
                  ),
                ),
              ),
            )),
      ),
      body: Padding(
          padding:
              EdgeInsets.only(top: 8.sp, left: 5.sp, right: 5.sp, bottom: 0.sp),
          child: BlocBuilder<GetMessageListCubit, GetMessageListState>(
            builder: (context, state) {
              if (state is Loadings) {
                return GFShimmer(
                  child: emptyBlock(context),
                );
              }
              if (state is Message_list) {
                return RefreshIndicator(
                  onRefresh: () async {
                    context
                        .read<GetMessageListCubit>()
                        .get_message_list(myuid: myuid, ischeck: true);
                  },
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: state.contact_list.length,
                      itemBuilder: (context, index) {
                        final data = state.contact_list[index];

                        return Message_user_list(data: data);
                      }),
                );
              } else {
                return const message_widget(icon: 'empty', title: 'Message');
              }
            },
          )),
    );
  }
}
