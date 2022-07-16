import 'package:bloc/bloc.dart';
import 'package:chatting/Services/Google%20Map/SearchMap.dart';
import 'package:chatting/model/Google%20Map%20/Map_Search.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';
import 'package:google_place/google_place.dart';

part 'map_search_state.dart';

class MapSearchCubit extends Cubit<MapSearchState> {
  final MapServices mapsearch;
  MapSearchCubit({this.mapsearch}) : super(MapSearchInitial());

  Future<void> MapSearchdata(
      {String address, double lat, double lng, int radius}) async {
    try {
      List<SearchResult> Mapdata = await mapsearch.googleMapSearch(
          address: address, lat: lat, lng: lng, radius: radius);

      if (Mapdata != null) {
        debugPrint(Mapdata.toString());
        emit(GetDataformGoogle(GetDataFormGoogle: Mapdata));
      } else {
        emit(error());
      }
    } catch (e) {
      emit(error());
    }
  }

  Future<void> MapMoveSearchdata(
      {String Address, double lat, double lng}) async {
    try {
      emit(Loading());
      List<SearchResult> Mapdata =
          await mapsearch.googleMapMoveSearch(lat: lat, lng: lng);
      if (Mapdata != null) {
        debugPrint(Mapdata.toString());
        emit(MoveSearch(MoveSearchs: Mapdata));
      } else {
        emit(error());
      }
    } catch (e) {
      emit(error());
    }
  }
}
