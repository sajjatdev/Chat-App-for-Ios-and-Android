part of 'group_profile_cubit.dart';

abstract class GroupProfileState extends Equatable {
  const GroupProfileState();

  @override
  List<Object> get props => [];
}

class Group_Data_loading extends GroupProfileState {}

class GroupProfileInitial extends GroupProfileState {}

class Success_Get_Group_Data extends GroupProfileState {
  final group_profile_model group_profile;

  Success_Get_Group_Data({this.group_profile});

  @override
  // TODO: implement props
  List<Object> get props => [group_profile];
}

class Group_data_Error extends GroupProfileState {
  final String message;

  Group_data_Error({this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}
