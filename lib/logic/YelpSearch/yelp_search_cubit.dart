import 'package:bloc/bloc.dart';
import 'package:chatting/Services/Yelp%20Bussiness/SearchMap.dart';

import 'package:chatting/model/Yelp%20With%20Default/defaultMapdata.dart';
import 'package:chatting/model/yelp/yelp_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';
import 'package:google_place/google_place.dart';

part 'yelp_search_state.dart';

class MapSearchCubit extends Cubit<MapSearchState> {
  final MapServices mapsearch;
  MapSearchCubit({this.mapsearch}) : super(MapSearchInitial());

  Future<void> MapSearchWithLatLng({
    double lat,
    double lng,
    int radius,
    String term,
  }) async {
    try {
      YelpSearchModel BusinessData =
          await mapsearch.YelpMapSearchFunctionLatLng(
        lat: lat,
        lng: lng,
        term: term,
      );

      if (BusinessData.businesses.isNotEmpty) {
        print(BusinessData.businesses.length);
        emit(GetDataformGoogle(
            GetDataFormGoogle: BusinessData, ismoveSearch: false));
      }
    } catch (e) {
      emit(error());
    }
  }

  Future<void> MapSearchdata({
    String address,
    String Categoery,
  }) async {
    try {
      YelpSearchModel BusinessData = await mapsearch.YelpMapSearchFunction(
        Address: address,
        Categoery: Categoery,
      );

      if (BusinessData.businesses.isNotEmpty) {
        print(BusinessData.businesses.length);
        emit(GetDataformGoogle(
            GetDataFormGoogle: BusinessData, ismoveSearch: false));
      }
    } catch (e) {
      emit(error());
    }
  }

  Future<void> DefaultMapDataFirebase() async {
    print("Default Map Marker data");
    try {
      List<DefaultMapdatas> defaultdata = await mapsearch.defaultMapdata();
      if (defaultdata.isNotEmpty) {
        print(defaultdata.length);
        emit(DefaultMapdata(defaultdata: defaultdata));
      }
    } catch (e) {}
  }

  Future<void> MapMoveSearchdata(
      {String Categoery, double lat, double lng}) async {
    try {
      YelpSearchModel BusinessData = await mapsearch.googleMapMoveSearch(
        Categoery: Categoery,
        lat: lat,
        lng: lng,
      );

      if (BusinessData.businesses.isNotEmpty) {
        print(BusinessData.businesses.length);
        emit(GetDataformGoogle(
            GetDataFormGoogle: BusinessData, ismoveSearch: true));
      }
    } catch (e) {
      emit(error());
    }
  }
}
