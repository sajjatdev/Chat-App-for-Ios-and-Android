class business_model {
  String businessName;
  String businessId;
  String imageURl;
  List owner;
  List admin;
  String description;
  List customer;
  String type;
  double latitude;
  double longitude;
  String address;
  bool business_status;
  String lastTime;

  business_model(
      {this.businessName,
      this.businessId,
      this.imageURl,
      this.owner,
      this.business_status,
      this.description,
      this.customer,
      this.type,
      this.latitude,
      this.longitude,
      this.address,
      this.lastTime});

  business_model.fromJson(Map<String, dynamic> json) {
    businessName = json['Business_Name'];
    businessId = json['Business_Id'];
    business_status = json['business_status'];
    imageURl = json['imageURl'];
    owner = json['owner'];
    admin = json['admin'];
    description = json['description'];
    customer = json['customer'];
    type = json['type'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    lastTime = json['Last_Time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Business_Name'] = this.businessName;
    data['Business_Id'] = this.businessId;
    data['imageURl'] = this.imageURl;
    data['owner'] = this.owner;
    data['description'] = this.description;
    data['customer'] = this.customer;
    data['type'] = this.type;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    data['Last_Time'] = this.lastTime;
    return data;
  }
}
