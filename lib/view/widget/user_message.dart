import 'package:chatting/Helper/Shimmer.dart';
import 'package:chatting/Helper/time.dart';
import 'package:chatting/view/Screen/business/chat/ChatView.dart';
import 'package:chatting/view/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:sizer/sizer.dart';

import '../../model/get_message_list.dart';

class Message_user_list extends StatelessWidget {
  const Message_user_list({
    Key key,
    @required this.data,
    this.uid,
  }) : super(key: key);

  final Get_message_list data;
  final String uid;

  @override
  Widget build(BuildContext context) {
    return Container(
      // get user profile data
      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('chat')
              .doc(data.Room_Name)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                  getRoom_data) {
            if (getRoom_data.hasData) {
              final Room_Data = getRoom_data.data.data();

              if (Room_Data['type'] == 'chat') {
                return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('user')
                        .doc(data.uid)
                        .get(),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> getuserdata) {
                      if (getuserdata.hasData) {
                        Map<String, dynamic> user_data =
                            getuserdata.data.data() as Map<String, dynamic>;

                        return ConversationList(
                          imageUrl: user_data['imageUrl'],
                          name: user_data['first_name'],
                          last_name: user_data["last_name"],
                          uid: user_data['uid'],
                          status: user_data['userStatus'],
                          Room_ID: data.Room_Name,
                          time:
                              Time_Chat.readTimestamp(Room_Data['last_update']),
                          messageText: Room_Data['Last_message'] ?? '',
                          type: "chat",
                          MessageType: Room_Data['message_type'],
                          isMessageRead: true,
                        );
                      } else {
                        return Container();
                      }
                    });
              }
              if (Room_Data['type'] == 'group' &&
                  Room_Data['Group_name'] != null) {
                return ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed('/messageing', arguments: {
                      'mamber_list': Room_Data['mamber'],
                      'type': Room_Data['type'],
                      'otheruid': Room_Data['Room_ID'],
                    });
                  },
                  title: Text(
                    Room_Data['Group_name'],
                    style: TextStyle(fontSize: 15.sp),
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(Room_Data['group_image']),
                    maxRadius: 20,
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (Room_Data["last_update"] != null) ...[
                        Text(
                          Time_Chat.readTimestamp(Room_Data["last_update"]),
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).iconTheme.color),
                        ),
                      ],
                    ],
                  ),
                  subtitle: SizedBox(
                    width: 70.w,
                    child: Text(
                      "sajjat",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12.sp, color: Colors.grey.shade400),
                    ),
                  ),
                );
              }
              if (Room_Data['type'] == 'business' &&
                  Room_Data['Business_Name'] != null) {
                // Add Image Icon and time and title online etc.
                String imagecheck = Room_Data['imageURl'];
                return ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChatView(
                              roomId: Room_Data['Business_Id'],
                              uid: uid,
                            )));
                    // Navigator.of(context).pushNamed('/messageing', arguments: {
                    //   'mamber_list': Room_Data['customer'],
                    //   'type': Room_Data['type'],
                    //   'otheruid': Room_Data['Business_Id'],
                    // });
                  },
                  title: Text(
                    Room_Data['Business_Name'],
                    style: TextStyle(fontSize: 15.sp),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        Time_Chat.readTimestamp(Room_Data["last_update"]) ?? "",
                        style: TextStyle(
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                  leading: imagecheck.contains("https://")
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(Room_Data['imageURl']),
                          maxRadius: 20,
                        )
                      : ProfilePicture(
                          name: imagecheck, radius: 18.sp, fontsize: 18.sp),
                  subtitle: SizedBox(
                    width: 70.w,
                    child: Room_Data["message_type"] != null
                        ? Room_Data["message_type"] == 'text'
                            ? Text(
                                Room_Data["message_type"],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey.shade400),
                              )
                            : Room_Data["message_type"] == 'voice'
                                ? Align(
                                    alignment: Alignment.centerLeft,
                                    child: Icon(
                                      Icons.mic,
                                      color: Theme.of(context).iconTheme.color,
                                    ))
                                : Room_Data["message_type"] == "image"
                                    ? Align(
                                        alignment: Alignment.centerLeft,
                                        child: Icon(
                                          Icons.image,
                                          color:
                                              Theme.of(context).iconTheme.color,
                                        ))
                                    : Align(
                                        alignment: Alignment.centerLeft,
                                        child: Icon(
                                          Icons.link,
                                          color:
                                              Theme.of(context).iconTheme.color,
                                        ))
                        : Container(),
                  ),
                );
              } else {
                return GFShimmer(
                  child: emptyBlock(context),
                );
              }
            } else {
              return GFShimmer(
                child: emptyBlock(context),
              );
            }
          }),
    );
  }
}
