import 'package:chatting/Helper/utils.dart';
import 'package:chatting/model/business_model.dart';
import 'package:chatting/model/contact.dart';
import 'package:chatting/model/group_model.dart';
import 'package:chatting/model/profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class cloud_FireStore {
  final FirebaseFirestore firebaseFirestore;

  cloud_FireStore(FirebaseFirestore firestore)
      : firebaseFirestore = firestore ?? FirebaseFirestore.instance;

  Future<void> setup_profile(
      {String Firstname,
      String lastname,
      String username,
      String imageURL,
      String phone_number,
      String uid}) async {
    List<String> nameKeyword = keyword_name(names: Firstname);
    List<String> phoneKeyword = keyword_phones(phones: phone_number);

    CollectionReference users = firebaseFirestore.collection('user');
    users.doc(uid).set({
      'first_name': Firstname,
      'last_name': lastname == '' ? '' : lastname,
      'username': username,
      'imageUrl': imageURL,
      'Phone_number': phone_number,
      'userStatus': 'online',
      'keyword_name': nameKeyword,
      "Phone_keyword": phoneKeyword,
      'uid': uid,
    }).then((value) {
      print("Profile Setup Done");
    });
  }

  List<String> keyword_name({String names}) {
    List<String> keyword_name = [];
    String name = '';
    for (var i = 0; i < names.length; i++) {
      name += names[i];
      keyword_name.add(name);
    }
    return keyword_name;
  }

  List<String> keyword_phones({String phones}) {
    List<String> keyword_phone = [];
    String phone = '';

    for (var i = 0; i < phones.length; i++) {
      phone += phones[i];
      keyword_phone.add(phone);
    }
    return keyword_phone;
  }

  Future<profile_model> getUserdata({
    String uid,
  }) async {
    DocumentSnapshot snapshot =
        await firebaseFirestore.collection('user').doc(uid).get();
    return profile_model.fromJson(snapshot.data());
  }

  Future<group_model> getGroupdata({String uid}) async {
    DocumentSnapshot snapshot =
        await firebaseFirestore.collection('chat').doc(uid).get();
    return group_model.fromJson(snapshot.data());
  }

  Future<business_model> getbusinessdata({String uid}) async {
    DocumentSnapshot snapshot =
        await firebaseFirestore.collection('chat').doc(uid).get();
    return business_model.fromJson(snapshot.data());
  }

  Stream<List<Contact_list>> getuserconact({String search, String myuid}) {
    final ref = FirebaseFirestore.instance.collection('user');

    if (search == 'NONE') {
      return ref
          .orderBy('first_name', descending: false)
          .snapshots()
          .map((QuerySnapshot snapshot) => snapshot.docs
              .map((DocumentSnapshot documentSnapshot) => Contact_list(
                    firstName: documentSnapshot['first_name'],
                    imageUrl: documentSnapshot['imageUrl'],
                    uid: documentSnapshot['uid'],
                    username: documentSnapshot['username'],
                  ))
              .toList());
    } else {
      return ref
          .orderBy('first_name', descending: false)
          .where('first_name', isEqualTo: search)
          .snapshots()
          .map((QuerySnapshot snapshot) => snapshot.docs
              .map((DocumentSnapshot documentSnapshot) => Contact_list(
                    firstName: documentSnapshot['first_name'],
                    imageUrl: documentSnapshot['imageUrl'],
                    uid: documentSnapshot['uid'],
                    username: documentSnapshot['username'],
                  ))
              .toList());
    }
  }
}
