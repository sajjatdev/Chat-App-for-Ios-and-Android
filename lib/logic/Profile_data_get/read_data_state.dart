part of 'read_data_cubit.dart';

abstract class ReadDataState extends Equatable {
  const ReadDataState();

  @override
  List<Object> get props => [];
}

class ReadDataInitial extends ReadDataState {}

class Loadingstate extends ReadDataState {}

class getprofileData extends ReadDataState {
  final profile_model profile_data;

  getprofileData({this.profile_data});

  @override
  // TODO: implement props
  List<Object> get props => [profile_data];
}

class GroupData extends ReadDataState {
  final group_model group_data_get;

  GroupData({this.group_data_get});

  @override
  // TODO: implement props
  List<Object> get props => [group_data_get];
}

class BusinessData extends ReadDataState {
  final business_model business;

  BusinessData({this.business});

  @override
  // TODO: implement props
  List<Object> get props => [business];
}

class ErrorMessage extends ReadDataState {
  final String message;

  ErrorMessage({this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}
