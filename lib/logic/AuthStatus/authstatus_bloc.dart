import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chatting/Services/Auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'authstatus_event.dart';
part 'authstatus_state.dart';

class AuthstatusBloc extends Bloc<AuthstatusEvent, AuthstatusState> {
  final AuthProvider authProvider;
  User userdatas;
  StreamSubscription streamSubscription;
  AuthstatusBloc(this.authProvider) : super(AuthstatusInitial()) {
    emit(statusloding());
    streamSubscription = authProvider.authstatus().listen((userdata) {
      if (userdata == null) {
        emit(UserStatus(authstatuscheck: false));
      } else {
        emit(UserStatus(authstatuscheck: true));
      }
    });
  }

  @override
  Future<void> close() {
    // TODO: implement close
    streamSubscription.cancel();
    return super.close();
  }
}
