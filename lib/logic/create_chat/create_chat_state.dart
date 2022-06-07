part of 'create_chat_cubit.dart';

abstract class CreateChatState extends Equatable {
  const CreateChatState();

  @override
  List<Object> get props => [];
}

class CreateChatInitial extends CreateChatState {}

class create_cuccess extends CreateChatState {
  final String uid;

  create_cuccess(this.uid);

  @override
  // TODO: implement props
  List<Object> get props => [uid];
}

class Create_error extends CreateChatState {
  final String message;

  Create_error(this.message);
}
