import 'package:chatting/Helper/config.dart';
import 'package:chatting/model/Yelp%20With%20Default/defaultMapdata.dart';
import 'package:chatting/model/yelp/yelp_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:google_place/google_place.dart';
import 'package:http/http.dart' as http;

import 'dart:convert' as convert;

class MapServices {
  Future<YelpSearchModel> YelpMapSearchFunction(
      {String Categoery,
      int radius,
      double lat,
      double lng,
      bool islocation,
      String Address}) async {
    try {
      var res = await http.get(
          Uri.parse(
              "https://api.yelp.com/v3/businesses/search?term=$Categoery&location=$Address&radius=500&limit=30"),
          headers: {"Authorization": "bearer $YELPAPIKEY"});

      if (res.statusCode == 200) {
        final JsonData = convert.jsonDecode(res.body);
        print(JsonData["businesses"].map((value) => value["id"]));
        return YelpSearchModel.fromJson(JsonData);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<YelpSearchModel> YelpMapSearchFunctionLatLng({
    String term,
    double lat,
    double lng,
  }) async {
    try {
      var res = await http.get(
          Uri.parse(
              "https://api.yelp.com/v3/businesses/search?term=$term&latitude=$lat&longitude=$lng&radius=500&limit=30"),
          headers: {"Authorization": "bearer $YELPAPIKEY"});

      if (res.statusCode == 200) {
        final JsonData = convert.jsonDecode(res.body);
        print(JsonData["businesses"].map((value) => value["id"]));
        return YelpSearchModel.fromJson(JsonData);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<YelpSearchModel> googleMapMoveSearch(
      {String Categoery, double lat, double lng}) async {
    try {
      try {
        var res = await http.get(
            Uri.parse(
                "https://api.yelp.com/v3/businesses/search?term=$Categoery&latitude=$lat&longitude=$lng&radius=500&limit=50"),
            headers: {"Authorization": "bearer $YELPAPIKEY"});

        if (res.statusCode == 200) {
          final JsonData = convert.jsonDecode(res.body);
          print(JsonData["businesses"].map((value) => value["id"]));
          return YelpSearchModel.fromJson(JsonData);
        }
      } catch (e) {
        print(e.toString());
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<DefaultMapdatas>> defaultMapdata() async {
    return FirebaseFirestore.instance.collection("marker").get().then((value) =>
        value.docs
            .map((QueryDocumentSnapshot documentSnapshot) =>
                DefaultMapdatas.fromJson(documentSnapshot.data()))
            .toList());
  }
}
