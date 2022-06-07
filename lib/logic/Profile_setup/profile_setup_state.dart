part of 'profile_setup_cubit.dart';

abstract class ProfileSetupState extends Equatable {
  const ProfileSetupState();

  @override
  List<Object> get props => [];
}

class ProfileSetupInitial extends ProfileSetupState {}

class loading extends ProfileSetupState {}

class addProfile extends ProfileSetupState {
  final String message;

  addProfile({this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}

class Errormessage extends ProfileSetupState {
  final String message;

  Errormessage({this.message});
  @override
  // TODO: implement props
  List<Object> get props => [message];
}
