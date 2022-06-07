part of 'authstatus_bloc.dart';

abstract class AuthstatusState extends Equatable {
  const AuthstatusState();

  @override
  List<Object> get props => [];
}

class AuthstatusInitial extends AuthstatusState {}

class statusloding extends AuthstatusState {}

class UserStatus extends AuthstatusState {
  final bool authstatuscheck;

  UserStatus({this.authstatuscheck});
  @override
  // TODO: implement props
  List<Object> get props => [authstatuscheck];
}

class statusError extends AuthstatusState {
  final String message;

  statusError(this.message);
  @override
  // TODO: implement props
  List<Object> get props => [message];
}
