import 'package:google_place/google_place.dart';
import 'package:http/http.dart' as http;

import 'dart:convert' as convert;

class MapServices {
  final String key = 'AIzaSyBuXdZID9cJRjTQ_DKW6rMIBsWYHSDIFjw';
  final String types = 'geocode';

  Future<List<SearchResult>> googleMapSearch(
      {String address, double lat, double lng, int radius}) async {
    try {
      var googlePlace = GooglePlace(key);
      var result = await googlePlace.search.getTextSearch(address,
          radius: radius, location: Location(lat: lat, lng: lng));

      if (result.results != null) {
        return result.results;
      } else {
        result = await googlePlace.search.getTextSearch(address,
            radius: radius, location: Location(lat: lat, lng: lng));
        return result.results;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<SearchResult>> googleMapMoveSearch(
      {String address, double lat, double lng}) async {
    try {
      var googlePlace = GooglePlace(key);
      var result = await googlePlace.search.getTextSearch(address);

      if (result.results != null) {
        return result.results;
      } else {
        result = await googlePlace.search.getTextSearch(address,
            location: Location(lat: lat, lng: lng), radius: 2000);
        return result.results;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  /// Business info
  Future<List<DetailsResult>> googleMapBusinessInfo(
      {List<SearchResult> id, String name}) async {
    List<DetailsResult> BusinessData = [];
    try {
      var googlePlace = GooglePlace(key);
      for (var i = 0; i < id.length; i++) {
        final result =
            await googlePlace.details.get(id[i].placeId).then((value) {
          print("Done");
        });
        BusinessData.add(result.result);
      }

      return BusinessData;
    } catch (e) {
      print(e.toString());
    }
  }
}