import 'package:chatting/model/marker_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetMarker {
  final FirebaseFirestore firebaseFirestore;

  GetMarker(FirebaseFirestore firestore)
      : firebaseFirestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<marker_model>> getmarker() {
    final ref = firebaseFirestore.collection('marker');
    return ref.snapshots().map((QuerySnapshot snapshot) => snapshot.docs
        .map((DocumentSnapshot doc) => marker_model(
              markerId: doc['Business_Id'],
              business_id: doc['Business_Id'],
              ImageUrl: doc['imageURl'],
              Address: doc['address'],
              type: doc['type'],
              customer: doc['customer'],
              latitude: double.parse(doc["latitude"]),
              longitude: double.parse(doc["longitude"]),
              Descritpion: doc['description'],
              title: doc['Business_Name'],
            ))
        .toList());
  }
}
