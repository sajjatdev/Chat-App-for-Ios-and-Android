import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chatting/Services/Profile_database.dart';
import 'package:chatting/model/contact.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/ui/utils/stream_subscriber_mixin.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final cloud_FireStore cloud_fireStore;
  StreamSubscription streamSubscription;
  SearchCubit(this.cloud_fireStore) : super(SearchInitial());

  Future<void> getcontact_list({String search, String myUID}) {
    emit(Loading());
    Future.delayed(Duration(milliseconds: 500), () {
      streamSubscription = cloud_fireStore
          .getuserconact(search: search, myuid: myUID)
          .listen((data) {
        if (data != null) {
          emit(Contact_show(contact_list: data));
        } else {
          emit(Contact_error(Message: "Contact Error"));
          streamSubscription.cancel();
        }
      });
    });
  }
}
