import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class FireStore {
  Future<String> uploadFile(String path, String name, String uid) async {
    File file = File(path);
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('userimage/${uid}/${name}')
          .putFile(file);

      String imagurl = await firebase_storage.FirebaseStorage.instance
          .ref('userimage/${uid}/${name}')
          .getDownloadURL();

      return imagurl;
    } on firebase_core.FirebaseException catch (e) {
      print(e.toString());
    }
  }
}
