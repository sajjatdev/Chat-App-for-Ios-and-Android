part of 'phoneauth_bloc.dart';

abstract class PhoneauthState extends Equatable {
  const PhoneauthState();

  @override
  List<Object> get props => [];
}

class PhoneauthInitial extends PhoneauthState {}

class LoadingPhoneauth extends PhoneauthState {}

class PhoneAuthSuccess extends PhoneauthState {
  final String uid;

  PhoneAuthSuccess({this.uid});

  @override
  // TODO: implement props
  List<Object> get props => [uid];
}

class PhoneAuthFailure extends PhoneauthState {
  final String message;

  PhoneAuthFailure({this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}
