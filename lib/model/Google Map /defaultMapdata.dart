class DefaultMapdata {
  String businessId;
  String businessName;
  String address;
  String imageURl;
  String latitude;
  String longitude;

  DefaultMapdata(
      {this.businessId,
      this.businessName,
      this.address,
      this.imageURl,
      this.latitude,
      this.longitude});

  DefaultMapdata.fromJson(Map<String, dynamic> json) {
    businessId = json['Business_Id'];
    businessName = json['Business_Name'];
    address = json['address'];
    imageURl = json['imageURl'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Business_Id'] = this.businessId;
    data['Business_Name'] = this.businessName;
    data['address'] = this.address;
    data['imageURl'] = this.imageURl;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
