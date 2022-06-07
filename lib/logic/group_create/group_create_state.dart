part of 'group_create_cubit.dart';

abstract class GroupCreateState extends Equatable {
  const GroupCreateState();

  @override
  List<Object> get props => [];
}

class GroupCreateInitial extends GroupCreateState {}

class LoadingState extends GroupCreateState {}

class crateGroupSuccess extends GroupCreateState {
  final String group_id;

  crateGroupSuccess(this.group_id);

  @override
  // TODO: implement props
  List<Object> get props => [group_id];
}

class CreateError extends GroupCreateState {
  final String message;

  CreateError(this.message);
  @override
  // TODO: implement props
  List<Object> get props => [message];
}
