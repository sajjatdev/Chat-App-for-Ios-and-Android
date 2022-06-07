part of 'business_create_cubit.dart';

abstract class BusinessCreateState extends Equatable {
  const BusinessCreateState();

  @override
  List<Object> get props => [];
}

class BusinessCreateInitial extends BusinessCreateState {}

class Business_create_success extends BusinessCreateState {}

class Business_create_Error extends BusinessCreateState {}
