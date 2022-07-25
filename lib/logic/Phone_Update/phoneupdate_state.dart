part of 'phoneupdate_cubit.dart';

abstract class PhoneupdateState extends Equatable {
  const PhoneupdateState();

  @override
  List<Object> get props => [];
}

class PhoneupdateInitial extends PhoneupdateState {
  @override
  // TODO: implement props
  List<Object> get props => super.props;
}

class Loading extends PhoneupdateState {
  @override
  // TODO: implement props
  List<Object> get props => super.props;
}

class Otpinvalid extends PhoneupdateState {
  final String Otpinvalidmessage;

  Otpinvalid({this.Otpinvalidmessage});

  @override
  // TODO: implement props
  List<Object> get props => [this.Otpinvalidmessage];
}

class OtpEx extends PhoneupdateState {
  final String OtpExmessage;

  OtpEx({this.OtpExmessage});

  @override
  // TODO: implement props
  List<Object> get props => [this.OtpExmessage];
}

class phone_invalid extends PhoneupdateState {
  final String phone_invalidmessage;

  phone_invalid({this.phone_invalidmessage});

  @override
  // TODO: implement props
  List<Object> get props => [this.phone_invalidmessage];
}

class Errorphone extends PhoneupdateState {
  final String Errorphonemessage;

  Errorphone({this.Errorphonemessage});

  @override
  // TODO: implement props
  List<Object> get props => [this.Errorphonemessage];
}

class VerifyDone extends PhoneupdateState {
  @override
  // TODO: implement props
  List<Object> get props => super.props;
}

class otpSend extends PhoneupdateState {
  final String otpSendmessage;

  otpSend({this.otpSendmessage});

  @override
  // TODO: implement props
  List<Object> get props => [this.otpSendmessage];
}
