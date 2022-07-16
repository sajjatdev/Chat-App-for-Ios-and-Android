part of 'business_info_get_cubit.dart';

abstract class BusinessInfoGetState extends Equatable {
  const BusinessInfoGetState();

  @override
  List<Object> get props => [];
}

class BusinessInfoGetInitial extends BusinessInfoGetState {}

class loaingBusinss extends BusinessInfoGetState {}

class GetBusinessData extends BusinessInfoGetState {
  final List<DetailsResult> Businessdata;

  GetBusinessData({this.Businessdata});

  @override
  // TODO: implement props
  List<Object> get props => [Businessdata];
}

class DataGetError extends BusinessInfoGetState {}
