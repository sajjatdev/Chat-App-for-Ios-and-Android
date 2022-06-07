class GetContactModel {
  String phoneNumber;
  String firstName;
  String lastName;
  String imageUrl;
  String uid;

  GetContactModel(
      {this.phoneNumber,
      this.firstName,
      this.lastName,
      this.imageUrl,
      this.uid});

  GetContactModel.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['Phone_number'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    imageUrl = json['imageUrl'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phoneNumber'] = this.phoneNumber;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['imageUrl'] = this.imageUrl;
    data['uid'] = this.uid;
    return data;
  }
}
