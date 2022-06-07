import 'package:bloc/bloc.dart';
import 'package:chatting/Services/Profile_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'profile_setup_state.dart';

class ProfileSetupCubit extends Cubit<ProfileSetupState> {
  final cloud_FireStore cloud_fireStore;

  ProfileSetupCubit(this.cloud_fireStore) : super(ProfileSetupInitial());

  Future<void> set_profile(
      {String Firstname,
      String lastname,
      String username,
      String imageURL,
      String phone_number,
      String uid}) async {
    emit(loading());
    try {
      await cloud_fireStore.setup_profile(
          Firstname: Firstname,
          lastname: lastname,
          username: username,
          imageURL: imageURL,
          phone_number: phone_number,
          uid: uid);

      emit(addProfile(message: 'Success'));
    } on FirebaseException catch (e) {
      emit(Errormessage(message: e.toString()));
    }
  }
}
