import 'package:chatting/model/Google%20Map%20/Map_Search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert' as convert;

class MapServices {
  final String key = 'AIzaSyBuXdZID9cJRjTQ_DKW6rMIBsWYHSDIFjw';
  final String types = 'geocode';

  Future<List<Google_map_search>> googleMapSearch({String address}) async {
    try {
      String URl =
          "https://maps.googleapis.com/maps/api/place/textsearch/json?query=$address&key=$key";

      var response = await http.get(Uri.parse(URl));

      Map<String, dynamic> map = convert.json.decode(response.body);

      Iterable jsonList = map["results"];
      List<Google_map_search> businesses =
          jsonList.map((model) => Google_map_search.fromJson(model)).toList();
      debugPrint(jsonList.toString());
      return businesses;
    } catch (e) {
      print(e.toString());
    }
  }
}
