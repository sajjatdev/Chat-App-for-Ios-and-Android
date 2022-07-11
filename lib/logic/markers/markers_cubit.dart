import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chatting/Services/business/getMarker.dart';
import 'package:chatting/model/marker_model.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/ui/utils/stream_subscriber_mixin.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'markers_state.dart';

class MarkersCubit extends Cubit<MarkersState> {
  final GetMarker getMarker;
  StreamSubscription streamSubscription;
  MarkersCubit(this.getMarker) : super(MarkersInitial());

  Future<void> getMarkersData() {
    streamSubscription = getMarker.getmarker().listen((maker) {
      if (maker != null) {
        emit(has_marker(yelpdata: maker));
      } else {
        emit(notfind_marker(message: "Not Find Marker"));
      }
    });
  }
}
