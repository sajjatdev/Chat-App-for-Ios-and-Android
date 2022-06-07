part of 'markers_cubit.dart';

abstract class MarkersState extends Equatable {
  const MarkersState();

  @override
  List<Object> get props => [];
}

class MarkersInitial extends MarkersState {}

class has_marker extends MarkersState {
  final List<marker_model> marker_list;

  has_marker({this.marker_list});

  @override
  // TODO: implement props
  List<Object> get props => [marker_list];
}

class notfind_marker extends MarkersState {
  final String message;

  notfind_marker({this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}
