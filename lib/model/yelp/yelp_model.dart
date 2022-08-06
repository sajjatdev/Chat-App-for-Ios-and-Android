class YelpSearchModel {
  List<Businesses> businesses;

  YelpSearchModel({this.businesses});

  YelpSearchModel.fromJson(Map<String, dynamic> json) {
    if (json['businesses'] != null) {
      businesses = <Businesses>[];
      json['businesses'].forEach((v) {
        businesses.add(new Businesses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.businesses != null) {
      data['businesses'] = this.businesses.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Businesses {
  String id;
  String alias;
  String name;
  String imageUrl;
  bool isClosed;
  String url;
  int reviewCount;
  List<Categories> categories;
  double rating;
  Coordinates coordinates;
  String price;
  Location location;
  String phone;
  String displayPhone;
  double distance;

  Businesses(
      {this.id,
      this.alias,
      this.name,
      this.imageUrl,
      this.isClosed,
      this.url,
      this.reviewCount,
      this.categories,
      this.rating,
      this.coordinates,
      this.price,
      this.location,
      this.phone,
      this.displayPhone,
      this.distance});

  Businesses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    alias = json['alias'];
    name = json['name'];
    imageUrl = json['image_url'];
    isClosed = json['is_closed'];
    url = json['url'];
    reviewCount = json['review_count'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
    rating = json['rating'];
    coordinates = json['coordinates'] != null
        ? new Coordinates.fromJson(json['coordinates'])
        : null;
    price = json['price'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    phone = json['phone'];
    displayPhone = json['display_phone'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['alias'] = this.alias;
    data['name'] = this.name;
    data['image_url'] = this.imageUrl;
    data['is_closed'] = this.isClosed;
    data['url'] = this.url;
    data['review_count'] = this.reviewCount;
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    data['rating'] = this.rating;
    if (this.coordinates != null) {
      data['coordinates'] = this.coordinates.toJson();
    }

    data['price'] = this.price;
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    data['phone'] = this.phone;
    data['display_phone'] = this.displayPhone;
    data['distance'] = this.distance;
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

class Location {
  String address1;
  String address2;
  String address3;
  String city;
  String zipCode;
  String country;
  String state;
  List<String> displayAddress;

  Location(
      {this.address1,
      this.address2,
      this.address3,
      this.city,
      this.zipCode,
      this.country,
      this.state,
      this.displayAddress});

  Location.fromJson(Map<String, dynamic> json) {
    address1 = json['address1'];
    address2 = json['address2'];
    address3 = json['address3'];
    city = json['city'];
    zipCode = json['zip_code'];
    country = json['country'];
    state = json['state'];
    displayAddress = json['display_address'].cast<String>();
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
    return data;
  }
}
