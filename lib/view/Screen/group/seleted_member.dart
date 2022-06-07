import 'package:azlistview/azlistview.dart';
import 'package:chatting/Helper/color.dart';
import 'package:chatting/logic/Contact/contact_cubit.dart';
import 'package:chatting/main.dart';
import 'package:chatting/model/Fir_contact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(state.data[index].imageUrl),
                                ),
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
