import 'package:chatting/model/business_hours.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_place/google_place.dart';

class Business_Services {
  final FirebaseFirestore firebaseFirestore;

  Business_Services(FirebaseFirestore firestore)
      : firebaseFirestore = firestore ?? FirebaseFirestore.instance;

  Future<void> create_business(
      {String address,
      var latitude,
      var longitude,
      String imageURl,
      String Business_Name,
      String Business_Id,
      String owner,
      String description,
      List customer,
      SearchResult BusinessHours,
      String type}) async {
    List days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday:",
      "Saturday",
      "Sunday",
    ];

    await firebaseFirestore.collection('chat').doc(Business_Id).set({
      'Business_Name': Business_Name,
      "Business_Id": Business_Id,
      "imageURl": imageURl,
      "owner": [owner],
      "business_date_and_time": DateTime.now().millisecondsSinceEpoch,
      "description": description,
      "customer": customer,
      "message_type": null,
      "type": type,
      "latitude": latitude,
      "longitude": longitude,
      "address": address,
      "business_status": true,
      "Last_Time": DateTime.now().millisecondsSinceEpoch.toString(),
    }).then((value) {
      for (var i = 0; i < BusinessHours.openingHours.weekdayText.length; i++) {
        if (BusinessHours.openingHours.weekdayText[i].split(":")[1].trim() !=
            "Closed") {
          FirebaseFirestore.instance
              .collection('chat')
              .doc(Business_Id)
              .collection("Business_Hours")
              .doc(days[i])
              .set({"open":BusinessHours.openingHours.periods[i].open.time});
        }
      }
      firebaseFirestore
          .collection('chat')
          .doc(Business_Id)
          .collection("Request_notification")
          .doc("re");
      firebaseFirestore
          .collection('user')
          .doc(owner)
          .collection("Friends")
          .doc(Business_Id)
          .set({
        "Room_ID": Business_Id,
        "time": DateTime.now().millisecondsSinceEpoch.toString(),
        "type": type,
        "uid": Business_Id,
      });

      firebaseFirestore.collection('marker').doc(Business_Id).set({
        'Business_Name': Business_Name,
        "Business_Id": Business_Id,
        "imageURl": imageURl,
        "owner": owner,
        "description": description,
        "customer": customer,
        "type": type,
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
      });
    });
  }

  // Stream<business_hours> get_business_hours({String Room_ID}) {
  //   CollectionReference data = firebaseFirestore.collection('chat');

  //   return data.doc(Room_ID).snapshots().map((DocumentSnapshot snapshot) =>
  //       business_hours.fromJson(snapshot.data()));
  // }
}
