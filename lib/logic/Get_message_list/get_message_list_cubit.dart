import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chatting/Services/message.dart';
import 'package:chatting/model/get_message_list.dart';
import 'package:equatable/equatable.dart';

part 'get_message_list_state.dart';

class GetMessageListCubit extends Cubit<GetMessageListState> {
  final messageing _message;
  StreamSubscription streamSubscription;
  GetMessageListCubit(this._message) : super(GetMessageListInitial());

  Future<void> get_message_list({String myuid, bool ischeck}) {
    emit(Loadings());
    Future.delayed(Duration(milliseconds: 500), () {
      streamSubscription = _message
          .get_message_list(myuid: myuid, ischeck: ischeck)
          .listen((data) {
        if (data.isNotEmpty) {
          print("Welcome");
          emit(Message_list(contact_list: data));
        } else {
          emit(Contact_error_message(Message: "Not found any Data "));
        }
      });
    });
  }
}
