part of 'map_search_cubit.dart';

abstract class MapSearchState extends Equatable {
  const MapSearchState();

  @override
  List<Object> get props => [];
}

class MapSearchInitial extends MapSearchState {}
class Loading extends MapSearchState{}
class GetDataformGoogle extends MapSearchState {
  final List<SearchResult> GetDataFormGoogle;

  GetDataformGoogle({this.GetDataFormGoogle});

  @override
  // TODO: implement props
  List<Object> get props => [GetDataFormGoogle];
}

class MoveSearch extends MapSearchState {
  final List<SearchResult> MoveSearchs;

  MoveSearch({this.MoveSearchs});

  @override
  // TODO: implement props
  List<Object> get props => [MoveSearchs];
}

class error extends MapSearchState {}
