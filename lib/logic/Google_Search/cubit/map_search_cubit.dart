import 'package:bloc/bloc.dart';
import 'package:chatting/Services/Google%20Map/SearchMap.dart';
import 'package:chatting/model/Google%20Map%20/Map_Search.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';

part 'map_search_state.dart';

class MapSearchCubit extends Cubit<MapSearchState> {
  final MapServices mapsearch;
  MapSearchCubit({this.mapsearch}) : super(MapSearchInitial());

  Future<void> MapSearchdata({String Address}) async {
    try {
      List<Google_map_search> Mapdata =
          await mapsearch.googleMapSearch(address: Address);

      if (Mapdata.isNotEmpty) {
        debugPrint(Mapdata.length.toString());
        emit(GetDataformGoogle(GetDataFormGoogle: Mapdata));
      } else {
        emit(error());
      }
    } catch (e) {
      emit(error());
    }
  }
}
