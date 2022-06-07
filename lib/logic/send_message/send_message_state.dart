part of 'send_message_cubit.dart';

abstract class SendMessageState extends Equatable {
  const SendMessageState();

  @override
  List<Object> get props => [];
}

class SendMessageInitial extends SendMessageState {}

class message_send extends SendMessageState {
  final String Message;

  message_send(this.Message);
  @override
  // TODO: implement props
  List<Object> get props => [Message];
}

class message_send_error extends SendMessageState {
  final String message_error;

  message_send_error(this.message_error);

  @override
  // TODO: implement props
  List<Object> get props => [message_error];
}
