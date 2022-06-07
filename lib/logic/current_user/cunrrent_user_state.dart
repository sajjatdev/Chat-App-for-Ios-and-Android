part of 'cunrrent_user_bloc.dart';

abstract class CunrrentUserState extends Equatable {
  const CunrrentUserState();

  @override
  List<Object> get props => [];
}

class CunrrentUserInitial extends CunrrentUserState {}

class hasdata extends CunrrentUserState {
  final User user;

  hasdata({this.user});

  @override
  // TODO: implement props
  List<Object> get props => [user];
}
