
import 'package:url_launcher/url_launcher.dart';

class marker_model {
  final double rating;
  final String price;
  final String phone;
  final String id;
  final String name;

  final double latitude;
  final double longitude;
  final double distance;

  final String alias;
  final bool isClosed;
  final int reviewCount;

  final String url;
  final String imageUrl;

  final String address1;
  final String address2;
  final String address3;
  final String city;
  final String state;
  final String country;
  final String zip;

  marker_model(
      {this.rating,
      this.price,
      this.phone,
      this.id,
      this.name,
      this.latitude,
      this.longitude,
      this.distance,
      this.alias,
      this.isClosed,
      this.reviewCount,
      this.url,
      this.imageUrl,
      this.address1,
      this.address2,
      this.address3,
      this.city,
      this.state,
      this.country,
      this.zip});

  factory marker_model.fromJson(Map<String, dynamic> json) {
    return marker_model(
      rating: json['rating'],
      price: json['price'],
      phone: json['phone'],
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      distance: json['distance'],
      alias: json['alias'],
      isClosed: json['is_closed'],
      reviewCount: json['review_count'],
      url: json['url'],
      imageUrl: json['image_url'],
      address1: json['address1'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      zip: json['zip_code'],
    );
  }
}
