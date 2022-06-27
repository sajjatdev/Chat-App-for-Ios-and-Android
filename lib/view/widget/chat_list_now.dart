import 'package:chatting/view/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:getwidget/getwidget.dart';
import 'package:sizer/sizer.dart';

class ConversationList extends StatefulWidget {
  String name = '';
  String messageText = '';
  String imageUrl = '';
  String time = '';
  String type;
  String uid = '';
  final String status;
  String Room_ID;
  bool isMessageRead;
  String MessageType;
  ConversationList(
      {@required this.name,
      @required this.uid,
      @required this.messageText,
      @required this.imageUrl,
      @required this.time,
      @required this.isMessageRead,
      @required this.type,
      @required this.Room_ID,
      @required this.MessageType,
      @required this.status});
  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        print(widget.Room_ID);
        Navigator.of(context).pushNamed('/messageing', arguments: {
          'otheruid': widget.uid,
          'type': widget.type,
          "Single_Room_ID": widget.Room_ID,
        });
      },
      title: Text(
        widget.name,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 15.sp),
      ),
      leading: Stack(children: [
        if (widget.imageUrl.contains("https://")) ...[
          CircleAvatar(
            maxRadius: 20,
            backgroundImage: NetworkImage(widget.imageUrl),
          )
        ] else ...[
          ProfilePicture(
            name: widget.name.trim(),
            radius: 20,
            fontsize: 12.sp,
          )
        ],
        Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              height: 10.0,
              width: 10.0,
              decoration: BoxDecoration(
                  color: widget.status == 'online' ? Colors.green : Colors.grey,
                  borderRadius: BorderRadius.circular(10)),
            ))
      ]),
      subtitle: SizedBox(
        width: 70.w,
        child: widget.MessageType != null
            ? widget.MessageType == 'text'
                ? Text(
                    widget.messageText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: 12.sp, color: Colors.grey.shade400),
                  )
                : widget.MessageType == 'voice'
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.mic,
                          color: Theme.of(context).iconTheme.color,
                        ))
                    : widget.MessageType == "image"
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              Icons.image,
                              color: Theme.of(context).iconTheme.color,
                            ))
                        : Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              Icons.link,
                              color: Theme.of(context).iconTheme.color,
                            ))
            : Container(),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.time,
            style: TextStyle(
                fontSize: 12,
                fontWeight:
                    widget.isMessageRead ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
