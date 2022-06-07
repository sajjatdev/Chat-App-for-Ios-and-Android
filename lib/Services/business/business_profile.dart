import 'package:chatting/model/business_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Business_Profile_Services {
  final FirebaseFirestore firebaseFirestore;

  Business_Profile_Services(FirebaseFirestore firestore)
      : firebaseFirestore = firestore ?? FirebaseFirestore.instance;

  Stream<business_model> get_business_profile_data({String Room_ID}) {
    CollectionReference crf = firebaseFirestore.collection('chat');
    return crf.doc(Room_ID).snapshots().map((DocumentSnapshot snapshot) =>
        business_model.fromJson(snapshot.data()));
  }
}
