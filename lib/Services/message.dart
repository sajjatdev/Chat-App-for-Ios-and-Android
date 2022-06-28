import 'package:chatting/model/get_message_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../view/widget/SearchKey/search.dart';

class messageing {
  final FirebaseFirestore firebaseFirestore;

  messageing(
    FirebaseFirestore firestore,
  ) : firebaseFirestore = firestore ?? FirebaseFirestore.instance;

  Future<void> send_message({
    String message,
    String sender,
    List users,
    String myuid,
    String other_uid,
    String message_type,
    String type,
    String RoomID,
  }) async {
    CollectionReference sengle_chat =
        FirebaseFirestore.instance.collection('chat');

    await sengle_chat.doc(RoomID).collection("message").add({
      "sender": sender,
      "message": message,
      'type': type,
      "read": false,
      "message_type": message_type,
      "time": DateTime.now().millisecondsSinceEpoch
    }).then((value) {
      FirebaseFirestore.instance
          .collection("chat")
          .doc(RoomID)
          .collection("message_typing")
          .doc("typing")
          .set({"typing": false, "typing_user": sender});
      FirebaseFirestore.instance.collection('chat').doc(RoomID).update({
        "Last_message": message,
        'last_update': DateTime.now().millisecondsSinceEpoch,
        'users': users,
        "message_type": message_type,
        'type': type,
        'Room_ID': RoomID
      });
      FirebaseFirestore.instance
          .collection('user')
          .doc(myuid)
          .collection('Friends')
          .doc(other_uid)
          .set({
        'uid': other_uid,
        'Room_ID': RoomID,
        'type': type,
        'time': DateTime.now().millisecondsSinceEpoch
      });
      FirebaseFirestore.instance
          .collection('user')
          .doc(other_uid)
          .collection('Friends')
          .doc(myuid)
          .set({
        'uid': myuid,
        'Room_ID': RoomID,
        'type': type,
        'time': DateTime.now().millisecondsSinceEpoch
      });
    });
  }

  Future<void> Group_messagesend({
    String message,
    String sender,
    List mamber,
    String message_type,
    String type,
    String RoomID,
  }) async {
    CollectionReference sengle_chat =
        FirebaseFirestore.instance.collection('chat');
    List customer = mamber;
    await sengle_chat.doc(RoomID).collection("message").add({
      "sender": sender,
      "message": message,
      'type': type,
      "read": false,
      "message_type": message_type,
      "time": DateTime.now().millisecondsSinceEpoch
    }).then((value) {
      FirebaseFirestore.instance
          .collection("chat")
          .doc(RoomID)
          .collection("message_typing")
          .doc("typing")
          .set({"typing": false, "typing_user": sender});
      FirebaseFirestore.instance.collection('chat').doc(RoomID).update({
        "Last_message": message,
        'last_update': DateTime.now().millisecondsSinceEpoch,
        'type': type,
        'Room_ID': RoomID
      });
      for (var item in mamber) {
        FirebaseFirestore.instance
            .collection('user')
            .doc(item)
            .collection('Friends')
            .doc(RoomID)
            .set({
          'uid': item,
          'Room_ID': RoomID,
          'type': type,
          'time': DateTime.now().millisecondsSinceEpoch
        });

        if (customer != null) {
          for (var item in customer) {
            print("User UID is $item");
            FirebaseFirestore.instance
                .collection('user')
                .doc(item)
                .collection('Friends')
                .doc(RoomID)
                .set({
              'uid': item,
              'Room_ID': RoomID,
              'type': type,
              'time': DateTime.now().millisecondsSinceEpoch
            });
          }
        }
      }
    });
  }

  Future<void> business_messagesend({
    String message,
    String sender,
    List mamber,
    String type,
    String message_type,
    String RoomID,
  }) async {
    CollectionReference sengle_chat =
        FirebaseFirestore.instance.collection('chat');
    List customer = mamber;
    await sengle_chat.doc(RoomID).collection("message").add({
      "sender": sender,
      "message": message,
      'type': type,
      "read": false,
      "message_type": message_type,
      'message_time': DateTime.now(),
      "time": DateTime.now().millisecondsSinceEpoch
    }).then((value) {
      FirebaseFirestore.instance
          .collection("chat")
          .doc(RoomID)
          .collection("message_typing")
          .doc("typing")
          .set({"typing": false, "typing_user": sender});
      FirebaseFirestore.instance.collection('chat').doc(RoomID).update({
        "Last_message": message,
        'last_update': DateTime.now().millisecondsSinceEpoch,
        'type': type,
        'Room_ID': RoomID
      });

      if (customer != null) {
        for (var item in customer) {
          print("User UID is $item");
          FirebaseFirestore.instance
              .collection('user')
              .doc(item)
              .collection('Friends')
              .doc(RoomID)
              .set({
            'uid': item,
            'Room_ID': RoomID,
            'type': type,
            'time': DateTime.now().millisecondsSinceEpoch
          });
        }
      }
    });
  }

  Future<void> create_Group(
      {List admin,
      String group_name,
      String group_image,
      List mamber,
      String description,
      String group_username,
      String group_url}) async {
    FirebaseFirestore.instance.collection('chat').doc(group_username).set({
      'admin': admin,
      'Group_name': group_name,
      'group_image': group_image,
      'mamber': mamber,
      "type": "group",
      "description": description,
      "group_time": DateTime.now(),
      'Room_ID': group_username,
      'group_url': 'chatting/' + group_url,
    }).then((value) {
      for (var data in mamber) {
        FirebaseFirestore.instance
            .collection('user')
            .doc(data)
            .collection("Friends")
            .doc(group_username)
            .set({
          "Room_ID": group_username,
          "type": "group",
          "uid": group_username,
          'time': DateTime.now().millisecondsSinceEpoch,
          "keyword_name": SearchKeyGenerator(item: group_name),
        });
      }
    });
  }

  Stream<List<Get_message_list>> get_message_list(
      {String myuid, bool ischeck, String namekey}) {
    final ref = FirebaseFirestore.instance
        .collection('user')
        .doc(myuid)
        .collection("Friends");

    if (ischeck) {
      return ref.orderBy('time', descending: true).snapshots().map(
          (QuerySnapshot querySnapshot) => querySnapshot.docs
              .map((DocumentSnapshot snapshot) => Get_message_list(
                  Room_Name: snapshot['Room_ID'],
                  time: snapshot['time'].toString(),
                  type: snapshot['type'],
                  uid: snapshot['uid']))
              .toList());
    } else {
      if (namekey.contains("+")) {
        return ref
            .where("Phone_keyword", arrayContainsAny: [namekey])
            .snapshots()
            .map((QuerySnapshot querySnapshot) => querySnapshot.docs
                .map((DocumentSnapshot snapshot) => Get_message_list(
                    Room_Name: snapshot['Room_ID'],
                    time: snapshot['time'].toString(),
                    type: snapshot['type'],
                    uid: snapshot['uid']))
                .toList());
      } else {
        return ref
            .where("keyword_name", arrayContainsAny: [namekey])
            .snapshots()
            .map((QuerySnapshot querySnapshot) => querySnapshot.docs
                .map((DocumentSnapshot snapshot) => Get_message_list(
                    Room_Name: snapshot['Room_ID'],
                    time: snapshot['time'].toString(),
                    type: snapshot['type'],
                    uid: snapshot['uid']))
                .toList());
      }
    }
  }
}
