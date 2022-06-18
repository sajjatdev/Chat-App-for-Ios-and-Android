import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chatting/Services/group/group_services.dart';
import 'package:chatting/model/group_profile.dart';
import 'package:equatable/equatable.dart';

part 'group_profile_state.dart';

class GroupProfileCubit extends Cubit<GroupProfileState> {
  final Group_Services group_services;
  StreamSubscription streamSubscription;
  GroupProfileCubit(this.group_services) : super(GroupProfileInitial());

  Future<void> Get_Group_Data({String Room_Id}) {
    emit(Group_Data_loading());
    streamSubscription =
        group_services.get_group_data(Room_ID: Room_Id).listen((event) {
      print(event.admin);
      if (event.groupName != null) {
        emit(Success_Get_Group_Data(group_profile: event));
      } else {
        emit(Group_data_Error(message: "Not Find any Data"));
      }
    });
  }
}
