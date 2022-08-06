part of 'yelp_search_cubit.dart';

abstract class MapSearchState extends Equatable {
  const MapSearchState();

  @override
  List<Object> get props => [];
}

class DefaultMapdata extends MapSearchState {
  final List<DefaultMapdatas> defaultdata;

  DefaultMapdata({this.defaultdata});

  @override
  // TODO: implement props
  List<Object> get props => [this.defaultdata];
}

class MapSearchInitial extends MapSearchState {}

class Loading extends MapSearchState {}

class GetDataformGoogle extends MapSearchState {
  final YelpSearchModel GetDataFormGoogle;
  final bool ismoveSearch;
  GetDataformGoogle({this.ismoveSearch, this.GetDataFormGoogle});

  @override
  // TODO: implement props
  List<Object> get props => [GetDataFormGoogle];
}

class MoveSearch extends MapSearchState {
  final YelpSearchModel MoveSearchs;

  MoveSearch({this.MoveSearchs});

  @override
  // TODO: implement props
  List<Object> get props => [MoveSearchs];
}

class error extends MapSearchState {}
