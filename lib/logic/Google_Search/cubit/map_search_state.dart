part of 'map_search_cubit.dart';

abstract class MapSearchState extends Equatable {
  const MapSearchState();

  @override
  List<Object> get props => [];
}

class MapSearchInitial extends MapSearchState {}

class GetDataformGoogle extends MapSearchState {
  final List<Google_map_search> GetDataFormGoogle;

  GetDataformGoogle({this.GetDataFormGoogle});

  @override
  // TODO: implement props
  List<Object> get props => [GetDataFormGoogle];
}

class error extends MapSearchState{
  
}
