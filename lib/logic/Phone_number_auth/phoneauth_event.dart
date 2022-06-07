part of 'phoneauth_bloc.dart';

abstract class PhoneauthEvent extends Equatable {
  const PhoneauthEvent();

  @override
  List<Object> get props => [];
}

class PhoneNumberVerify extends PhoneauthEvent {
  final String phoneNumber;

  PhoneNumberVerify({this.phoneNumber});

  @override
  // TODO: implement props
  List<Object> get props => [phoneNumber];
}

class VerifySMSCode extends PhoneauthEvent {
  final String smscode;

  VerifySMSCode({this.smscode});

  @override
  // TODO: implement props
  List<Object> get props => [smscode];
}
