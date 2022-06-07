part of 'business_profile_cubit.dart';

abstract class BusinessProfileState extends Equatable {
  const BusinessProfileState();

  @override
  List<Object> get props => [];
}

class BusinessProfileInitial extends BusinessProfileState {}

class BusinessLoading extends BusinessProfileState {}

class HasData_Business_Profile extends BusinessProfileState {
  final business_model business;

  HasData_Business_Profile({this.business});

  @override
  // TODO: implement props
  List<Object> get props => [business];
}

class Has_Error_Business_profile extends BusinessProfileState {
  final String message;

  Has_Error_Business_profile({this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}
