part of 'get_message_list_cubit.dart';

abstract class GetMessageListState extends Equatable {
  const GetMessageListState();

  @override
  List<Object> get props => [];
}

class GetMessageListInitial extends GetMessageListState {}

class Loadings extends GetMessageListState {}

class Message_list extends GetMessageListState {
  final List<Get_message_list> contact_list;

  Message_list({this.contact_list});
}

class Contact_error_message extends GetMessageListState {
  final String Message;

  Contact_error_message({this.Message});
}
