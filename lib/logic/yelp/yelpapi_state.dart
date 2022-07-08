part of 'yelpapi_cubit.dart';

abstract class YelpapiState extends Equatable {
  const YelpapiState();

  @override
  List<Object> get props => [];
}

class YelpapiInitial extends YelpapiState {}

class Loading extends YelpapiState {}

class YelpDataGet extends YelpapiState {
  final List<yelp_model> yelpdata;

  YelpDataGet({this.yelpdata});

  @override
  // TODO: implement props
  List<Object> get props => [this.yelpdata];
}

class YelpdataEmpty extends YelpapiState {}

class YelpError extends YelpapiState {
  final String message;

  YelpError({this.message});

  @override
  // TODO: implement props
  List<Object> get props => [this.message];
}
