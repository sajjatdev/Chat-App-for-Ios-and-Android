import 'package:chatting/model/business_hours.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_place/google_place.dart';
import 'package:yelp_fusion_client/models/business_endpoints/business_details.dart';

class Business_Services {
  final FirebaseFirestore firebaseFirestore;

  Business_Services(FirebaseFirestore firestore)
      : firebaseFirestore = firestore ?? FirebaseFirestore.instance;

  Future<void> create_business({
    bool isowner,
    String myuid,
    BusinessDetails businessDetails,
  }) async {
    print(businessDetails.name);
    List days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];

    await firebaseFirestore.collection('chat').doc(businessDetails.id).set({
      'Business_Name': businessDetails.name,
      "Business_Id": businessDetails.id,
      "imageURl": businessDetails.imageUrl ?? businessDetails.name,
      "owner": isowner ? [myuid] : [],
      "admin": [myuid],
      "business_date_and_time": DateTime.now().millisecondsSinceEpoch,
      "description": "",
      "customer": [myuid],
      "message_type": null,
      "type": "business",
      "latitude": businessDetails.coordinates.latitude,
      "longitude": businessDetails.coordinates.longitude,
      "address": businessDetails.location.displayAddress[0] +
          " " +
          businessDetails.location.displayAddress[1],
      "business_status": true,
      "Last_Time": DateTime.now().millisecondsSinceEpoch.toString(),
    }).then((value) {
      print("Business Create Start");

      try {
        for (var i = 0; i < businessDetails.hours.hours[0].open.length; i++) {
          print(businessDetails.hours.hours[0].open[i].day == i
              ? days[i]
              : "Close");

          if (businessDetails.hours.hours[0].open[i].day == i) {
            FirebaseFirestore.instance
                .collection('chat')
                .doc(businessDetails.id)
                .collection("Business_Hours")
                .doc(days[businessDetails.hours.hours[0].open[i].day])
                .set({
              "day": days[businessDetails.hours.hours[0].open[i].day],
              "open": businessDetails.hours.hours[0].open[i].start,
              "close": businessDetails.hours.hours[0].open[i].end,
              "isOvernight": businessDetails.hours.hours[0].open[i].isOvernight
            });
          } else {
            print("Off");
            FirebaseFirestore.instance
                .collection('chat')
                .doc(businessDetails.id)
                .collection("Business_Hours")
                .doc(days[businessDetails.hours.hours[0].open[i].day])
                .set({
              "day": days[businessDetails.hours.hours[0].open[i].day],
              "Status": "Off",
            });
          }
        }
        // Notification Request Database Start
        firebaseFirestore
            .collection('chat')
            .doc(businessDetails.id)
            .collection("Request_notification")
            .doc("re");
        // END

        // User Add Business
        FirebaseFirestore.instance
            .collection('user')
            .doc(myuid)
            .collection("Friend")
            .doc(businessDetails.id)
            .set({
          "Room_ID": businessDetails.id,
          "time": DateTime.now().millisecondsSinceEpoch.toString(),
          "type": "business",
          "uid": businessDetails.id,
        });

        // END

        // Google Marker Add Database
        firebaseFirestore.collection('marker').doc(businessDetails.id).set({
          'Business_Name': businessDetails.name,
          "Business_Id": businessDetails.id,
          "imageURl": businessDetails.photos ?? businessDetails.name,
          "business_date_and_time": DateTime.now().millisecondsSinceEpoch,
          "description": "",
          "customer": [myuid],
          "message_type": null,
          "type": "business",
          "latitude": businessDetails.coordinates.latitude,
          "longitude": businessDetails.coordinates.longitude,
          "address": businessDetails.location.displayAddress[0] +
              " " +
              businessDetails.location.displayAddress[1],
          "business_status": true,
          "Last_Time": DateTime.now().millisecondsSinceEpoch.toString(),
        });
      } catch (e) {}

      //END
    });
  }

  // Stream<business_hours> get_business_hours({String Room_ID}) {
  //   CollectionReference data = firebaseFirestore.collection('chat');

  //   return data.doc(Room_ID).snapshots().map((DocumentSnapshot snapshot) =>
  //       business_hours.fromJson(snapshot.data()));
  // }
}
