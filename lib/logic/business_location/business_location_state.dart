part of 'business_location_cubit.dart';

abstract class BusinessLocationState extends Equatable {
  const BusinessLocationState();

  @override
  List<Object> get props => [];
}

class BusinessLocationInitial extends BusinessLocationState {}

class Loading_location extends BusinessLocationState {}

class Has_Location extends BusinessLocationState {
  final String latitude;
  final String longitude;
  final String altitude;
  final String speed;
  var address;

  Has_Location(
      {this.latitude, this.longitude, this.altitude, this.speed, this.address});

  @override
  // TODO: implement props
  List<Object> get props => [latitude, longitude, altitude, speed, address];
}

class Has_error_location extends BusinessLocationState {
  final String message;
  Has_error_location({this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}
