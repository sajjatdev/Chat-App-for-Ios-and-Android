import 'package:chatting/Helper/color.dart';
import 'package:chatting/logic/Profile_setup/profile_setup_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:sizer/sizer.dart';

class usernamechange extends StatefulWidget {
  const usernamechange({Key key, this.myuid}) : super(key: key);
  final String myuid;

  @override
  State<usernamechange> createState() => _usernamechangeState();
}

class _usernamechangeState extends State<usernamechange> {
  TextEditingController username = TextEditingController();
  bool isextingusername = false;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return LoadingOverlay(
      isLoading: loading,
      progressIndicator:
          CupertinoActivityIndicator(color: Theme.of(context).iconTheme.color),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 1,
          iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            "Username Change",
            style: TextStyle(color: Theme.of(context).iconTheme.color),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Center(
              child: TextField(
            controller: username,
            onChanged: (value) {
              FirebaseFirestore.instance
                  .collection("user")
                  .where("username", isEqualTo: value)
                  .get()
                  .then((value) {
                setState(() {
                  isextingusername = value.docs.isNotEmpty ? true : false;
                });
              });
            },
            textInputAction: TextInputAction.send,
            keyboardType: TextInputType.name,
            onSubmitted: isextingusername && username.text.isNotEmpty
                ? null
                : (value) {
                    setState(() {
                      loading = true;
                    });
                    FirebaseFirestore.instance
                        .collection("user")
                        .doc(widget.myuid)
                        .update({"username": username.text}).then((value) {
                      setState(() {
                        loading = false;
                      });
                      Navigator.of(context).pop();
                    });
                  },
            cursorColor: Theme.of(context).iconTheme.color,
            style: TextStyle(
                fontSize: 15.sp, color: Theme.of(context).iconTheme.color),
            decoration: InputDecoration(
                errorText:
                    isextingusername ? "This username already exist" : null,
                hintText: "Enter your Username",
                suffixIcon: IconButton(
                    onPressed: isextingusername && username.text.isNotEmpty
                        ? null
                        : () {
                            setState(() {
                              loading = true;
                            });
                            FirebaseFirestore.instance
                                .collection("user")
                                .doc(widget.myuid)
                                .update({"username": username.text}).then(
                                    (value) {
                              setState(() {
                                loading = false;
                              });
                              Navigator.of(context).pop();
                            });
                          },
                    icon: Icon(
                      CupertinoIcons.arrow_right,
                      color: Theme.of(context).iconTheme.color,
                    )),
                filled: true,
                fillColor: isDarkMode
                    ? HexColor.fromHex("#1a1a1c")
                    : HexColor.fromHex("#ffffff"),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10.sp))),
          )),
        ),
      ),
    );
  }
}
