import 'package:chatting/model/group_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Group_Services {
  final FirebaseFirestore firebaseFirestore;

  Group_Services(FirebaseFirestore firestore)
      : firebaseFirestore = firestore ?? FirebaseFirestore.instance;

  Stream<group_profile_model> get_group_data({String Room_ID}) {
    CollectionReference crf = firebaseFirestore.collection('chat');

    return crf.doc("onlineEnglishclass").snapshots().map(
        (DocumentSnapshot snapshot) => group_profile_model(
            admin: snapshot['admin'],
            mamber: snapshot['mamber'],
            groupName: snapshot['Group_name'],
            groupImage: snapshot["group_image"],
            groupUrl: snapshot['group_url'],
            description: snapshot['description']));
  }
}
