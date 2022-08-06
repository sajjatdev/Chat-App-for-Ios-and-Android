class YelpBusinessDetails {
  String id;
  String alias;
  String name;
  String imageUrl;
  bool isClaimed;
  bool isClosed;
  String url;
  String phone;
  String displayPhone;
  int reviewCount;
  List<Categories> categories;
  double rating;
  Location location;
  Coordinates coordinates;
  List<String> photos;
  String price;
  List<Hours> hours;

  List<SpecialHours> specialHours;

  YelpBusinessDetails(
      {this.id,
      this.alias,
      this.name,
      this.imageUrl,
      this.isClaimed,
      this.isClosed,
      this.url,
      this.phone,
      this.displayPhone,
      this.reviewCount,
      this.categories,
      this.rating,
      this.location,
      this.coordinates,
      this.photos,
      this.price,
      this.hours,
      this.specialHours});

  YelpBusinessDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    alias = json['alias'];
    name = json['name'];
    imageUrl = json['image_url'];
    isClaimed = json['is_claimed'];
    isClosed = json['is_closed'];
    url = json['url'];
    phone = json['phone'];
    displayPhone = json['display_phone'];
    reviewCount = json['review_count'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
    rating = json['rating'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    coordinates = json['coordinates'] != null
        ? new Coordinates.fromJson(json['coordinates'])
        : null;
    photos = json['photos'].cast<String>();
    price = json['price'];
    if (json['hours'] != null) {
      hours = <Hours>[];
      json['hours'].forEach((v) {
        hours.add(new Hours.fromJson(v));
      });
    }
  
    if (json['special_hours'] != null) {
      specialHours = <SpecialHours>[];
      json['special_hours'].forEach((v) {
        specialHours.add(new SpecialHours.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['alias'] = this.alias;
    data['name'] = this.name;
    data['image_url'] = this.imageUrl;
    data['is_claimed'] = this.isClaimed;
    data['is_closed'] = this.isClosed;
    data['url'] = this.url;
    data['phone'] = this.phone;
    data['display_phone'] = this.displayPhone;
    data['review_count'] = this.reviewCount;
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    data['rating'] = this.rating;
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    if (this.coordinates != null) {
      data['coordinates'] = this.coordinates.toJson();
    }
    data['photos'] = this.photos;
    data['price'] = this.price;
    if (this.hours != null) {
      data['hours'] = this.hours.map((v) => v.toJson()).toList();
    }
  
    if (this.specialHours != null) {
      data['special_hours'] =
          this.specialHours.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  String alias;
  String title;

  Categories({this.alias, this.title});

  Categories.fromJson(Map<String, dynamic> json) {
    alias = json['alias'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['alias'] = this.alias;
    data['title'] = this.title;
    return data;
  }
}

class Location {
  String address1;
  String address2;
  String address3;
  String city;
  String zipCode;
  String country;
  String state;
  List<String> displayAddress;
  String crossStreets;

  Location(
      {this.address1,
      this.address2,
      this.address3,
      this.city,
      this.zipCode,
      this.country,
      this.state,
      this.displayAddress,
      this.crossStreets});

  Location.fromJson(Map<String, dynamic> json) {
    address1 = json['address1'];
    address2 = json['address2'];
    address3 = json['address3'];
    city = json['city'];
    zipCode = json['zip_code'];
    country = json['country'];
    state = json['state'];
    displayAddress = json['display_address'].cast<String>();
    crossStreets = json['cross_streets'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    data['address3'] = this.address3;
    data['city'] = this.city;
    data['zip_code'] = this.zipCode;
    data['country'] = this.country;
    data['state'] = this.state;
    data['display_address'] = this.displayAddress;
    data['cross_streets'] = this.crossStreets;
    return data;
  }
}

class Coordinates {
  double latitude;
  double longitude;

  Coordinates({this.latitude, this.longitude});

  Coordinates.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class Hours {
  List<Open> open;
  String hoursType;
  bool isOpenNow;

  Hours({this.open, this.hoursType, this.isOpenNow});

  Hours.fromJson(Map<String, dynamic> json) {
    if (json['open'] != null) {
      open = <Open>[];
      json['open'].forEach((v) {
        open.add(new Open.fromJson(v));
      });
    }
    hoursType = json['hours_type'];
    isOpenNow = json['is_open_now'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.open != null) {
      data['open'] = this.open.map((v) => v.toJson()).toList();
    }
    data['hours_type'] = this.hoursType;
    data['is_open_now'] = this.isOpenNow;
    return data;
  }
}

class Open {
  bool isOvernight;
  String start;
  String end;
  int day;

  Open({this.isOvernight, this.start, this.end, this.day});

  Open.fromJson(Map<String, dynamic> json) {
    isOvernight = json['is_overnight'];
    start = json['start'];
    end = json['end'];
    day = json['day'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_overnight'] = this.isOvernight;
    data['start'] = this.start;
    data['end'] = this.end;
    data['day'] = this.day;
    return data;
  }
}

class SpecialHours {
  String date;
  bool isClosed;
  String start;
  String end;
  bool isOvernight;

  SpecialHours(
      {this.date, this.isClosed, this.start, this.end, this.isOvernight});

  SpecialHours.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    isClosed = json['is_closed'];
    start = json['start'];
    end = json['end'];
    isOvernight = json['is_overnight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['is_closed'] = this.isClosed;
    data['start'] = this.start;
    data['end'] = this.end;
    data['is_overnight'] = this.isOvernight;
    return data;
  }
}
