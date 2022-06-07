import 'package:chatting/model/Fir_contact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseContact {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Stream<List<GetFireContactList>> GetContactList(
      {String Keyword, bool isSearch, bool search_number}) {
    final res = firebaseFirestore.collection('user');
    if (isSearch) {
      // Is Search code
      return res
          .where(search_number ? "Phone_keyword" : "keyword_name",
              arrayContains: Keyword)
          .snapshots()
          .map((QuerySnapshot snapshot) => snapshot.docs
              .map((DocumentSnapshot documentSnapshot) => GetFireContactList(
                  firstName: documentSnapshot['first_name'],
                  lastName: documentSnapshot['last_name'],
                  phoneNumber: documentSnapshot['Phone_number'],
                  imageUrl: documentSnapshot["imageUrl"],
                  username: documentSnapshot["username"],
                  tag: documentSnapshot["first_name"][0].toUpperCase(),
                  userStatus: documentSnapshot['userStatus']))
              .toList());
      // +8801915823583
    } else {
      // is not search code
      return res.snapshots().map((QuerySnapshot snapshot) => snapshot.docs
          .map((DocumentSnapshot documentSnapshot) => GetFireContactList(
              firstName: documentSnapshot['first_name'],
              lastName: documentSnapshot['last_name'],
              phoneNumber: documentSnapshot['Phone_number'],
              imageUrl: documentSnapshot["imageUrl"],
              username: documentSnapshot["username"],
              tag: documentSnapshot["first_name"][0].toUpperCase(),
              userStatus: documentSnapshot['userStatus']))
          .toList());
    }
  }
}
