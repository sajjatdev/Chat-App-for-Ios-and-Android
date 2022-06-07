import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chatting/Services/Contact/Firebase_contact.dart';
import 'package:chatting/model/Fir_contact.dart';
import 'package:equatable/equatable.dart';

part 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  final FirebaseContact firebaseContact;
  StreamSubscription streamSubscription;
  ContactCubit(this.firebaseContact) : super(ContactInitial());
  Future<void> Getallcontactlist({bool isSearch, String keyword,bool search_number}) {
    emit(Loading());
    streamSubscription =
        firebaseContact.GetContactList(Keyword: keyword, isSearch: isSearch,search_number: search_number)
            .listen((event) {
      if (event.isNotEmpty) {
        print("Name Is ${event[0].firstName}");
        emit(hasContactdata(data: event));
      } else {
        emit(HasError(message: "Not Fount Data"));
      }
    });
  }
}
