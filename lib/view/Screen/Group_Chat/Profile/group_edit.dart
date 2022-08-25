import 'package:chatting/Helper/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Group_edit extends StatefulWidget {
  const Group_edit({Key key, this.data, this.is_title, this.room_data})
      : super(key: key);
  final String data;
  final bool is_title;
  final String room_data;
  @override
  State<Group_edit> createState() => _Group_editState();
}

class _Group_editState extends State<Group_edit> {
  TextEditingController data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = TextEditingController(text: widget.data);
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            "Edit ",
            style: TextStyle(color: Theme.of(context).iconTheme.color),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 15.w,
                decoration: BoxDecoration(
                    color: isDarkMode
                        ? HexColor.fromHex("#1a1a1c")
                        : HexColor.fromHex("#ffffff"),
                    borderRadius: BorderRadius.circular(20)),
                child: TextField(
                  controller: data,
                  onSubmitted: (String value) {
                    if (widget.is_title) {
                      FirebaseFirestore.instance
                          .collection('chat')
                          .doc(widget.room_data)
                          .update({"Group_name": value});
                      Navigator.of(context).pop();
                    } else {
                      FirebaseFirestore.instance
                          .collection('chat')
                          .doc(widget.room_data)
                          .update({"description": value});
                      Navigator.of(context).pop();
                    }
                  },
                  cursorColor: Theme.of(context).iconTheme.color,
                  style: TextStyle(
                      fontSize: 18.sp,
                      color: Theme.of(context).iconTheme.color),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
