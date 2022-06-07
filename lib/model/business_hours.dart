class business_hours {
  String businessId;
  String businessName;
  List<BusinessHours> businessHours;
  String lastTime;
  String lastMessage;
  String roomID;
  String address;
  bool businessStatus;
  List<String> customer;
  String description;
  String imageURl;
  int lastUpdate;
  String latitude;
  String longitude;
  List<String> owner;
  String type;

  business_hours(
      {this.businessId,
      this.businessName,
      this.businessHours,
      this.lastTime,
      this.lastMessage,
      this.roomID,
      this.address,
      this.businessStatus,
      this.customer,
      this.description,
      this.imageURl,
      this.lastUpdate,
      this.latitude,
      this.longitude,
      this.owner,
      this.type});

  business_hours.fromJson(Map<String, dynamic> json) {
    businessId = json['Business_Id'];
    businessName = json['Business_Name'];
    if (json['Business_hours'] != null) {
      businessHours = <BusinessHours>[];
      json['Business_hours'].forEach((v) {
        businessHours.add(new BusinessHours.fromJson(v));
      });
    }
    lastTime = json['Last_Time'];
    lastMessage = json['Last_message'];
    roomID = json['Room_ID'];
    address = json['address'];
    businessStatus = json['business_status'];
    customer = json['customer'].cast<String>();
    description = json['description'];
    imageURl = json['imageURl'];
    lastUpdate = json['last_update'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    owner = json['owner'].cast<String>();
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Business_Id'] = this.businessId;
    data['Business_Name'] = this.businessName;
    if (this.businessHours != null) {
      data['Business_hours'] =
          this.businessHours.map((v) => v.toJson()).toList();
    }
    data['Last_Time'] = this.lastTime;
    data['Last_message'] = this.lastMessage;
    data['Room_ID'] = this.roomID;
    data['address'] = this.address;
    data['business_status'] = this.businessStatus;
    data['customer'] = this.customer;
    data['description'] = this.description;
    data['imageURl'] = this.imageURl;
    data['last_update'] = this.lastUpdate;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['owner'] = this.owner;
    data['type'] = this.type;
    return data;
  }
}

class BusinessHours {
  List<Day> mon;
  List<Day> tue;
  List<Day> wed;
  List<Day> thu;
  List<Day> fir;
  List<Day> sat;
  List<Day> sun;

  BusinessHours(
      {this.mon, this.tue, this.wed, this.thu, this.fir, this.sat, this.sun});

  BusinessHours.fromJson(Map<String, dynamic> json) {
    if (json['mon'] != null) {
      mon = <Day>[];
      json['mon'].forEach((v) {
        mon.add(new Day.fromJson(v));
      });
    }
    if (json['tue'] != null) {
      tue = <Day>[];
      json['tue'].forEach((v) {
        tue.add(new Day.fromJson(v));
      });
    }
    if (json['wed'] != null) {
      wed = <Day>[];
      json['wed'].forEach((v) {
        wed.add(new Day.fromJson(v));
      });
    }
    if (json['thu'] != null) {
      thu = <Day>[];
      json['thu'].forEach((v) {
        thu.add(new Day.fromJson(v));
      });
    }
    if (json['fir'] != null) {
      fir = <Day>[];
      json['fir'].forEach((v) {
        fir.add(new Day.fromJson(v));
      });
    }
    if (json['sat'] != null) {
      sat = <Day>[];
      json['sat'].forEach((v) {
        sat.add(new Day.fromJson(v));
      });
    }
    if (json['sun'] != null) {
      sun = <Day>[];
      json['sun'].forEach((v) {
        sun.add(new Day.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mon != null) {
      data['mon'] = this.mon.map((v) => v.toJson()).toList();
    }
    if (this.tue != null) {
      data['tue'] = this.tue.map((v) => v.toJson()).toList();
    }
    if (this.wed != null) {
      data['wed'] = this.wed.map((v) => v.toJson()).toList();
    }
    if (this.thu != null) {
      data['thu'] = this.thu.map((v) => v.toJson()).toList();
    }
    if (this.fir != null) {
      data['fir'] = this.fir.map((v) => v.toJson()).toList();
    }
    if (this.sat != null) {
      data['sat'] = this.sat.map((v) => v.toJson()).toList();
    }
    if (this.sun != null) {
      data['sun'] = this.sun.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Day {
  String cls;
  String open;

  Day({this.cls, this.open});

  Day.fromJson(Map<String, dynamic> json) {
    cls = json['cls'];
    open = json['open'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cls'] = this.cls;
    data['open'] = this.open;
    return data;
  }
}
