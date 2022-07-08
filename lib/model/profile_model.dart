import 'package:flutter/foundation.dart';

class profile_model {
  String fullName;
  String username;
  String imageUrl;
  String lastname;
  String phone;
  String userStatus;
  profile_model(
      {this.fullName,
      this.username,
      this.imageUrl,
      this.phone,
      this.userStatus,
      this.lastname});

  profile_model.fromJson(Map<String, dynamic> json) {
    lastname = json["last_name"];
    fullName = json['first_name'];
    phone = json['Phone_number'];
    username = json['username'];
    userStatus = json['userStatus'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.fullName;
    data['username'] = this.username;
    data['imageUrl'] = this.imageUrl;
    return data;
  }
}
