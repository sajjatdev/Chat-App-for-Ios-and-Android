import 'package:chatting/Helper/Shimmer.dart';
import 'package:chatting/Helper/time.dart';
import 'package:chatting/view/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:sizer/sizer.dart';

import '../../model/get_message_list.dart';

class Message_user_list extends StatelessWidget {
  const Message_user_list({
    Key key,
    @required this.data,
  }) : super(key: key);

  final Get_message_list data;

  @override
  Widget build(BuildContext context) {
    return Container(
      // get user profile data
      child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('chat')
              .doc(data.Room_Name.trim())
              .get(),
          builder: (context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                  getRoom_data) {
            if (getRoom_data.hasData) {
              final Room_Data = getRoom_data.data.data();

              if (Room_Data['type'] == 'chat') {
                print(Room_Data['type']);
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
                          uid: user_data['uid'],
                          status: user_data['userStatus'],
                          time:
                              Time_Chat.readTimestamp(Room_Data['last_update']),
                          messageText: Room_Data['Last_message'] != null
                              ? Room_Data['Last_message']
                              : '',
                          type: "chat",
                          isMessageRead: false,
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
                    style: TextStyle(fontSize: 12.sp),
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(Room_Data['group_image']),
                    maxRadius: 20,
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //  Time_Chat.readTimestamp(Room_Data["last_update"])
                      Text(
                        DateTime.now().millisecondsSinceEpoch.toString(),
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
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

                return ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed('/messageing', arguments: {
                      'mamber_list': Room_Data['customer'],
                      'type': Room_Data['type'],
                      'otheruid': Room_Data['Business_Id'],
                    });
                  },
                  title: Text(
                    Room_Data['Business_Name'],
                    style: TextStyle(fontSize: 12.sp),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        Time_Chat.readTimestamp(Room_Data["last_update"]) ==
                                null
                            ? ""
                            : Time_Chat.readTimestamp(Room_Data["last_update"]),
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(Room_Data['imageURl']),
                    maxRadius: 20,
                  ),
                  subtitle: SizedBox(
                    width: 70.w,
                    child: Text(
                      Room_Data['Last_message'] != null
                          ? ""
                          : Room_Data['Last_message'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12.sp, color: Colors.grey.shade400),
                    ),
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
