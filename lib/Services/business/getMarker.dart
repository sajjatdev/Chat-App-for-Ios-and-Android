import 'package:chatting/model/marker_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetMarker {
  final FirebaseFirestore firebaseFirestore;

  GetMarker(FirebaseFirestore firestore)
      : firebaseFirestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<marker_model>> getmarker() {
    final ref = firebaseFirestore.collection('business_list');
    return ref.snapshots().map((QuerySnapshot snapshot) => snapshot.docs
        .map((DocumentSnapshot doc) => marker_model.fromJson(doc.data()))
        .toList());
  }
}
