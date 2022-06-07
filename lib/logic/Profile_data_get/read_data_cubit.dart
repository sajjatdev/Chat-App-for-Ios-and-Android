import 'package:bloc/bloc.dart';
import 'package:chatting/Services/Profile_database.dart';
import 'package:chatting/model/business_model.dart';
import 'package:chatting/model/group_model.dart';
import 'package:chatting/model/profile_model.dart';
import 'package:equatable/equatable.dart';

part 'read_data_state.dart';

class ReadDataCubit extends Cubit<ReadDataState> {
  final cloud_FireStore cloud_fireStore;
  ReadDataCubit(this.cloud_fireStore) : super(ReadDataInitial());

  Future<void> getprofile_data({String uid, String type}) async {
    emit(Loadingstate());
    if (type == 'profile') {
      profile_model modeldata = await cloud_fireStore.getUserdata(
        uid: uid,
      );
      print(modeldata.fullName);
      emit(getprofileData(profile_data: modeldata));
    }
    if (type == 'chat') {
      profile_model modeldata = await cloud_fireStore.getUserdata(
        uid: uid,
      );

      if (modeldata.fullName != null) {
        print("Full Name Is " + modeldata.fullName);
        emit(getprofileData(profile_data: modeldata));
      } else {
        emit(ErrorMessage(message: 'Internet Error'));
      }
    } else if (type == "group") {
      group_model modeldata = await cloud_fireStore.getGroupdata(
        uid: uid,
      );
      if (modeldata.groupName != null) {
        emit(GroupData(group_data_get: modeldata));
      }
    } else if (type == "business") {
      print("Business");
      business_model modeldata =
          await cloud_fireStore.getbusinessdata(uid: uid);
      if (modeldata.businessName != null) {
        emit(BusinessData(business: modeldata));
      } else {
        emit(ErrorMessage(message: 'Internet Error'));
      }
    }
  }
}
