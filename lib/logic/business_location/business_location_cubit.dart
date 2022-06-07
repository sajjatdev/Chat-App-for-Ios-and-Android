import 'package:bloc/bloc.dart';
import 'package:chatting/Services/location/get_location.dart';

import 'package:equatable/equatable.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

part 'business_location_state.dart';

class BusinessLocationCubit extends Cubit<BusinessLocationState> {
  final Get_Location locations;
  BusinessLocationCubit(this.locations) : super(BusinessLocationInitial());

  Future<void> get_location() async {
    emit(Loading_location());
    Position pos = await locations.determinePosition();
    if (pos.latitude != null) {
      final coordinates = Coordinates(pos.latitude, pos.longitude);

      var address =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      emit(Has_Location(
          latitude: pos.latitude.toString(),
          longitude: pos.longitude.toString(),
          altitude: pos.altitude.toString(),
          speed: pos.speed.toString(),
          address: address.first.addressLine));
    } else {
      emit(Has_error_location(message: "Internet Error"));
    }
  }
}
