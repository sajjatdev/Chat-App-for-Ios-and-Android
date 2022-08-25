import 'package:azlistview/azlistview.dart';
import 'package:chatting/Helper/Shimmer.dart';
import 'package:chatting/Helper/color.dart';
import 'package:chatting/logic/Contact/contact_cubit.dart';
import 'package:chatting/main.dart';
import 'package:chatting/model/Fir_contact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:sizer/sizer.dart';
import 'package:strings/strings.dart';

class Seleted_list extends StatefulWidget {
  static const String routeName = '/seleted_members';

  static Route route() {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => Seleted_list());
  }

  const Seleted_list({Key key}) : super(key: key);

  @override
  State<Seleted_list> createState() => _Seleted_listState();
}

class _Seleted_listState extends State<Seleted_list> {
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
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/create_group',
                        arguments: mamberlist);
                  },
                  child: Text(
                    "Next",
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
              "New Members",
              style: TextStyle(
                  color: Theme.of(context).iconTheme.color,
                  fontWeight: FontWeight.w500),
            ),
          ]),
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
        body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection("Contact_list")
                .doc(myuid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic> contact_data = snapshot.data.data();

                List ContactData = contact_data['list_Contact'];

                return Container(
                  child: BlocBuilder<ContactCubit, ContactState>(
                    builder: (context, state) {
                      if (state is hasContactdata) {
                        hight_index = state.data.length;
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
                              if (state.data[index].phoneNumber != null) {
                                if (ContactData.contains(
                                    state.data[index].phoneNumber)) {
                                  var item_data =
                                      state.data[index].getSuspensionTag();
                                  final offstage =
                                      !state.data[index].isShowSuspension;
                                  bool is_seleted = mamberlist.contains(
                                      state.data[index].phoneNumber.trim());

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
                                          onTap: () {
                                            bool is_seleted =
                                                mamberlist.contains(state
                                                    .data[index].phoneNumber);
                                            print(is_seleted);
                                            setState(() => is_seleted
                                                ? mamberlist.remove(state
                                                    .data[index].phoneNumber)
                                                : mamberlist.add(state
                                                    .data[index].phoneNumber));
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
                                          trailing: is_seleted
                                              ? SvgPicture.asset(
                                                  'assets/svg/check_is.svg',
                                                  width: 5.w,
                                                )
                                              : SvgPicture.asset(
                                                  'assets/svg/oval.svg',
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color,
                                                  width: 5.w,
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
                return GFShimmer(child: emptyBlock(context));
              }
            }));
  }
}
