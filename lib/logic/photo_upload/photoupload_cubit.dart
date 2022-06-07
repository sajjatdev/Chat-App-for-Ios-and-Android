import 'package:bloc/bloc.dart';
import 'package:chatting/Services/fireStore.dart';
import 'package:equatable/equatable.dart';

part 'photoupload_state.dart';

class PhotouploadCubit extends Cubit<PhotouploadState> {
  final FireStore fireStore;
  PhotouploadCubit(this.fireStore) : super(PhotouploadInitial());

  Future<void> updateData(String path, String name, String uid) async {
    emit(loadingimage());
    try {
      String imageurl = await fireStore.uploadFile(path, name, uid);

      if (imageurl != null) {
        emit(photouploadss(ImageURL: imageurl));
      }
    } catch (e) {}
  }
}
