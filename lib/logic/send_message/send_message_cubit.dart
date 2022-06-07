import 'package:bloc/bloc.dart';
import 'package:chatting/Services/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'send_message_state.dart';

class SendMessageCubit extends Cubit<SendMessageState> {
  final messageing sendmessage;
  SendMessageCubit(this.sendmessage) : super(SendMessageInitial());

  Future<void> send_message({
    String message,
    String sender,
    List users,
    String myuid,
    String message_type,
    String other_uid,
    String RoomID,
    String type,
  }) async {
    if (type == 'chat') {
      await sendmessage.send_message(
        message: message,
        users: users,
        sender: sender,
        RoomID: RoomID,
        message_type: message_type,
        myuid: myuid,
        type: type,
        other_uid: other_uid,
      );
    }
    if (type == 'group') {
      await sendmessage.Group_messagesend(
        message: message,
        mamber: users,
        sender: sender,
        message_type: message_type,
        RoomID: RoomID,
        type: type,
      );
    }
    if (type == 'business') {
      print(users);
      await sendmessage.business_messagesend(
        message: message,
        mamber: users,
        sender: sender,
        message_type: message_type,
        RoomID: RoomID,
        type: type,
      );
    }
  }
}
